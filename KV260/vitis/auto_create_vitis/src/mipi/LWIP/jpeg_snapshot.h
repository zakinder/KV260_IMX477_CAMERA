#ifndef JPEG_SNAPSHOT_H
#define JPEG_SNAPSHOT_H

#include <stddef.h>

/* Returns zero on capture/encode failure. Output remains valid until next capture. */
size_t jpeg_snapshot_capture(const unsigned char **data);

/* Copy diagnostics for the Dynamic Genlock display-only build. */
void jpeg_rotation_copy_test(void);

#endif
