#!/bin/bash

#SBATCH -p gpu # partition (queue)
#SBATCH -N 1   # number of nodes
#SBATCH --mem 2G # memory pool for all cores
#SBATCH -n 2 # number of cores
#SBATCH -t 0-0:10 # time (D-HH:MM)
#SBATCH -o slurm_array_%A-%a.out
#SBATCH -e slurm_array_%A-%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=adam.tyson@ucl.ac.uk
#SBATCH --array=0-9%4

# Array job runs 10 separate jobs, but not more than four at a time.
# This is flexible and the array ID ($SLURM_ARRAY_TASK_ID) can be used in any way.

module load miniconda
conda activate slurm_demo

echo "Multiplying $SLURM_ARRAY_TASK_ID by 10"
python multiply.py $SLURM_ARRAY_TASK_ID 10 --jazzy

