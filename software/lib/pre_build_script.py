from pathlib import Path

p = Path("tools/pre_build_script.py")

if not p.exists():
    raise SystemExit("pre_build_script.py not found")

lines = p.read_text().splitlines()
if not lines:
    raise SystemExit("pre_build_script.py is empty")

if "python3" not in lines[0]:
    lines[0] = "#!/usr/bin/env python3"
    p.write_text("\n".join(lines) + "\n")
    print("Patched shebang to python3")
else:
    print("Shebang already python3, skip")
