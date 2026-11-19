#include <assert.h>
#include "mock.h"
#include "lwip_app_mocked.c"

static XTime test_now;
static int fail_mode, mock_allocs, mock_frees, mock_udp_calls, ctrl_polls;
static unsigned char mock_payload[UDP_TEST_BUF], assembled[10000];
static struct pbuf mock_pbuf;
static struct udp_pcb mock_pcb;
u32 *pFrames1[NUM_FRAMES];

void XTime_GetTime(XTime *value) { *value = test_now; }
struct pbuf *pbuf_alloc(int layer, u16_t len, int type)
{
    (void)layer; (void)type;
    if (fail_mode == 1) return NULL;
    assert(len <= sizeof(mock_payload));
    ++mock_allocs;
    mock_pbuf.payload = mock_payload;
    mock_pbuf.len = mock_pbuf.tot_len = len;
    return &mock_pbuf;
}
err_t pbuf_take(struct pbuf *p, const void *data, u16_t len)
{
    if (fail_mode == 2) return ERR_VAL;
    memcpy(p->payload, data, len);
    return ERR_OK;
}
static u32 get_u32(const unsigned char *p)
{
    return ((u32)p[0] << 24) | ((u32)p[1] << 16) | ((u32)p[2] << 8) | p[3];
}
err_t udp_sendto(struct udp_pcb *pcb, struct pbuf *p, const ip_addr_t *address, u16_t port)
{
    unsigned char *d = p->payload;
    (void)pcb; (void)address;
    assert(port == 8081);
    ++mock_udp_calls;
    if (fail_mode == 3) return ERR_VAL;
    if (p->len == 1) return ERR_OK;
    assert(p->len >= 16 && memcmp(d, "KJPG", 4) == 0);
    assert(get_u32(d + 4) == snapshot_id);
    assert(get_u32(d + 8) == snapshot_size);
    assert(get_u32(d + 12) == snapshot_offset);
    assert(snapshot_offset + p->len - 16 <= sizeof(assembled));
    memcpy(assembled + snapshot_offset, d + 16, p->len - 16);
    return ERR_OK;
}
u8 pbuf_free(struct pbuf *p) { assert(p == &mock_pbuf); ++mock_frees; return 1; }
int jpeg_pipeline_busy(void) { return 0; }
void jpeg_pipeline_poll(void) { }
void jpeg_pipeline_stop(void) { }
int jpeg_pipeline_failed(void) { return 0; }
int jpeg_pipeline_claim(const unsigned char **data, size_t *size, unsigned int *token)
{ (void)data; (void)size; (void)token; return 0; }
void jpeg_pipeline_release(unsigned int token) { (void)token; }
void xemacif_input(struct netif *interface) { (void)interface; }
size_t jpeg_snapshot_capture(const unsigned char **data) { (void)data; return 0; }
void xil_printf(const char *format, ...) { (void)format; }
#if LWIP_DHCP
volatile int dhcp_timoutcntr;
void dhcp_stop(struct netif *interface) { (void)interface; }
void print(char *text) { (void)text; }
int inet_aton(const char *text, ip_addr_t *address) { (void)text; address->addr=0; return 1; }
void netif_set_addr(struct netif *interface, const ip_addr_t *ip, const ip_addr_t *mask, const ip_addr_t *gw)
{ (void)interface; (void)ip; (void)mask; (void)gw; }
#endif

static void reset_test(void)
{
    test_now = 1000000;
    fail_mode = mock_allocs = mock_frees = mock_udp_calls = 0;
    memset(assembled, 0, sizeof(assembled));
    memset(&jpeg_tx_diag, 0, sizeof(jpeg_tx_diag));
    jpeg_tx_diag_active = 0;
    snapshot_pending = snapshot_warmup = snapshot_target_warmed = 0;
    snapshot_offset = snapshot_size = 0;
    snapshot_deadline = 0;
    snapshot_id = 100;
    mjpeg_enabled = 1;
    pipeline_tx_active = 0;
    udp8080_pcb = &mock_pcb;
    jpeg_tx_diag_start();
}

static void tick_snapshot(void)
{
    if (test_now < snapshot_deadline) test_now = snapshot_deadline;
    snapshot_poll(test_now);
}

int main(void)
{
    unsigned char jpeg[3000];
    unsigned i;
    for (i = 0; i < sizeof(jpeg); ++i) jpeg[i] = (unsigned char)(i % 251);

    reset_test();
    snapshot_data = jpeg; snapshot_size = sizeof(jpeg);
    tick_snapshot();
    assert(snapshot_offset == 1384 && snapshot_deadline == test_now + 100);
    tick_snapshot(); tick_snapshot();
    assert(snapshot_size == 0 && mock_udp_calls == 3 && mock_allocs == 3 && mock_frees == 3);
    assert(memcmp(jpeg, assembled, sizeof(jpeg)) == 0);
    assert(jpeg_tx_diag.attempts == 3 && jpeg_tx_diag.accepted == 3);
    assert(jpeg_tx_diag.completed_frames == 1 && jpeg_tx_diag.dropped_frames == 0);
    assert(jpeg_tx_diag.first_id == 100 && jpeg_tx_diag.last_id == 100);

    for (i = 1; i <= 3; ++i) {
        reset_test(); snapshot_data = jpeg; snapshot_size = sizeof(jpeg);
        tick_snapshot();
        assert(snapshot_offset == 1384 && jpeg_tx_diag.accepted == 1);
        fail_mode = (int)i; snapshot_target_warmed = 1;
        tick_snapshot();
        assert(snapshot_size == 0 && snapshot_offset == 1384 && snapshot_target_warmed == 0);
        assert(jpeg_tx_diag.attempts == 2 && jpeg_tx_diag.accepted == 1);
        assert(jpeg_tx_diag.dropped_frames == 1 && jpeg_tx_diag.completed_frames == 0);
        assert(jpeg_tx_diag.alloc_errors == (i == 1));
        assert(jpeg_tx_diag.take_errors == (i == 2));
        assert(jpeg_tx_diag.udp_errors == (i == 3));
        assert(mock_allocs == mock_frees);
    }

    reset_test(); snapshot_data = jpeg; snapshot_size = sizeof(jpeg);
    snapshot_warmup = 1; fail_mode = 1;
    tick_snapshot();
    assert(jpeg_tx_diag.warmup_attempts == 1 && jpeg_tx_diag.warmup_failures == 1);
    assert(jpeg_tx_diag.attempts == 0 && jpeg_tx_diag.alloc_errors == 0);
    assert(snapshot_size == sizeof(jpeg) && snapshot_warmup == 0);

    reset_test(); snapshot_data = jpeg; snapshot_size = sizeof(jpeg);
    tick_snapshot();
    test_now += 5 * COUNTS_PER_SECOND;
    jpeg_tx_diag_poll(test_now);
    assert(jpeg_tx_diag_active == 1 && jpeg_tx_diag.attempts == 0);
    snapshot_size = 0; mjpeg_enabled = 0;
    jpeg_tx_diag_poll(test_now + 100);
    assert(jpeg_tx_diag_active == 0);

    reset_test();
    network_initialized = address_ready = 1;
    ctrl_polls = 0;
    netif = &server_netif;
    frame_active = 0; WriteOneFrameEnd[0] = -1;
    snapshot_data = jpeg; snapshot_size = sizeof(jpeg);
    while (snapshot_size) {
        if (test_now < snapshot_deadline) test_now = snapshot_deadline;
        lwip_stream_poll();
    }
    assert(ctrl_polls == 0); /* no control work in the middle of a frame */
    assert(jpeg_tx_diag.completed_frames == 1 && jpeg_tx_diag.attempts == 3);
    mjpeg_enabled = 0;
    lwip_stream_poll();
    assert(ctrl_polls == 1); /* processed after the frame boundary */
    assert(jpeg_tx_diag_active == 0 && mock_udp_calls == 3);

    puts("PASS: packet payload/offset/pacing, failures, warmup, interval/final reports, stream poll");
    return 0;
}

int gui_control_start(void) { return 0; }
void gui_control_poll(void) { ++ctrl_polls; }
