`ifndef NICE_SET_CONTAINER_SVH
`define NICE_SET_CONTAINER_SVH

// Interface Class: collections::unordered_set
//
// An unordered_set is an <unordered_collection> of unique elements.
//
interface class unordered_set#(type T=uvm_object)
extends collections::unordered_collection#(T);

    parameter type unordered_set = collections::unordered_set#(T);

    // Function: is_disjoint
    //
    // Return 1 if the intersection the unordered_set with _s is an empty unordered_set, or 0
    // otherwise.
    //
    pure virtual function bit
    is_disjoint(unordered_set _s);

    // Function: is_subset
    //
    // Return 1 if every element in the unordered_set is in _s, or 0 otherwise.
    //
    pure virtual function bit
    is_subset(unordered_set _s);

    // Function: is_superset
    //
    // Return 1 if every element in _s is in this unordered_set, or 0 otherwise.
    //
    pure virtual function bit
    is_superset(unordered_set _s);

    // Function: union_
    //
    // Return the union of sets as a new unordered_set.
    //
    pure virtual function unordered_set
    union_(unordered_set _s);

    // Function: intersection
    //
    // Return the intersection of sets as a new unordered_set.
    //
    pure virtual function unordered_set
    intersection(unordered_set _s);

    // Function: intersection_update
    //
    // Update a unordered_set with the intersection of itself and another.
    //
    pure virtual function void
    intersection_update(unordered_set _s);

    // Function: symmetric_difference
    //
    // Return the symmetric difference of sets as a new unordered_set.
    //
    pure virtual function unordered_set
    symmetric_difference(unordered_set _s);

    // Function: symmetric_difference_update
    //
    // Update a unordered_set with the symmetric difference of itself and another.
    //
    pure virtual function void
    symmetric_difference_update(unordered_set _s);

endclass: unordered_set

`endif // NICE_SET_CONTAINER_SVH
