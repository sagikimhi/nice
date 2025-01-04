//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_set.svh
// Author        : skimhi
// Created       : Sun Sep 2024, 14:18:44
// Last modified : Sun Sep 2024, 14:18:44
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Sun Sep 2024, 14:18:44
//-----------------------------------------------------------------------------

`ifndef NICE_SET_SVH
`define NICE_SET_SVH

class set#(type T=uvm_object)
extends uvm_object
implements unordered_set#(T);
    `define nice_init
    `nice_param_object(collections::set#(T))
    typedef T sv_queue[$];
    typedef T sv_darray[];
    parameter type deque = collections::deque#(T);
    parameter type iterable = annotations::iterable#(T);
    parameter type iterator = annotations::iterator#(T);
    parameter type set_iterator = collections::sequential_iterator#(T);

    // ---------------------------------------------------------------------------
    // Group: Constructors
    // ---------------------------------------------------------------------------

    // Function: empty
    //
    // Returns an empty <set>.
    //
    static function this_type
    empty();
        return this_type::type_id::create();
    endfunction: empty

    // Function: from
    //
    // Create a <this_type> of type <T> elements from a <collection>.
    //
    static function this_type
    from(collection#(T) _c);
        if (!$cast(from, _c))
            from = this_type::empty();

        if (!$cast(from.m_dq, _c))
            from.update(_c);
        else
            from.m_dq = from.m_dq.unique_();
    endfunction: from

    // Function: from_uvm_queue
    //
    // Create a <this_type> of type <T> elements from a <uvm_queue>.
    //
    static function this_type
    from_uvm_queue(uvm_queue _q);
        from_uvm_queue = this_type::empty();
        from_uvm_queue.m_dq = deque::from_uvm_queue(_q).unique_();
    endfunction: from_uvm_queue

    // Function: from_sv_queue
    //
    // Create a <this_type> of type <T> elements from a built-in queue.
    //
    static function this_type
    from_sv_queue(sv_queue _q);
        from_sv_queue = this_type::empty();
        foreach (_q[i])
            from_sv_queue.add(_q[i]);
    endfunction: from_sv_queue

    // Function: from_sv_darray
    //
    // Create a <this_type> of type <T> elements from a built-in dynamic array.
    //
    static function this_type
    from_sv_darray(sv_darray _da);
        uvm_pkg::uvm_report_fatal(
            {"this_type#(", $typename(T), ")"}, "Unimplemented."
        );
    endfunction: from_sv_darray

    // ---------------------------------------------------------------------------
    // Group: Iteration
    // ---------------------------------------------------------------------------

    // Function: iter
    //
    // Returns an <iterator> over the elements of a collection.
    //
    virtual function iterator
    iter();
        set_iterator _it;
        if (this.is_empty())
            return null;
        _it = set_iterator::type_id::create();
        _it.init(this);
        return _it.iter();
    endfunction: iter

    // Function: size
    //
    // Get the size of a collection
    //
    virtual function int
    size();
    endfunction: size

    // Function: contains
    //
    // Returns 1 if _item is an element of a collection, or 0 otherwise.
    //
    virtual function bit
    contains(T item);
    endfunction: contains

    // Function: is_empty
    //
    // Returns 1 if a collection is empty, or 0 otherwise.
    //
    virtual function bit
    is_empty();
        return this.size() == 0;
    endfunction: is_empty

    // ---------------------------------------------------------------------------
    // Group: Conversion
    // ---------------------------------------------------------------------------

    // Function: as_uvm_queue
    //
    // Returns a collection as a <uvm_queue> of all elements in collection.
    //
    virtual function uvm_queue
    as_uvm_queue();
    endfunction: as_uvm_queue

    // Function: as_sv_queue
    //
    // Returns a collection as a SystemVerilog built-in queue of items from the
    // collection.
    //
    virtual function sv_queue
    as_sv_queue();
    endfunction: as_sv_queue

    // Function: as_sv_darray
    //
    // Returns a collection as a SystemVerilog built-in dynamic array of items
    // from the collection.
    //
    virtual function sv_darray
    as_sv_darray();
    endfunction: as_sv_darray

    // ---------------------------------------------------------------------------
    // Group: this_type Interface
    // ---------------------------------------------------------------------------

    // Function: add
    //
    // Add _item to the this_type.
    //
    virtual function void
    add(T _item);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: add

    // Function: update
    //
    // Add elmenets from this_type _s to the this_type.
    //
    virtual function void
    update(iterable _s);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: update

    // Function: remove
    //
    // Remove _item from the this_type.
    //
    virtual function int
    remove(T _item);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: remove

    // Function: clear
    //
    // Remove all elements from the this_type.
    //
    virtual function void
    clear();
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: clear

    // Function: union_
    //
    // Return the union of sets as a new this_type.
    //
    virtual function this_type
    union_(this_type _s);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: union_

    // Function: difference
    //
    // Return the difference of sets as a new this_type.
    //
    virtual function this_type
    difference(this_type _s);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: difference

    // Function: difference_update
    //
    // Update a this_type with the difference of itself and another.
    //
    virtual function void
    difference_update(this_type _s);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: difference_update

    // Function: intersection
    //
    // Return the intersection of sets as a new this_type.
    //
    virtual function this_type
    intersection(this_type _s);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: intersection

    // Function: intersection_update
    //
    // Update a this_type with the intersection of itself and another.
    //
    virtual function void
    intersection_update(this_type _s);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: intersection_update

    // Function: symmetric_difference
    //
    // Return the symmetric difference of sets as a new this_type.
    //
    virtual function this_type
    symmetric_difference(this_type _s);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: symmetric_difference

    // Function: symmetric_difference_update
    //
    // Update a this_type with the symmetric difference of itself and another.
    //
    virtual function void
    symmetric_difference_update(this_type _s);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: symmetric_difference_update

    // Function: is_disjoint
    //
    // Return 1 if the intersection the this_type with _s is an empty this_type, or 0
    // otherwise.
    //
    virtual function bit
    is_disjoint(this_type _s);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: is_disjoint

    // Function: is_subset
    //
    // Return 1 if every element in the this_type is in _s, or 0 otherwise.
    //
    virtual function bit
    is_subset(this_type _s);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: is_subset

    // Function: is_superset
    //
    // Return 1 if every element in _s is in this this_type, or 0 otherwise.
    //
    virtual function bit
    is_superset(this_type _s);
        uvm_report_fatal("this_type", "Unimplemented.");
    endfunction: is_superset

    // ---------------------------------------------------------------------------
    // Internal
    // ---------------------------------------------------------------------------

    local uvm_pool#(T, T) m_pool;
    local deque m_dq;

    virtual function void
    init();
        this.m_pool = new("m_pool");
        this.m_dq = deque::type_id::create();
    endfunction: init
endclass: set

`endif // NICE_SET_SVH
