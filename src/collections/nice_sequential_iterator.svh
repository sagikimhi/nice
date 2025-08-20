`ifndef NICE_SEQUENTIAL_ITERATOR_SVH
`define NICE_SEQUENTIAL_ITERATOR_SVH


// Class: collections::sequential_iterator
//
// A generic iterator class for iterating over collection classes, uvm_queue,
// built-in queue and built-in dynamic arrays.
//
class sequential_iterator#(type T=uvm_object)
extends uvm_object
implements patterns::iterator#(T);
    `define nice_init_cb
    `nice_param_object_utils(sequential_iterator#(T))
    parameter type iterable = patterns::iterable#(T);
    parameter type iterator = patterns::iterator#(T);
    parameter type sequential = collections::sequential_collection#(T);

    // ---------------------------------------------------------------------------
    // Group: Iterator Interface
    // ---------------------------------------------------------------------------

    // Function: item
    //
    // Returns the iterator's current enumeration value.
    //
    virtual function T
    item();
        if (this.m_index < 0 && this.next())
                return this.item();

        if (this.m_done == 0)
            return this.m_sequential.get(this.m_index);
    endfunction: item

    // Function: iter
    //
    // Returns an <iterator> over the items of an <iterable>.
    //
    virtual function iterator
    iter();
        if (this.m_done || !$cast(iter, this))
            return null;
    endfunction: iter

    // Function: next
    //
    // Progresses the iterator instance to the next enumeration value and
    // returns it.
    //
    virtual function iterator
    next();
        if (this.m_done == 0)
            this.m_index++;

        if (this.m_sequential == null)
            this.m_done = 1;

        if (this.m_index >= this.m_sequential.size())
            this.m_done = 1;

        return this.iter();
    endfunction: next

    // ---------------------------------------------------------------------------
    // Internal
    // ---------------------------------------------------------------------------
    local bit m_done;
    local int m_index;
    sequential m_sequential;

    virtual function void init(sequential _s=null);
        if (this.m_done)
            return;
        this.m_done = 0;
        this.m_index = -1;
        this.m_sequential = _s;
    endfunction
endclass: sequential_iterator

`endif // NICE_SEQUENTIAL_ITERATOR_SVH
