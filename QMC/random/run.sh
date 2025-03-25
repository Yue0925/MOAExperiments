#!/bin/bash


for file in ./instances/*; do
    echo "$file ... "
    julia latexWriter.jl "$file"
done