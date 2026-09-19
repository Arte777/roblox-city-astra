#!/usr/bin/env python3
"""Static consistency checks for Astra City manifests and Luau generators."""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "city" / "manifest.json"
FORBIDDEN = ("Enum.Material.CorrugatedIron", "Anchored = false")


def main() -> None:
    data = json.loads(MANIFEST.read_text(encoding="utf-8"))
    assert data["grid"]["islandSize"][0] >= 2400, "Island must be at least 2400 studs"
    assert len(data["zones"]) == 9, "Exactly nine zones are required"

    priorities: list[int] = []
    for district in data["districts"]:
        path = ROOT / district["file"]
        assert path.is_file(), f"Missing generator: {district['file']}"
        source = path.read_text(encoding="utf-8")
        assert re.search(r"return\s+function\s*\(", source), f"No returned generator in {path}"
        for token in FORBIDDEN:
            assert token not in source, f"Forbidden token {token!r} in {path}"
        priorities.append(district["priority"])

    assert len(priorities) == len(set(priorities)), "District priorities must be unique"
    assert priorities == sorted(priorities), "Districts must be sorted by priority"
    print(f"OK: {len(data['districts'])} generators, {len(data['zones'])} zones, v{data['version']}")


if __name__ == "__main__":
    main()
