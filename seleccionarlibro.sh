#!/bin/bash

HDFS_DIR="/user/emilio/output"

echo "Archivos disponibles en HDFS:"
hdfs dfs -ls "$HDFS_DIR" | grep "part-" | awk '{print $8}' | nl

read -p "Selecciona el número del archivo (libro): " OPCION

ARCHIVO=$(hdfs dfs -ls "$HDFS_DIR" | grep "part-" | awk '{print $8}' | sed -n "${OPCION}p")

if [ -z "$ARCHIVO" ]; then
  echo "Selección inválida."
  exit 1
fi

echo "Seleccionaste: $ARCHIVO"

read -p "Ingresa la palabra a buscar: " PALABRA

CONTEO=$(hdfs dfs -cat "$ARCHIVO" | grep -P "^${PALABRA}\t" | awk -F'\t' '{print $2}')

if [ -z "$CONTEO" ]; then
  echo "La palabra '$PALABRA' no se encontró en este libro."
else
  echo "La palabra '$PALABRA' aparece $CONTEO veces en este libro."
fi
