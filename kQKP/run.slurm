#!/bin/bash
#SBATCH --job-name=kQKP

#SBATCH --nodes=1-1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=40
#SBATCH --ntasks=1 
#SBATCH --mail-type=end
#SBATCH --mail-user=yue.zhang@lipn.univ-paris13.fr
#SBATCH --partition=COMPUTE-SHORT
#SBATCH --output=kQKP_Out.txt
#SBATCH --error=kQKP_Err.txt


srun julia MOAkQKP.jl > MOBB.log


