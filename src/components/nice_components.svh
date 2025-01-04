//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_components.svh
// Author        : skimhi
// Created       : Wed Sep 2024, 19:29:45
// Last modified : Wed Sep 2024, 19:29:45
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Wed Sep 2024, 19:29:45
//-----------------------------------------------------------------------------

`ifndef NICE_COMPONENTS_SVH
`define NICE_COMPONENTS_SVH

`include "nice_defines.svh"
`nice_include_dependencies

// Package: components
//
// A collection of uvm_component based classes and facillities.
//
package components;
    `nice_import_dependencies

    // Type: broadcaster
    //
    // A utility component providing broadcast facilities.
    //
    // See <components::broadcaster>.
    //
    `include "components/nice_components_broadcaster.svh"

endpackage: components

`endif // NICE_COMPONENTS_SVH
