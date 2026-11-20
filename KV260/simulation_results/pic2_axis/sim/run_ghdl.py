"""Compile the VHDL-2008 project and run its JPEG-to-BMP testbench. Python standard library only."""
import argparse
import os
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def jpeg_dimensions(path):
    # Read only the SOF0 dimensions to configure the hardware generics.
    # Entropy decoding, color conversion and pixel stimulus are done in VHDL.
    with path.open("rb") as stream:
        if stream.read(2) != b"\xff\xd8":
            raise ValueError(f"{path} is not a JPEG")
        while stream.read(1) == b"\xff":
            mark = stream.read(1)
            while mark == b"\xff":
                mark = stream.read(1)
            if mark in (b"", b"\xda", b"\xd9"):
                break
            length = int.from_bytes(stream.read(2), "big")
            if length < 2:
                break
            if mark == b"\xc0":
                header = stream.read(5)
                if len(header) == 5 and header[0] == 8:
                    return int.from_bytes(header[3:5], "big"), int.from_bytes(header[1:3], "big")
                break
            stream.seek(length - 2, 1)
    raise ValueError(f"{path} needs an 8-bit baseline JPEG (SOF0)")


def run(source, output, build, decoded=None, stalls=False, second=None, second_output=None):
    ghdl = shutil.which(os.environ.get("GHDL", "ghdl"))
    if not ghdl:
        raise SystemExit("GHDL is required. Put ghdl on PATH or set GHDL to its executable.")
    source, output, build = source.resolve(), output.resolve(), build.resolve()
    width, height = jpeg_dimensions(source)
    args = [f"-gG_INPUT={source}", f"-gG_WIDTH={width}", f"-gG_HEIGHT={height}",
            f"-gG_OUTPUT={output}", f"-gG_STALLS={str(stalls).lower()}"]
    destinations = [output]
    inputs = [source]
    if decoded:
        decoded = decoded.resolve()
        destinations.append(decoded)
        args.append(f"-gG_DECODED_BMP={decoded}")
    if second:
        second = second.resolve()
        inputs.append(second)
        if jpeg_dimensions(second) != (width, height):
            raise ValueError("Back-to-back JPEGs must have the same dimensions")
        second_output = (second_output or output.with_name(output.stem + "_frame2.bmp")).resolve()
        destinations.append(second_output)
        args += [f"-gG_SECOND_JPEG={second}", f"-gG_SECOND_OUTPUT={second_output}"]
    if set(inputs).intersection(destinations) or len(destinations) != len(set(destinations)):
        raise ValueError("Each BMP needs its own path, separate from the input JPEGs")
    build.mkdir(parents=True, exist_ok=True)
    for dest in destinations:
        dest.parent.mkdir(parents=True, exist_ok=True)
    files = (ROOT / "sim/sources.txt").read_text().splitlines()
    subprocess.run([ghdl, "-a", "--std=08", *[str(ROOT / f) for f in files if f]], cwd=build, check=True)
    subprocess.run([ghdl, "-e", "--std=08", "tb_pic2"], cwd=build, check=True)
    subprocess.run([ghdl, "-r", "--std=08", "tb_pic2", *args, "--assert-level=error"], cwd=build, check=True)
    print(f"RTL output: {output}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path, nargs="?", default=ROOT / "images/PIC1.JPG")
    parser.add_argument("--output", type=Path, default=ROOT / "results/PIC1_filtered.bmp")
    parser.add_argument("--build", type=Path, default=ROOT / "build/ghdl")
    parser.add_argument("--decoded-bmp", type=Path, help="also dump the unfiltered JPEG decoder output")
    parser.add_argument("--stalls", action="store_true", help="insert pseudo-random source gaps and output backpressure")
    parser.add_argument("--second-jpeg", type=Path, help="stream another frame without reset")
    parser.add_argument("--second-output", type=Path)
    opts = parser.parse_args()
    run(opts.input, opts.output, opts.build, opts.decoded_bmp, opts.stalls, opts.second_jpeg, opts.second_output)
