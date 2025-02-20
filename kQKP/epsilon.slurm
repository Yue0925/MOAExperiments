#!/bin/bash
#SBATCH --job-name=epsilon

#SBATCH --nodes=1-1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=40
#SBATCH --ntasks=1 
#SBATCH --mail-type=end
#SBATCH --mail-user=yue.zhang@lipn.univ-paris13.fr
#SBATCH --partition=COMPUTE-SHORT
#SBATCH --output=epsilon.log
#SBATCH --error=epsilon.log

module load /softs/modules/gurobi/1200


methodes=("epsilon" "bb_heur" "bb_heur_preproc1")

for file in ./instances/*; do
    echo "$file ... "
    srun julia one_solve.jl "$file" "epsilon"
done


