`ifndef NICE_UNORDERED_COLLECTION_SVH
`define NICE_UNORDERED_COLLECTION_SVH

// Interface Class: collections::unordered_collection
//
// An <unordered_collection> is an interface for an unordered associative
// <collection> which implement unsorted (hashed) data structures that can be
// quickly searched.
//
interface class unordered_collection#(type T=uvm_object)
extends collections::collection#(T);
    parameter type iterable = patterns::iterable#(T);
    parameter type iterator = patterns::iterator#(T);
    parameter type unordered_collection = collections::unordered_collection#(T);

    // Function: add
    //
    // Add _item to the unordered_collection.
    //
    pure virtual function void
    add(T _item);

    // Function: update
    //
    // Add elmenets from unordered_collection _s to the unordered_collection.
    //
    pure virtual function void
    update(iterable _s);

    // Function: difference
    //
    // Return the difference of sets as a new unordered_collection.
    //
    pure virtual function unordered_collection
    difference(unordered_collection _s);

    // Function: difference_update
    //
    // Update a unordered_collection with the difference of itself and another.
    //
    pure virtual function void
    difference_update(unordered_collection _s);

    // Function: remove
    //
    // Remove _item from the unordered_collection.
    //
    pure virtual function int
    remove(T _item);

    // Function: clear
    //
    // Remove all elements from the unordered_collection.
    //
    pure virtual function void
    clear();

endclass: unordered_collection

`endif // NICE_UNORDERED_COLLECTION_SVH
