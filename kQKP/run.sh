#!/bin/bash

# methodes=("epsilon" "bb_heur" "bb_heur_preproc1")


# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "epsilon"
# done


# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_heur_preproc1"
# done



# for file in ./instances/*; do
#     echo "$file ... "
#     julia tabWriter.jl "$file"
# done




julia one_solve.jl "./instances/QKP_20_100_25" "bb_heur_preproc1"

julia one_solve.jl "./instances/QKP_20_100_50" "bb_heur_preproc1"

julia one_solve.jl "./instances/QKP_20_100_75" "bb_heur_preproc1"


julia one_solve.jl "./instances/QKP_20_100_100" "bb_heur_preproc1"


julia one_solve.jl "./instances/QKP_25_100_25" "bb_heur_preproc1"


julia one_solve.jl "./instances/QKP_25_100_50" "bb_heur_preproc1"


julia one_solve.jl "./instances/QKP_25_100_75" "bb_heur_preproc1"

julia one_solve.jl "./instances/QKP_25_100_100" "bb_heur_preproc1"
