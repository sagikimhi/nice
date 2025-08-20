`ifndef NICE_SEQUENTIAL_COLLECTION_SVH
`define NICE_SEQUENTIAL_COLLECTION_SVH

// Interface Class: collections::sequential_collection
//
// A <collection> which supports efficient element access using integer indices
// via the <get()> method and defines a <size()> method that returns the length
// of the sequence.
//
interface class sequential_collection#(type T=uvm_object)
extends collections::collection#(T);

    parameter type iterable = patterns::iterable#(T);
    parameter type iterator = patterns::iterator#(T);

    // Function: get
    //
    // Returns the item at the specified index.
    //
    // Invalid indices are handled gracefully by returning a default value.
    //
    // An implementation may also optionally issue a warning on an access
    // attempt to an invalid index.
    //
    pure virtual function T
    get(int index);

    // Function: size
    //
    // Returns the current size of the container.
    //
    // Implementations shoud return an integer value greater or equal to 0,
    // where 0 is returned for an empty container.
    //
    pure virtual function int
    size();

    // Function: index
    //
    // Find the index of the first occurence of an item in the collection.
    //
    // implementations should return a zero-based index of the first item whose
    // value is equal to _item.
    //
    // implementations should return -1 to indicate that _item could not be
    // found and is not a part of the collection.
    //
    pure virtual function int
    index(T item);

    // Function: count
    //
    // Return the number of times item appears in the collection.
    //
    pure virtual function int
    count(T item);

    // Function: is_empty
    //
    // Returns 1 if a collection is empty, or 0 otherwise.
    //
    pure virtual function bit
    is_empty();

endclass: sequential_collection

`endif // NICE_SEQUENTIAL_COLLECTION_SVH
