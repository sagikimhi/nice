import os as os
import pathlib as pathlib
from cocotb import runner as tb_runner

path = pathlib.Path(__file__).resolve().parent
workrun = path / "workrun"
flist_path = path / "flist.f"

workrun.mkdir(exist_ok=True)
os.system(f"bender script flist > {flist_path}")

with open(flist_path) as file:
    srcs = [line.strip() for line in file if not line.isspace()]

srcs = [tb_runner.Verilog(src) for src in srcs]
includes = [pathlib.Path(src).resolve().parent for src in srcs]

runner = tb_runner.get_runner("icarus")
runner.build(
    sources=srcs,
    hdl_toplevel="nice_top",
    always=True,
    includes=includes,
    build_dir=workrun.name,
    clean=True,
    verbose=True,
    waves=True,
    log_file=(workrun / "build.log").name,
)
runner.test(hdl_toplevel="nice_top", test_module="nice_test,")
