#ifndef JPEG_PIPELINE_H
#define JPEG_PIPELINE_H

#include <stddef.h>

/* The service on both worker cores must already be running. */
int jpeg_pipeline_start(void);
void jpeg_pipeline_stop(void);
void jpeg_pipeline_poll(void);
int jpeg_pipeline_busy(void);
int jpeg_pipeline_failed(void);
/* Claim the next completed frame in capture order. */
int jpeg_pipeline_claim(const unsigned char **data, size_t *size, unsigned int *slot);
void jpeg_pipeline_release(unsigned int slot);

#endif
