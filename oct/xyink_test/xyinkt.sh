#!/bin/bash
# Xyink conventional formula result comparator and continuity tester

# Create an array of angles maybe 8100 long, input the angles to the xyink
# program and the octave program that houses the classical formula version
# of the inverse kinematics function. Test for errors. When approaching 
# problematic points in the program check for weird behavior and crashes
# if the program crashes at certain values record those values and fix the
# continuity issue in the next versions of the program.
# As a future note it might be nice to create a 3D visualization of 
# workspace of the pedestal and how the angle between joint axes affect it.
#
# Maybe octave can call external programs, that would be better as to not 
# writing an entirely external shell script and calling the octave program
# with the data

# Counting from 0, 0 to 359, 90 
./xycal

