#!/usr/bin/env python3
import sys
import signal

signal.signal(signal.SIGPIPE, signal.SIG_DFL)
palabra_actual = None
contador = 0

for line in sys.stdin:
    palabra, cuenta = line.strip().split("\t")
    cuenta = int(cuenta)

    if palabra == palabra_actual:
        contador += cuenta
    else:
        if palabra_actual is not None:
            print(f"{palabra_actual}\t{contador}")
        palabra_actual = palabra
        contador = cuenta

# imprimir último
if palabra_actual is not None:
    print(f"{palabra_actual}\t{contador}")
