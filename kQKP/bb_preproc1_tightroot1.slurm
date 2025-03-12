#!/bin/bash
#SBATCH --job-name=bb_preproc1_tightroot1

#SBATCH --nodes=1-1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=40
#SBATCH --ntasks=1 
#SBATCH --mail-type=end
#SBATCH --mail-user=yue.zhang@lipn.univ-paris13.fr
#SBATCH --partition=SMP-256c-SHORT
#SBATCH --output=bb_preproc1_tightroot1.log
#SBATCH --error=bb_preproc1_tightroot1.log

module load /softs/modules/gurobi/1200

srun julia one_solve.jl "bb_preproc1_tightroot1"


