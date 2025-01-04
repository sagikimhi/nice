//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_iterator.svh
// Author        : skimhi
// Created       : Sat Sep 2024, 21:33:44
// Last modified : Sat Sep 2024, 21:33:44
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Sat Sep 2024, 21:33:44
//-----------------------------------------------------------------------------

`ifndef NICE_ITERATOR_SVH
`define NICE_ITERATOR_SVH

// Interface Class: patterns::iterator
//
// An object representing a stream of data.
//
// Repeated calls to the iterator’s <next()> method return successive items in
// the stream.
//
// When no more data items are available null is returned instead.
//
// At this point, the iterator object is exhausted and any further calls to
// <next()> simply return null again.
//
// Iterators are required to have an <iter()> method that returns the iterator
// object itself so every iterator is also iterable and may be used in most
// places where other iterables are accepted.
//
// One notable exception is code which attempts multiple iteration passes.
//
// A container object produces a fresh new iterator each time you pass it to the
// <iter()> function.
//
// Attempting this with an iterator will just return the same exhausted iterator
// object used in the previous iteration pass, making it appear like an empty
// container.
//
// Implementations must define the <iter()> and <next()> method.
//
interface class iterator#(type T=uvm_object)
extends iterable#(T);

    parameter type iterable = patterns::iterable#(T);
    parameter type iterator = patterns::iterator#(T);

    // Function: item
    //
    // Returns the item for the current iteration.
    //
    pure virtual function T
    item();

    // Function: next
    //
    // Returns the iterator after progressing it to the next item.
    //
    // When no more data items are available null is returned instead.
    //
    // At this point, the iterator object is exhausted and any further calls to
    // <next()> simply return null again.
    //
    pure virtual function iterator
    next();

endclass: iterator

`endif // NICE_ITERATOR_SVH
