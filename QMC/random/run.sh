#!/bin/bash


# for file in ./instances/*; do
#     echo "$file ... "
#     julia latexWriter.jl "$file"
# done





for file in ./TOinstances/*; do
    echo "$file ... "
    julia latexWriter.jl "$file"
done



