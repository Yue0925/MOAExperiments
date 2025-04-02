#!/bin/bash


# for file in ../instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_preproc0"
# done



# for file in ../instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_preproc1"
# done




# for file in ../instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_heur_preproc1"
# done



# for file in ../instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_heur_preproc2"
# done




for file in ../TOinstances/*; do
    echo "$file ... "
    julia one_solve.jl "$file" "bb_preproc0"
done



for file in ../TOinstances/*; do
    echo "$file ... "
    julia one_solve.jl "$file" "bb_preproc1"
done

