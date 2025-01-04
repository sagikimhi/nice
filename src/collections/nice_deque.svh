//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_collections_deque.svh
// Author        : skimhi
// Created       : Wed Sep 2024, 12:06:27
// Last modified : Wed Sep 2024, 12:06:27
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Wed Sep 2024, 12:06:27
//-----------------------------------------------------------------------------

`ifndef NICE_COLLECTIONS_DEQUEUE_SVH
`define NICE_COLLECTIONS_DEQUEUE_SVH

// Class: collections::deque
//
// An impelmentation of a deque.
//
// Similar to <uvm_queue> with the same general idea of the ability to pass
// around a systemverilog queue as an object reference without the copy overhead
// but provides further utilities for accessing and iterating the collection.
//
class deque#(type T=uvm_object)
extends uvm_pkg::uvm_queue#(T)
implements sequential_collection#(T);
    `define nice_init
    `nice_param_object(deque#(T))
    typedef T sv_queue[$];
    typedef T sv_darray[];
    typedef uvm_pkg::uvm_queue#(T) uvm_queue;
    parameter type iterator = annotations::iterator#(T);
    parameter type deque_iterator = collections::sequential_iterator#(T);

    // ---------------------------------------------------------------------------
    // Group: Constructors
    // ---------------------------------------------------------------------------

    // Function: empty
    //
    // Returns an empty <deque>.
    //
    static function this_type
    empty();
        empty = this_type::type_id::create();
    endfunction: empty

    // Function: from
    //
    // Create a <deque> of type <T> elements from a <collection>.
    //
    static function this_type
    from(sequential_collection _c);
        if (_c == null)
            return this_type::empty();
        else if ($cast(from, _c))
            from = this_type::empty();
            from.take(this_type'(_c));
    endfunction: from

    // Function: from_uvm_queue
    //
    // Create a <deque> of type <T> elements from a <uvm_queue>.
    //
    static function this_type
    from_uvm_queue(uvm_queue _q);
        from_uvm_queue = this_type::empty();
        if (_q != null && !$cast(from_uvm_queue, _q))
            from_uvm_queue.m_imp.copy(_q);
    endfunction: from_uvm_queue

    // Function: from_sv_queue
    //
    // Create a <deque> of type <T> elements from a built-in queue.
    //
    static function this_type
    from_sv_queue(sv_queue _q);
        from_sv_queue = this_type::empty();
        from_sv_queue.m_imp.queue = {_q};
    endfunction: from_sv_queue

    // Function: from_sv_darray
    //
    // Create a <deque> of type <T> elements from a built-in dynamic array.
    //
    static function this_type
    from_sv_darray(sv_darray _da);
        from_sv_darray = this_type::empty();
        from_sv_darray.m_imp.queue = {_da};
    endfunction: from_sv_darray

    // ---------------------------------------------------------------------------
    // Group: Conversions
    // ---------------------------------------------------------------------------

    // Function: as_sv_queue
    //
    // Converts the deque to a standard built-in SystemVerilog queue and
    // returns it
    //
    virtual function sv_queue
    as_sv_queue();
        as_sv_queue = this.m_imp.queue;
    endfunction: as_sv_queue

    // Function: as_sv_darray
    //
    // Converts the deque to a standard built-in SystemVerilog dynamic array
    // and returns it
    //
    virtual function sv_darray
    as_sv_darray();
        if (this.size())
            as_sv_darray = new[this.size()] (this.m_imp.queue);
        else
            as_sv_darray = {};
    endfunction: as_sv_darray

    // Function: as_uvm_queue
    //
    // Converts the deque to a uvm_queue and returns its handle.
    //
    virtual function uvm_queue
    as_uvm_queue();
        $cast(as_uvm_queue, this);
    endfunction: as_uvm_queue

    // ---------------------------------------------------------------------------
    // Group: Sequential Collection Methods
    // ---------------------------------------------------------------------------

    // Function: iter
    //
    // Returns an iterator over the deque.
    //
    virtual function iterator
    iter();
        deque_iterator _it;
        if (this.is_empty())
            return null;
        _it = deque_iterator::type_id::create();
        _it.init(this);
        return _it.iter();
    endfunction: iter

    // Function: size
    //
    // Get the current size of the deque.
    //
    virtual function int
    size();
        return this.m_imp.size();
    endfunction: size

    // Function: contains
    //
    // Returns 1 if item is an element of the deque, or 0 otherwise.
    //
    virtual function bit
    contains(T item);
        return item inside {this.m_imp.queue};
    endfunction: contains

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
    virtual function int
    index(T item);
        int _q[$];
        _q = this.m_imp.queue.find_first_index(it) with (it==item);
        return _q.size() ? _q.pop_front(): -1;
    endfunction: index

    // Function: count
    //
    // Return the number of times item appears in the collection.
    //
    virtual function int
    count(T item);
        sv_queue _q = this.m_imp.queue.find(it) with (it == item);
        return _q.size();
    endfunction: count

    // Function: is_empty
    //
    // Returns 1 if the deque is empty or 0 otherwise
    //
    virtual function bit
    is_empty();
        return this.size() == 0;
    endfunction: is_empty

    // ---------------------------------------------------------------------------
    // Group: Dequeue Interface
    // ---------------------------------------------------------------------------

    // Function: get
    //
    // Get the item at the specified index
    //
    virtual function T
    get(int index);
        if (index != -1)
            return this.m_imp.get(index);
        else
            return this.m_imp.get(this._last_index());
    endfunction: get

    // Function: set
    //
    // Set the item at the specified index to item.
    //
    virtual function void
    set(T item, int index);
        if (index == -1)
            this.m_imp.queue[this._last_index()] = item;
        else if (this._is_index_valid(index))
            this.m_imp.queue[index] = item;
    endfunction: set

    // Function: pop
    //
    // Pop an item from the queue at the specified index and return it.
    //
    // The value -1 can be given as index to pop the last item in the queue
    // (synonymous to calling <pop_back>).
    //
    virtual function T
    pop(int index=-1);
        if (index == -1)
            return this.m_imp.pop_back();

        if (index == 0)
            return this.m_imp.pop_front();

        pop = this.get(index);
        this.delete(index);
    endfunction: pop

    // Function: push
    //
    // Push/insert an item to the queue at the specified index.
    //
    // The value -1 can be given as index to push an item to the back of the
    // queue (synonymous to calling <pop_back>).
    //
    virtual function void
    push(T item, int index=-1);
        if (index == -1)
            this.m_imp.push_back(item);
        else if (index == 0)
            this.m_imp.push_front(item);
        else
            this.insert(index, item);
    endfunction: push

    // Function: take
    //
    // Replaces the current queue buffer with the given uvm_queue _q.
    //
    // If _q is null, the function silently returns and no operation will take
    // place.
    //
    virtual function void
    take(uvm_queue _q_or_dq);
        this_type tmp;

        if ($cast(tmp, _q_or_dq)) begin
            this.m_imp = tmp.m_imp;
            tmp.m_imp = null;
            return;
        end

        if (_q_or_dq != null)
            this.m_imp = _q_or_dq;
    endfunction: take

    // Function: swap
    //
    // Swap buffers between this <deque> instance and _q_or_dq.
    //
    virtual function void
    swap(this_type _dq);
        if (_dq != null) begin
            uvm_queue tmp;
            tmp = this.m_imp;
            this.m_imp = _dq.m_imp;
            _dq.m_imp = tmp;
        end
    endfunction: swap

    // Function: clear
    //
    // Delete all items from the deque
    //
    virtual function void
    clear();
        this.m_imp.delete(-1);
    endfunction: clear

    // Function: delete
    //
    // Delete the item at the specified index from the deque
    //
    virtual function void
    delete(int index=-1);
        if (index == -1)
            this.m_imp.delete(this._last_index());
        else if (this._is_index_valid(index))
            this.m_imp.queue.delete(index);
    endfunction: delete

    // Function: insert
    //
    // Insert the item item at the specified index
    //
    virtual function void
    insert(int index, T item);
        this.m_imp.insert(index, item);
    endfunction: insert

    // Function: get_front
    //
    // Get the item at the front of the deque
    //
    virtual function T
    get_front();
        if (!this.is_empty())
            get_front = this.m_imp.queue[0];
    endfunction: get_front

    // Function: get_back
    //
    // Get the item at the back of the deque
    //
    virtual function T
    get_back();
        if (!this.is_empty())
            get_back = this.m_imp.queue[$];
    endfunction: get_back

    // Function: pop_front
    //
    // Pop the next item from the front of the deque
    //
    virtual function T
    pop_front();
        pop_front = this.m_imp.pop_front();
    endfunction: pop_front

    // Function: pop_back
    //
    // Pop the next item from the back of the deque
    //
    virtual function T
    pop_back();
        pop_back = this.m_imp.pop_back();
    endfunction: pop_back

    // Function: push_front
    //
    // Append item to the front of the deque
    //
    virtual function void
    push_front(T item);
        this.m_imp.push_front(item);
    endfunction: push_front

    // Function: push_back
    //
    // Prepend item to the back of the deque
    //
    virtual function void
    push_back(T item);
        this.m_imp.push_back(item);
    endfunction: push_back

    // Function: extend_front
    //
    // Extend the deque, prepending all items from _dq to the front of the
    // deque
    //
    virtual function void
    extend_front(uvm_queue _q);
        if (_q != null) begin
            this_type tmp;
            if ($cast(tmp, _q))
                this.m_imp.queue = {tmp.m_imp.queue, this.m_imp.queue};
            else
                this.m_imp.queue = {_q.queue, this.m_imp.queue};
        end
    endfunction: extend_front

    // Function: extend_back
    //
    // Extend the deque, appending all items from _dq to the back of the
    // deque
    //
    virtual function void
    extend_back(uvm_queue _q);
        if (_q != null) begin
            this_type tmp;
            if ($cast(tmp, _q))
                this.m_imp.queue = {this.m_imp.queue, tmp.m_imp.queue};
            else
                this.m_imp.queue = {this.m_imp.queue, _q.queue};
        end
    endfunction: extend_back

    // Function: slice
    //
    // Returns a new slice from the current <deque> instance starting at the
    // specified _start argument, and ending at _end.
    //
    // An optional _step may be specified iterate add every Nth element between
    // _start and _end to the deque.
    //
    virtual function this_type
    slice(int _start, int _stop=-1, int _step=1);
        slice = this_type::type_id::create();

        if (_start == -1)
            _start = this._last_index();

        if (_stop == -1)
            _stop = this._last_index();

        if (_start < _stop && _step > 0)
            _step *= -1;

        slice = this_type::empty();

        for (int i = _start; this._is_index_valid(i) && i < _stop; i += _step)
            slice.push_back(this.get(i));
    endfunction: slice

    // Function: unique
    //
    // Returns a new deque with unique elements from the deque on which
    // the method was invoked.
    //
    virtual function this_type
    unique_();
        bit _unique_aa[T];

        unique_ = this_type::empty();

        for (iterator i = this.iter(); i != null; i = i.next())
            _unique_aa[i.item()] = !_unique_aa.exists(i.item());

        foreach (_unique_aa[i])
            if (_unique_aa[i])
                unique_.push_back(i);
    endfunction: unique_

    // Function: duplicates
    //
    // Returns a new deque with duplicate elements from the deque on which
    // the method was invoked.
    //
    virtual function this_type
    duplicates();
        bit _dup_aa[T];

        duplicates = this_type::empty();

        for (iterator i = this.iter(); i != null; i = i.next())
            _dup_aa[i.item()] = bit'(_dup_aa.exists(i.item()));

        foreach (_dup_aa[i])
            if (_dup_aa[i])
                duplicates.push_back(i);
    endfunction: duplicates

    // Function: unique_indices
    //
    // Returns a deque of unique item indices, i.e. indices of items which
    // have no more than a single appearance in this deque instance.
    //
    virtual function deque#(int)
    unique_indices();
        int ii;
        iterator i;
        int _unique_aa[T];

        unique_indices = deque#(int)::empty();

        for (i = this.iter(), ii = 0; i != null; i = i.next(), ii++)
            _unique_aa[i.item()] = _unique_aa.exists(i.item()) ? -1 : ii;

        foreach (_unique_aa[i])
            if (_unique_aa[i] != -1)
                unique_indices.push_back(_unique_aa[i]);
    endfunction: unique_indices

    // Function: duplicate_indices
    //
    // Returns a deque of duplicate item indices, i.e. indices of items which
    // have more than a single appearance in this deque instance.
    //
    virtual function deque#(int)
    duplicate_indices();
        int ii;
        iterator i;
        int _dup_aa[T][$];

        duplicate_indices = deque#(int)::empty();

        foreach (this.m_imp.queue[i])
            _dup_aa[this.m_imp.queue[i]].push_back(i);

        foreach (_dup_aa[i])
            if (_dup_aa[i].size() > 1)
                duplicate_indices.extend_back(
                    deque#(int)::from_sv_queue(_dup_aa[i])
                );
    endfunction: duplicate_indices

    // ---------------------------------------------------------------------------
    // Internal
    // ---------------------------------------------------------------------------

    local uvm_queue m_imp;

    virtual function void
    init();
        this.m_imp = new("m_imp");
    endfunction: init

    virtual function uvm_queue
    imp();
        return this.m_imp;
    endfunction: imp

    virtual function void
    set_imp(uvm_queue _imp);
        if (_imp != null)
            this.m_imp = _imp;
        else
            this.m_imp.delete(-1);
    endfunction: set_imp

    virtual function bit
    _is_index_valid(int index);
        return index >= 0 && index < this.size();
    endfunction: _is_index_valid

    virtual function void
    _check_index(int index);
        if (!this._is_index_valid(index))
            `sp_ftl($sformatf("Invalid index: %0d", index))
    endfunction: _check_index

    virtual function int
    _last_index();
        return (this.is_empty() ? 0 : this.size() - 1);
    endfunction: _last_index

endclass: deque


`endif // NICE_COLLECTIONS_DEQUEUE_SVH
