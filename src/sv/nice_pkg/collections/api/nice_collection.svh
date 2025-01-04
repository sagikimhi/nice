`ifndef NICE_COLLECTION_SVH
`define NICE_COLLECTION_SVH

// Interface Class: collections::collection
//
// A collection is a <sized> <iterable> <container> that stores objects of the
// same type in a linear arrangement.
//
interface class collection#(type T=uvm_object)
extends annotations::container#(T);

    parameter type iterable = patterns::iterable#(T);
    parameter type iterator = patterns::iterator#(T);

    // Function: iter
    //
    // Returns an <iterator> over the items of an <iterable>.
    //
    pure virtual function iterator
    iter();

    // Function: size
    //
    // Returns the current size of the container.
    //
    // Implementations shoud return an integer value greater or equal to 0,
    // where 0 is returned for an empty container.
    //
    pure virtual function int
    size();

    // Function: is_empty
    //
    // Returns 1 if a collection is empty, or 0 otherwise.
    //
    pure virtual function bit
    is_empty();

endclass: collection

`endif // NICE_COLLECTION_SVH
