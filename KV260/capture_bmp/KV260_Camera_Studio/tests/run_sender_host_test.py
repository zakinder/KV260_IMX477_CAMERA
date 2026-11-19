"""Exercise the shipped sender body with mocks; requires host GCC."""
from pathlib import Path
import shutil
import subprocess
import tempfile

root = Path(__file__).resolve().parents[1]
source = (root / "board/mipi/src/LWIP/lwip_app.c").read_text()
body = "\n".join(line for line in source.splitlines() if not line.startswith("#include")) + "\n"
with tempfile.TemporaryDirectory() as temp:
    temp = Path(temp)
    (temp / "lwip_app_mocked.c").write_text(
        '#include "mock.h"\nint gui_control_start(void);\nvoid gui_control_poll(void);\n' + body)
    for name in ("mock.h", "vfp_mock.h", "test_sender.c"):
        shutil.copyfile(root / "tests" / name, temp / name)
    for name, flags in (("standalone", []), ("dhcp_540", ["-DLWIP_DHCP=1", "-DP540=1"])):
        executable = temp / name
        subprocess.run(["gcc", "-std=c11", "-Wall", "-Wextra", "-Werror",
                        "-ffunction-sections", "-fdata-sections", *flags,
                        str(temp / "test_sender.c"), "-Wl,--gc-sections", "-o", str(executable)],
                       check=True)
        subprocess.run([str(executable)], check=True)
