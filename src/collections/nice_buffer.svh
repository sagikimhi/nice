//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_buffer.svh
// Author        : skimhi
// Created       : Mon Sep 2024, 11:08:43
// Last modified : Mon Sep 2024, 11:08:43
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history :
// Mon Sep 2024, 11:08:43
//-----------------------------------------------------------------------------

`ifndef NICE_BUFFER_SVH
`define NICE_BUFFER_SVH


class buffer#(type T=uvm_object)
extends collections::deque#(T);
    `nice_param_object(buffer#(T))
endclass: buffer

`endif // NICE_BUFFER_SVH
