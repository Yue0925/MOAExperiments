#!/bin/bash

g++ -o kqkp kqkp_inst.cc

density=(25 50 75 100)

for ((i=20;i<=50;i=i+5)); do
    for d in ${density[@]}; do
        ./kqkp $i 100 $d 333
    done
done