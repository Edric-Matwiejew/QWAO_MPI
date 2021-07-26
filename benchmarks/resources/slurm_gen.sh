#!/bin/bash

BASE_SLURM=$1
OUTPUT_BASENAME=$2
TIME=$3
THREADS=$4
MPI_PROCESSES=$5
BENCH_TYPE=$6
TEST_MODULE_IMPORT_PATH=$7
TYPE=$8

if [ "$TYPE" = "CLUSTER" ]; then
	NODES=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
elif [ "$TYPE" = "WORKSTATION" ]; then
	NODES=(1 2 4 8 16 32)
fi

OUT_DIR=output/${TYPE}/${OUTPUT_BASENAME}/out
CSV_DIR=output/${TYPE}/${OUTPUT_BASENAME}/csv

mkdir -p $OUT_DIR
mkdir -p $CSV_DIR

echo $OUT_DIR

cp resources/launch.sh output/${TYPE}/${OUTPUT_BASENAME}

for NODE in ${NODES[@]}; do

    SCRIPT_PATHNAME=output/${TYPE}/${OUTPUT_BASENAME}/${NODE}_${OUTPUT_BASENAME}.slurm

    cp $BASE_SLURM $SCRIPT_PATHNAME

    	if [ "$TYPE" = "CLUSTER" ]; then
			sed -i "s/NODES/$NODE/g" $SCRIPT_PATHNAME
    		TOTAL_MPI_PROCESSES=$(($NODE * $MPI_PROCESSES))
    	elif [ "$TYPE" = "WORKSTATION" ]; then
	    	sed -i "s/NODES/1/g" $SCRIPT_PATHNAME
    		TOTAL_MPI_PROCESSES=$NODE
    	fi

    sed -i "s/JOB_NAME/${OUTPUT_BASENAME}_${NODE}/g" $SCRIPT_PATHNAME
	sed -i "s/TIME/$TIME/g" $SCRIPT_PATHNAME
	sed -i "s/ACCOUNT/$ACCOUNT/g" $SCRIPT_PATHNAME
	sed -i "s/LOG_NAME/${NODE}_${OUTPUT_BASENAME}.out/g" $SCRIPT_PATHNAME
	sed -i "s/THREADS_PLACEHOLDER/$THREADS/g" $SCRIPT_PATHNAME
	sed -i "s/TOTAL_MPI_PROCESSES/$TOTAL_MPI_PROCESSES/g" $SCRIPT_PATHNAME
	sed -i "s/BENCH_TYPE/$BENCH_TYPE/g" $SCRIPT_PATHNAME
	sed -i "s/CSV_NAME/${NODE}_${OUTPUT_BASENAME}.csv/g" $SCRIPT_PATHNAME
	sed -i "s/TEST_MODULE_IMPORT_PATH/$TEST_MODULE_IMPORT_PATH/g" $SCRIPT_PATHNAME
	sed -i "s|CSV_DIR|$CSV_DIR|g" $SCRIPT_PATHNAME
	sed -i "s|OUT_DIR|out|g" $SCRIPT_PATHNAME

done
