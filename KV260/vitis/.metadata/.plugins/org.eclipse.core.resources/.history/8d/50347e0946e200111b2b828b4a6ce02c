#ifndef JPEG_WORKER_MAILBOX_H
#define JPEG_WORKER_MAILBOX_H

#include <stdint.h>

/* This experimental mailbox is outside the three application linker ranges.
 * Each 64-byte line has exactly one writer. Check the platform's complete
 * memory map before use; no linker reserves this physical address. */
#define JPEG_MAILBOX_BASE ((uintptr_t)0x50000000U)
#define JPEG_MAILBOX_STRIDE 0x100U
#define JPEG_MAILBOX_LINE 64U
#define JPEG_COMMAND_PROBE 1U
#define JPEG_COMMAND_ENCODE 2U
#define JPEG_RESPONSE_OK 1U
#define JPEG_RESPONSE_ERROR 2U

struct jpeg_worker_request {
    uint32_t sequence;
    uint32_t command;
    uint64_t input_address;
    uint32_t input_size;
    uint8_t padding[44];
};
struct jpeg_worker_response {
    uint32_t sequence;
    uint32_t status;
    uint64_t output_address;
    uint32_t output_size;
    uint32_t elapsed_us;
    uint8_t padding[40];
};
struct jpeg_worker_mailbox {
    struct jpeg_worker_request request;
    struct jpeg_worker_response response;
};

typedef char jpeg_request_size_check[(sizeof(struct jpeg_worker_request) == 64U) ? 1 : -1];
typedef char jpeg_response_size_check[(sizeof(struct jpeg_worker_response) == 64U) ? 1 : -1];

static inline void jpeg_worker_barrier(void)
{
    __asm__ volatile ("dsb sy" ::: "memory");
}

#endif
