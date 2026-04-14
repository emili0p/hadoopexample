#!/usr/bin/env python3
import sys
import re

counts = {}

for line in sys.stdin:
    # regex para limpiar texto, quita minuscalas y puntuaciones de las palabras
    words = re.findall(r"\b\w+\b", line.lower())
    for w in words:
        counts[w] = counts.get(w, 0) + 1

# evita conteos parciales
for w, c in counts.items():
    print(f"{w}\t{c}")
