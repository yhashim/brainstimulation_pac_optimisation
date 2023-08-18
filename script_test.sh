#!/bin/bash
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=6
#SBATCH --time=11:00:00
#SBATCH --job-name=myjob
#SBATCH --partition=short
# mail alert at start, end and abortion of execution
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ndcn1405@ox.ac.uk


module load MATLAB/R2022b

matlab -nodisplay -nosplash <intan_demo.m > script_out.txt
