"""Generate two small JPEGs, run both back-to-back with stalls and check all pixels.
Requires GHDL, NumPy and Pillow. Run from the extracted project with Python 3.
"""
import subprocess
import sys
import tempfile
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]


def main():
    with tempfile.TemporaryDirectory() as temp:
        work = Path(temp)
        y, x = np.indices((27, 43))
        pattern = np.stack(((x * 5 + 7 * y) % 256, (x * x + 3 * y) % 256, ((x ^ y) * 9) % 256), axis=-1)
        Image.fromarray(pattern.astype("uint8")).save(work / "color.jpg", quality=96, subsampling=0)
        gray = np.where(x % 8 < 4, 20 + 2 * y, 230 - 2 * y)
        Image.fromarray(gray.astype("uint8")).save(work / "gray.jpg", quality=95)
        driver = [sys.executable, str(ROOT / "sim/run_ghdl.py")]
        subprocess.run(driver + ["color.jpg", "--build", "build", "--output", "color.bmp",
                                 "--decoded-bmp", "decoded_color.bmp", "--stalls",
                                 "--second-jpeg", "gray.jpg", "--second-output", "gray.bmp"], cwd=work, check=True)
        # Capture the exact bytes from the grayscale VHDL decoder for the reference model.
        subprocess.run(driver + ["gray.jpg", "--build", "build", "--output", "gray_alone.bmp",
                                 "--decoded-bmp", "decoded_gray.bmp"], cwd=work, check=True)
        assert (work / "gray.bmp").read_bytes() == (work / "gray_alone.bmp").read_bytes(), "Frame history leaked"
        gray_out = np.asarray(Image.open(work / "gray.bmp"))
        if not np.all(gray_out == gray_out[:, :, :1]):
            raise SystemExit("A grayscale input acquired color")
        print(f"PASS: all {gray_out.shape[0] * gray_out.shape[1]} grayscale pixels remained neutral.", flush=True)
        for name in ("color", "gray"):
            subprocess.run([sys.executable, str(ROOT / "tools/check_pixels.py"),
                            f"decoded_{name}.bmp", f"{name}.bmp", "--jpeg", f"{name}.jpg"], cwd=work, check=True)


if __name__ == "__main__":
    main()
