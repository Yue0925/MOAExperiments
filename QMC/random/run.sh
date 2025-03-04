#!/bin/bash


for file in instances/*; do
    echo "$file ... "
    julia MOBB/one_solve.jl "$file"
done