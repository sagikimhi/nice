#!/bin/zsh

verilator \
    --binary \
    $(bender script verilator) \
    --top nice_top 

