#!/bin/bash

#SBATCH -p gpu # partition (queue)
#SBATCH -N 1   # number of nodes
#SBATCH --mem 2G # memory pool for all cores
#SBATCH -n 2 # number of cores
#SBATCH -t 0-0:10 # time (D-HH:MM)
#SBATCH -o slurm_output.out
#SBATCH -e slurm_error.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=adam.tyson@ucl.ac.uk

module load miniconda
conda activate slurm_demo

for i in {1..5}
do
  echo "Multiplying $i by 10"
  python multiply.py $i 10 --jazzy
done
