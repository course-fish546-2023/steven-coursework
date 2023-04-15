#!/bin/bash
## Job Name
#SBATCH --job-name=assign4
## Allocation Definition
#SBATCH --account=srlab
#SBATCH --partition=srlab
## Resources
## Nodes
#SBATCH --nodes=1
## Walltime (days-hours:minutes:seconds format)
#SBATCH --time=01-08:00:00
## Memory per node
#SBATCH --mem=100G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sr320@uw.edu
## Specify the working directory for this job
#SBATCH --chdir=/gscratch/scrubbed/sr320/assign_04


module load intel-python3_2017

python 04-hello.py






/gscratch/srlab/programs/ncbi-blast-2.10.1+/bin/blastx -help



pwd 

whoami

echo "yah! I ddi it!!!!!!!!!!"


echo "yah! I ddi it!!!!!!!!!!" > text.file
