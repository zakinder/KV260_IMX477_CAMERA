"""Compile the shipped board control body with host stubs (not a Vitis build)."""
from pathlib import Path
import subprocess
import tempfile

root = Path(__file__).resolve().parents[1]
source = root / "board/mipi/src/LWIP/gui_control.c"
excluded = ('#include <xiicps.h>', '#include "lwip/', '#include "../',
            '#include "gui_control.h"', '#include "lwip_app.h"')
body = ''.join(line for line in source.read_text().splitlines(keepends=True)
               if not line.startswith(excluded))
with tempfile.TemporaryDirectory() as temp:
    temp = Path(temp)
    (temp / "generated_control.c").write_text(body)
    (temp / "test.c").write_text((root / "tests/test_board_control.c").read_text())
    # The VFP header comes from the exact repository revision used by the patch.
    (temp / "vfp_registers.h").write_text((root / "tests/vfp_registers.h").read_text())
    subprocess.run(["gcc", "-std=c11", "-Wall", "-Wextra", "-Werror", str(temp / "test.c"), "-o", str(temp / "test")], check=True)
    subprocess.run([str(temp / "test")], check=True)
