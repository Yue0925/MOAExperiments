#!/bin/bash


for file in ../instances/*; do
    echo "$file ... "
    julia one_solve.jl "$file" "bb_preproc0"
done



for file in ../instances/*; do
    echo "$file ... "
    julia one_solve.jl "$file" "bb_preproc1"
done


for file in ../instances/*; do
    echo "$file ... "
    julia one_solve.jl "$file" "bb_preproc2"
done



# for file in ../instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_heur_preproc1"
# done



# for file in ../instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_heur_preproc2"
# done



# for file in ../instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_preproc1_tightroot1"
# done




# for file in ../instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_preproc2_tightroot1"
# done