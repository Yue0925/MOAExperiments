#!/bin/bash


for file in ../instances/*; do
    echo "$file ... "
    julia one_solve.jl "$file"
done