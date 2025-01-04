//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_iterable.svh
// Author        : skimhi
// Created       : Sat Sep 2024, 21:33:31
// Last modified : Sat Sep 2024, 21:33:31
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Sat Sep 2024, 21:33:31
//-----------------------------------------------------------------------------

`ifndef NICE_ITERABLE_SVH
`define NICE_ITERABLE_SVH

// Interface Class: patterns::Iterable
//
// An annotation for sequence container types.
//
// Annotates an object capable of returning its members one at a time.
//
// Implementations must define the <iter()> method.
//
interface class iterable#(type T=uvm_object);

    parameter type iterator = patterns::iterator#(T);

    // Function: iter
    //
    // Returns an <iterator> over the items of an <iterable>.
    //
    pure virtual function iterator
    iter();

endclass: iterable

`endif // NICE_ITERABLE_SVH
