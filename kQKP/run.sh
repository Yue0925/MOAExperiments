#!/bin/bash

# methodes=("epsilon" "bb_heur" "bb_heur_preproc1")


for file in ./instances/*; do
    echo "$file ... "
    julia one_solve.jl "$file" "epsilon"
done


for file in ./instances/*; do
    echo "$file ... "
    julia one_solve.jl "$file" "bb_preproc1"
done


for file in ./instances/*; do
    echo "$file ... "
    julia one_solve.jl "$file" "bb_preproc2"
done

for file in ./instances/*; do
    echo "$file ... "
    julia one_solve.jl "$file" "bb_heur_preproc1"
done


for file in ./instances/*; do
    echo "$file ... "
    julia one_solve.jl "$file" "bb_heur_preproc2"
done


# for file in ./instances/*; do
#     echo "$file ... "
#     julia tabWriter.jl "$file"
# done




# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_"
# done

# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_heur"
# done
