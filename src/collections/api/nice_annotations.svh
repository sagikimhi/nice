`ifndef NICE_ANNOTATIONS_SVH
`define NICE_ANNOTATIONS_SVH


// Interface Class: annotations::sized
//
// An annotation for container types.
//
// Implementations must define the <size()> method.
//
interface class sized;

    // Function: size
    //
    // Returns the current size of the container.
    //
    // Implementations shoud return an integer value greater or equal to 0,
    // where 0 is returned for an empty container.
    //
    pure virtual function int
    size();

endclass: sized

// Interface Class: annotations::hashable
//
// An annotation for associative container types.
//
// Implementations must define the <hash()> method.
//
interface class hashable;

    // Function: hash
    //
    // Returns an integer hash value.
    //
    // The only required property is that object which compare equal have the
    // same hash value.
    //
    pure virtual function int
    hash();

endclass: hashable

// Interface Class: annotations::container
//
// An annotation for container types.
//
// Implementations must define the <contains()> method.
//
interface class container#(type T=uvm_object) extends sized;

    // Function: contains
    //
    // Return 1 if item is in the container, or 0 otherwise.
    //
    pure virtual function bit
    contains(T item);

endclass: container

// Interface Class: annotations::sequential
//
// An annotation for sequential container types.
//
// A sequential container is an <iterable> which supports efficient element
// access using integer indices via the <get()> method.
//
interface class sequential#(type T=uvm_object);

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

endclass: sequential

`endif // NICE_ANNOTATIONS_SVH
