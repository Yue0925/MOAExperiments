#!/bin/bash

# julia one_solve.jl "epsilon"
# julia one_solve.jl "bb_preproc1"
# julia one_solve.jl "bb_heur_preproc1"
# julia one_solve.jl "bb_preproc1_tightroot1"
# julia one_solve.jl "bb_preproc2"
# julia one_solve.jl "bb_heur_preproc2"
# julia one_solve.jl "bb_preproc2_tightroot1"


# for file in ./fractional/*; do
#     echo "$file ... "
#     julia solve_fractional.jl "$file" "epsilon"
#     julia solve_fractional.jl "$file" "bb_heur_preproc1"
#     julia solve_fractional.jl "$file" "bb_preproc1"
# done


# for file in ./TOinstances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_preproc0"
# done

# for file in ./TOinstances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_preproc1"
# done

# for file in ./TOinstances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_heur_preproc1"
# done

# for file in ./TOinstances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_preproc1_tightroot1"
# done


# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "epsilon"
# done

# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_preproc0"
# done

# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_preproc1"
# done


# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_preproc2"
# done



# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_heur_preproc1"
# done


# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_heur_preproc2"
# done


# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_preproc1_tightroot1"
# done
                                                    


# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_preproc2_tightroot1"
# done


for file in ./instances/*; do
    echo "$file ... "
    julia tabWriter.jl "$file"
done



# # todo 
# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb"
# done

# for file in ./instances/*; do
#     echo "$file ... "
#     julia one_solve.jl "$file" "bb_heur"
# done
