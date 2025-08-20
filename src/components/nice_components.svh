`ifndef NICE_COMPONENTS_SVH
`define NICE_COMPONENTS_SVH

`include "nice_defines.svh"
`NICE_INCLUDE_DEPENDENCIES

// Package: components
//
// A collection of uvm_component based classes and facillities.
//
package components;
    `NICE_IMPORT_DEPENDENCIES

    // Type: broadcaster
    //
    // A utility component providing broadcast facilities.
    //
    // See <components::broadcaster>.
    //
    `include "components/nice_components_broadcaster.svh"

endpackage: components

`endif // NICE_COMPONENTS_SVH
