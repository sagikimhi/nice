`ifndef NICE_ENUM_ITERATOR_SVH
`define NICE_ENUM_ITERATOR_SVH

typedef enum {DUMMY_ENUM_FIELD_DO_NOT_USE = 0} dummy_enum;

// Class: patterns::enum_iterator
//
// An <iterator> implementation for iterating over enums.
//
class enum_iterator#(type T=dummy_enum)
extends uvm_object
implements  iterator#(T);
    `define nice_init_cb
    `nice_param_object_utils(enum_iterator#(T))

    // ---------------------------------------------------------------------------
    // Group: Constructors
    // ---------------------------------------------------------------------------

    // Function: from
    //
    // Returns a new <enum_iterator> instance starting at the first enumeration
    // value by default.
    //
    // If ~start~ is specified, the returned instance will be initialized to
    // start at the specified ~start~ value.
    //
    static function iterator
    from(T _start=_.first());
        this_type _it;
        _it = new();
        _it._set_start(_start);
        return iterator'(_it);
    endfunction: from

    // -------------------------------------------------------------------------
    // Group: Iterator Interface
    // -------------------------------------------------------------------------

    virtual function T
    iter();
        return this;
    endfunction: iter

    // Function: item
    //
    // Returns the iterator's current enumeration value.
    //
    virtual function T
    item();
        return this.m_item;
    endfunction: item

    // Function: first
    //
    // Returns the first field of the enumeration.
    //
    virtual function T
    first();
        return _.first();
    endfunction: first

    // Function: last
    //
    // Returns the last field of the enumeration.
    //
    virtual function T
    last();
        return _.last();
    endfunction: last

    // Function: start
    //
    // Returns the starting value of this iterator instance.
    //
    virtual function T
    start();
        return this.m_start;
    endfunction: start

    // Function: prev
    //
    // Progresses the iterator instance to the previous enumeration value and
    // returns it.
    //
    virtual function iterator
    prev();
        if (this.m_next_was_called == 0)
            this.m_next_was_called = 1;
        else if (this.has_prev() == 1)
            this.m_item = this.m_item.prev();
        else
            return null;

        return this;
    endfunction: prev

    // Function: next
    //
    // Progresses the iterator instance to the next enumeration value and
    // returns it.
    //
    virtual function iterator
    next();
        if (this.m_next_was_called == 0)
            this.m_next_was_called = 1;
        else if (this.has_next() == 1)
            this.m_item = this.m_item.next();
        else
            return null;
        return this;
    endfunction: next

    // Function: has_next
    //
    // Returns 1 if the iterator's item is pointing at the last enumeration
    // field, or 0 otherwise.
    //
    virtual function bit
    has_next();
        return this.m_next_was_called && this.m_item == this.m_item.last();
    endfunction: has_next

    // Function: has_prev
    //
    // Returns 1 if the iterator's item is pointing at the first enumeration
    // field, or 0 otherwise.
    //
    virtual function bit
    has_prev();
        return this.m_next_was_called && this.m_item == this.m_item.first();
    endfunction: has_prev

    // -------------------------------------------------------------------------
    // Internal
    // -------------------------------------------------------------------------

    local T m_item;
    local T m_start;
    local bit m_next_was_called;
    local const static T _ = _.first();

    protected function void
    init();
        this.m_next_was_called = 0;
        this._set_start(_.first());
    endfunction: init

    protected virtual function void
    _set_start(T _start);
        this.m_item = _start;
        this.m_start = _start;
        this.m_next_was_called = 0;
    endfunction: _set_start

endclass: enum_iterator

`endif // NICE_ENUM_ITERATOR_SVH
