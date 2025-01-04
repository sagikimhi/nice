#!/bin/bash

find ./vendor -name "*.sv" -o -name "*.svh" -o -name "*.v" | sort > verible.filelist
find ./src -name "*.sv" -o -name "*.svh" -o -name "*.v" | sort >> verible.filelist
