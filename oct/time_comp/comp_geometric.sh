#!/bin/bash

a_min=0
a_max=359
e_min=0
e_max=89

# Outer loop for 'a'
for ((a=$a_min; a<=$a_max; a++)); do
    # Inner loop for 'e'
    for ((e=$e_min; e<=$e_max; e++)); do
        # Print the current values of 'a' and 'e'
        echo "Azimuth = $a, Elevation = $e"
        octave-cli only_geometric.m $a $e
        # Add your code here to perform operations with 'a' and 'e'
    done
done

