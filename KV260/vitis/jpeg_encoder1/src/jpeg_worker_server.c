#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <setjmp.h>
#include <jpeglib.h>
#include <jerror.h>
#include "xil_cache.h"
#include "xtime_l.h"
#include "jpeg_worker_mailbox.h"

#define IMAGE_WIDTH 3840U
#define IMAGE_HEIGHT 2160U
#define ROW_BYTES (IMAGE_WIDTH * 3U)
#define IMAGE_BYTES (ROW_BYTES * IMAGE_HEIGHT)
#define JPEG_CAPACITY (8U * 1024U * 1024U)
#define JPEG_QUALITY 65

/* Each worker ELF owns this buffer inside its own 128 MB DDR region. */
static unsigned char jpeg_output[JPEG_CAPACITY] __attribute__((aligned(64)));
static struct jpeg_compress_struct encoder;
static struct jpeg_error_mgr error_manager;
static struct jpeg_destination_mgr destination;
static jmp_buf recovery;
static char error_text[JMSG_LENGTH_MAX];
volatile uint32_t jpeg_worker_last_error;

static void jpeg_fail(j_common_ptr cinfo)
{
    (*cinfo->err->format_message)(cinfo, error_text);
    longjmp(recovery, 1);
}
static void init_destination(j_compress_ptr cinfo)
{
    cinfo->dest->next_output_byte = jpeg_output;
    cinfo->dest->free_in_buffer = sizeof(jpeg_output);
}
static boolean destination_full(j_compress_ptr cinfo)
{
    ERREXIT(cinfo, JERR_BUFFER_SIZE);
    return FALSE;
}
static void finish_destination(j_compress_ptr cinfo)
{
    (void)cinfo;
}

static size_t encode_frame(const unsigned char *pixels)
{
    size_t output_size;
    memset(&encoder, 0, sizeof(encoder));
    encoder.err = jpeg_std_error(&error_manager);
    error_manager.error_exit = jpeg_fail;
    if (setjmp(recovery)) {
        if (encoder.mem != NULL)
            jpeg_destroy_compress(&encoder);
        jpeg_worker_last_error = 1;
        return 0;
    }
    jpeg_create_compress(&encoder);
    destination.init_destination = init_destination;
    destination.empty_output_buffer = destination_full;
    destination.term_destination = finish_destination;
    encoder.dest = &destination;
    encoder.image_width = IMAGE_WIDTH;
    encoder.image_height = IMAGE_HEIGHT;
    encoder.input_components = 3;
    encoder.in_color_space = JCS_RGB;
    jpeg_set_defaults(&encoder);
    jpeg_set_quality(&encoder, JPEG_QUALITY, TRUE);
    encoder.dct_method = JDCT_IFAST;
    encoder.optimize_coding = FALSE;
    jpeg_start_compress(&encoder, TRUE);
    while (encoder.next_scanline < encoder.image_height) {
        JSAMPROW row = (JSAMPROW)(pixels + (size_t)encoder.next_scanline * ROW_BYTES);
        if (jpeg_write_scanlines(&encoder, &row, 1) != 1)
            ERREXIT(&encoder, JERR_CANT_SUSPEND);
    }
    jpeg_finish_compress(&encoder);
    output_size = sizeof(jpeg_output) - encoder.dest->free_in_buffer;
    jpeg_destroy_compress(&encoder);
    return output_size;
}

int main(void)
{
    uint64_t mpidr;
    unsigned int core;
    uint32_t last_sequence;
    volatile struct jpeg_worker_mailbox *mailbox;
    __asm__ volatile ("mrs %0, mpidr_el1" : "=r"(mpidr));
    core = (unsigned int)(mpidr & 0xffU);
    if (core != 1U && core != 2U)
        return 1;
    mailbox = (volatile struct jpeg_worker_mailbox *)(JPEG_MAILBOX_BASE +
              (core - 1U) * JPEG_MAILBOX_STRIDE);
    Xil_DCacheInvalidateRange((UINTPTR)&mailbox->request, JPEG_MAILBOX_LINE);
    jpeg_worker_barrier();
    last_sequence = mailbox->request.sequence;

    for (;;) {
        uint32_t sequence, command, input_size, status = JPEG_RESPONSE_ERROR;
        uint64_t input_address;
        uint32_t output_size = 0, elapsed_us = 0;
        Xil_DCacheInvalidateRange((UINTPTR)&mailbox->request, JPEG_MAILBOX_LINE);
        jpeg_worker_barrier();
        sequence = mailbox->request.sequence;
        if (sequence == last_sequence)
            continue;
        command = mailbox->request.command;
        input_address = mailbox->request.input_address;
        input_size = mailbox->request.input_size;
        last_sequence = sequence;
        if (command == JPEG_COMMAND_PROBE) {
            status = JPEG_RESPONSE_OK;
        } else if (command == JPEG_COMMAND_ENCODE && input_size == IMAGE_BYTES &&
                   input_address <= 0x40000000ULL - IMAGE_BYTES &&
                   (input_address & 63U) == 0U) {
            XTime start, end;
            size_t encoded;
            Xil_DCacheInvalidateRange((UINTPTR)input_address, IMAGE_BYTES);
            jpeg_worker_barrier();
            XTime_GetTime(&start);
            encoded = encode_frame((const unsigned char *)(UINTPTR)input_address);
            XTime_GetTime(&end);
            elapsed_us = (uint32_t)((end - start) * 1000000ULL / COUNTS_PER_SECOND);
            if (encoded != 0U && encoded <= JPEG_CAPACITY) {
                Xil_DCacheFlushRange((UINTPTR)jpeg_output, encoded);
                jpeg_worker_barrier();
                output_size = (uint32_t)encoded;
                status = JPEG_RESPONSE_OK;
            }
        }
        mailbox->response.status = status;
        mailbox->response.output_address = (uint64_t)(UINTPTR)jpeg_output;
        mailbox->response.output_size = output_size;
        mailbox->response.elapsed_us = elapsed_us;
        jpeg_worker_barrier();
        mailbox->response.sequence = sequence;
        Xil_DCacheFlushRange((UINTPTR)&mailbox->response, JPEG_MAILBOX_LINE);
        jpeg_worker_barrier();
    }
}
