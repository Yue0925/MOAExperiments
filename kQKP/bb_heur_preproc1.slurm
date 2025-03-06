#!/bin/bash
#SBATCH --job-name=bb_heur_preproc1

#SBATCH --nodes=1-1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=40
#SBATCH --ntasks=1 
#SBATCH --mail-type=end
#SBATCH --mail-user=yue.zhang@lipn.univ-paris13.fr
#SBATCH --partition=SMP-256c
#SBATCH --output=bb_heur_preproc1.log
#SBATCH --error=bb_heur_preproc1.log

module load /softs/modules/gurobi/1200


# methodes=("epsilon" "bb_heur" "bb_heur_preproc1")

# for file in ./instances/*; do
    # echo "$file ... "
    # srun julia one_solve.jl "$file" "bb_heur_preproc1"
# done

srun julia one_solve.jl ./instances/QKP_20_100_100 "bb_heur_preproc1"

