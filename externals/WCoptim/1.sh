#!/bin/bash
#SBATCH --partition=short
#SBATCH --time=005:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=WCpar
#SBATCH --array=1-96:16
# mail alert at start, end and abortion of execution
#SBATCH --mail-type=ALL
# send mail to this address
#SBATCH --mail-user=yosra.hashim@ndcn.ox.ac.uk

module load MATLAB/R2019b

# create temporary directory and set it as MCR_CACHE_ROOT
export MCR_CACHE_ROOT=$(mktemp -d)

for RUN_ID in `seq 16`; do 
	RUN_PARAM=`echo $RUN_ID`
	./run_WCoptim.sh /system/software/linux-x86_64/matlab/R2019b "WC_"$SLURM_ARRAY_JOB_ID ${SLURM_ARRAY_TASK_ID} $RUN_PARAM &
done   

# wait for all processes to finish                        
wait 

# remove temporary directories
rm -rf ${MCR_CACHE_ROOT}
#rm -rf ${MATLAB_JOB_TMP}
