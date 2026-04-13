#!/bin/env bash

gcc -Wall -L. -lm -g xyink.c -o xyink
./xyink -v -a 45 -e 45 -d 90
