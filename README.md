## SWC SLURM demo

1. Login to gateway

```bash
ssh USERNAME@ssh.swc.ucl.ac.uk
```

2. Login to HPC

```
ssh hpc-gw1
```

N.B. You can [set up SSH keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-2) so you don't have to keep typing in your password.

3. See what nodes are available using `sinfo`.

N.B. Adding this line to your `.bashrc` and typing `sinfol` will print much more information.
```bash
alias sinfol='sinfo --Node --format="%.14N %.4D %5P %.6T %.4c %.10C %4O %8e %.8z %.6m %.8d %.6w %.5f %.6E %.30G"'
```
3. See what jobs are running with `squeue`.

4. See what data storage is available:
* `cd /ceph/store`  - general lab data storage
* `cd /nfs/winstor` - older lab data
* `/ceph/neuroinformatics/neuroinformatics` - team storage
* `cd /ceph/zoo` - specific project storage
* `cd /ceph/scratch` - short term storage, e.g. for intermediate analysis results, not backed up
* `cd /ceph/scratch/neuroinformatics-dropoff` - "dropbox" for others to share data with the team

5. Start an interactive job in pseudoterminal mode (`--pty`) by requesting a single core from [SLURM](https://slurm.schedmd.com/documentation.html), the job scheduler:

```bash
srun -p cpu --pty bash -i
```
N.B. Don't run anything intensive on the login nodes.

6. Clone a test script
```bash
cd ~/
git clone https://github.com/neuroinformatics-unit/slurm-demo
```
7. Check out list of available modules
```bash
module avail
```
8. Load the miniconda module
```bash
module load miniconda
```

9. Create conda environment
```bash
conda env create -f env.yml
```

10. Activate conda environment and run Python script
```bash
conda activate slurm_demo
python python multiply.py 5 10 --jazzy
```
11. Stop interactive job
```bash
exit
```
12. Check out batch script:
```bash
cat batch_example.sh
```

```bash
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
```
Run batch job:
```bash
sbatch batch_example.sh
```

13. Check out array script:
```bash
cat array_example.sh
```

```bash
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
```
Run array job:
```bash
sbatch array_example.sh
```

14. Start an interactive job with one GPU:
```bash
srun -p gpu --gres=gpu:1 --pty bash -i
```

14. Load CUDA
```bash
module load cuda
```
15. Activate conda environment check GPU 
```bash
conda activate slurm_demo
python
```

```python
import tensorflow as tf
tf.config.list_physical_devices('GPU')
```

16. For fast I/O consider copying data to `/tmp` (fast NVME storage) as part of the run. Available on all of the gpu-380 and gpu-sr670 nodes.
