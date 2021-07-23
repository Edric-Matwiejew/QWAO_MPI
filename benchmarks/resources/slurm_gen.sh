#!/bin/bash

OUTPUT_BASENAME=$1
TIME=$2
THREADS=$3
MPI_PROCESSES=$4
BENCH_TYPE=$5
TEST_MODULE_IMPORT_PATH=$6
TYPE=$7

if [ "$TYPE" = "CLUSTER" ]; then
	NODES=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
elif [ "$TYPE" = "WORKSTATION" ]; then
	NODES=(1 2 4 8 16 32)
fi

mkdir -p output/${TYPE}/${OUTPUT_BASENAME}/log
mkdir -p output/${TYPE}/${OUTPUT_BASENAME}/csv

cp resources/launch.sh output/${OUTPUT_BASENAME}

for NODE in ${NODES[@]}; do

    SCRIPT_PATHNAME=output/${TYPE}/${OUTPUT_BASENAME}/${NODE}_${OUTPUT_BASENAME}.slurm
    TOTAL_MPI_PROCS=$(($NODE * $MPI_PROCESSES))

    cp resources/base.slurm $SCRIPT_PATHNAME

    	if [ "$TYPE" = "CLUSTER" ]; then
		sed -i "s/NODES/$NODE/g" $SCRIPT_PATHNAME
    	elif [ "$TYPE" = "WORKSTATION" ]; then
	    	sed -i "s/NODES/1/g" $SCRIPT_PATHNAME
    	fi

    	sed -i "s/JOB_NAME/${OUTPUT_BASENAME}_${NODE}/g" $SCRIPT_PATHNAME
	sed -i "s/TIME/$TIME/g" $SCRIPT_PATHNAME
	sed -i "s/ACCOUNT/$ACCOUNT/g" $SCRIPT_PATHNAME
	sed -i "s/LOG_NAME/${NODE}_${OUTPUT_BASENAME}.out/g" $SCRIPT_PATHNAME
	sed -i "s/THREADS/$THREADS/g" $SCRIPT_PATHNAME
	sed -i "s/TOTAL_MPI_PROCESSES/$TOTAL_MPI_PROCESSES/g" $SCRIPT_PATHNAME
	sed -i "s/BENCH_TYPE/$BENCH_TYPE/g" $SCRIPT_PATHNAME
	sed -i "s/CSV_NAME/${NODE}_${OUTPUT_BASENAME}.csv/g" $SCRIPT_PATHNAME
	sed -i "s/TEST_MODULE_IMPORT_PATH/$TEST_MODULE_IMPORT_PATH/g" $SCRIPT_PATHNAME

done
