#ifndef IMX477_STARTUP_SETTINGS_H
#define IMX477_STARTUP_SETTINGS_H

#include <stdio.h>
#include "SENSORS_CONFIG/IMX477/imx477.h"

/* Call once after init_camera() has returned 477, before starting video DMA. */
static int imx477_apply_startup_settings(XIicPs *iic)
{
    static const u16 desired[4] = {1111U, 2048U, 2048U, 1024U};
    static const char *names[4] = {"Gr", "R", "B", "Gb"};
    Imx477TuningStatus status;
    u16 gains[4];
    u8 global;
    unsigned int i;
    int rc;

    rc = imx477_tuning_read(iic, &status);
    if (rc != IMX477_TUNING_OK) goto fail;
    if (status.dol_enable & 1U) {
        rc = IMX477_TUNING_HDR_ACTIVE;
        goto fail;
    }
    rc = imx477_digital_gain_read(iic, gains, &global);
    if (rc != IMX477_TUNING_OK) goto fail;
    if (global & 1U) {
        rc = imx477_digital_gain_set(iic, 4U, 0U);
        if (rc != IMX477_TUNING_OK) goto fail;
    }
    for (i = 0; i < 4U; ++i) {
        if (gains[i] != desired[i]) {
            rc = imx477_digital_gain_set(iic, i, desired[i]);
            if (rc != IMX477_TUNING_OK) goto fail;
        }
    }
    /* Preset 4 is 90% of usable frame lines in the existing sensor driver. */
    rc = imx477_tuning_exposure(iic, 4U);
    if (rc != IMX477_TUNING_OK) goto fail;
    rc = imx477_tuning_read(iic, &status);
    if (rc != IMX477_TUNING_OK) goto fail;
    rc = imx477_digital_gain_read(iic, gains, &global);
    if (rc != IMX477_TUNING_OK) goto fail;
    if (global & 1U) {
        printf("IMX477 startup: per-channel mode readback failed.\r\n");
        return -1;
    }
    for (i = 0; i < 4U; ++i) {
        if (gains[i] != desired[i]) {
            printf("IMX477 startup: %s gain readback mismatch: %u != %u\r\n",
                   names[i], (unsigned)gains[i], (unsigned)desired[i]);
            return -1;
        }
    }
    printf("IMX477 startup OK: Gr=%u R=%u B=%u Gb=%u (units of 1/256).\r\n",
           (unsigned)gains[0], (unsigned)gains[1],
           (unsigned)gains[2], (unsigned)gains[3]);
    printf("IMX477 exposure=%u lines, frame=%u lines, analog gain code=%u.\r\n",
           (unsigned)status.exposure_lines, (unsigned)status.frame_lines,
           (unsigned)status.analog_gain_code);
    return 0;
fail:
    printf("IMX477 startup settings failed (code %d); settings may be partial.\r\n", rc);
    return -1;
}
#endif
