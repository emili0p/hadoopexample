#!/bin/bash

# config
INPUT_LOCAL="/home/emilio/hadoopfun/El-Principito.txt" # fs local
HDFS_INPUT="/user/emilio/input"                        # hdfs
HDFS_OUTPUT="/user/emilio/output"                      # hdfs

STREAMING_JAR=$(ls $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.4.2.jar)

# checando cosas
echo "Verificando instalacion de hadoop"
jps | grep -E "NameNode|DataNode" >/dev/null

if [ $? -ne 0 ]; then
  echo "hadoop no esta corriendo :/ "
  exit 1
fi

echo "Limpiando HDFS (input y output)"
hdfs dfs -rm -r -f $HDFS_INPUT || true
hdfs dfs -rm -r -f $HDFS_OUTPUT || true

# preparacion del cluster
echo "creando directorio en el hdfs "
hdfs dfs -mkdir -p $HDFS_INPUT

echo "subiendo archivos"
hdfs dfs -put -f $INPUT_LOCAL $HDFS_INPUT

chmod +x mapper.py reducer.py

# ejecucion del trabajo
echo "ejecutando map reduce"
echo "JAR = $STREAMING_JAR"
hadoop jar $STREAMING_JAR \
  -input $HDFS_INPUT/El-Principito.txt \
  -output $HDFS_OUTPUT \
  -mapper mapper.py \
  -reducer reducer.py \
  -file mapper.py \
  -file reducer.py
echo "mostrando resultados"
hdfs dfs -cat $HDFS_OUTPUT/part-00000 | sort -k2 -nr | head

echo "Todo bien !"
