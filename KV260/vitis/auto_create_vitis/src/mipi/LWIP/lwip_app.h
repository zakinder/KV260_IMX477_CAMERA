#ifndef LWIP_APP_H
#define LWIP_APP_H

/* Returns 0 on start, 1 if already started, or a negative value on error. */
int lwip_stream_start(void);

/* Queues one full-frame JPEG. Returns 1 if a snapshot is pending. */
int lwip_jpeg_request(void);

/* Toggle continuous 4K JPEG. Returns 1 on, 0 off, -1 on error, -2 if busy. */
int lwip_mjpeg_toggle(void);

/* Call from the foreground, including while waiting for UART input. */
void lwip_stream_poll(void);

#endif
