`ifndef NICE_PATTERNS_COMPOSITION_NODE_ADAPTER_SVH
`define NICE_PATTERNS_COMPOSITION_NODE_ADAPTER_SVH

// Class: patterns::composition_node
//
// An adapter of a concrete composite node for sequences and sequence items.
//
// For more information about composite classes, please refer to the <composite>
// interface class documentation.
//
class composition_node#(type IMP_T=uvm_sequence_base)
extends composition_leaf#(IMP_T);
    `nice_param_object_utils(composition_node#(IMP_T))

    // ---------------------------------------------------------------------------
    // Group: Composite Inquiries
    // ---------------------------------------------------------------------------

    // Function: child_index
    //
    // See <patterns::composite::child_index()>.
    //
    virtual function int
    child_index(composite _child);
        if (this.m_map.exists(_child))
            return this.m_map[_child];
        else
            return -1;
    endfunction

    // Function: num_children
    //
    // See <patterns::composite::num_children()>.
    //
    virtual function int
    num_children();
        return this.m_queue.size();
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Composite Hierarchey
    // ---------------------------------------------------------------------------

    // Function: child
    //
    // See <patterns::composite::child()>.
    //
    virtual function composite
    child(int _index);
        return this.m_queue.get(_index);
    endfunction

    // Function: children
    //
    // See <patterns::composite::children()>.
    //
    virtual function iterator
    children();
        return this.iter();
    endfunction

    // Function: add_child
    //
    // See <patterns::composite::add_child()>.
    //
    virtual function void
    add_child(composite _child);

        if (!this.m_map.exists(_child)) begin
            int _n = this.num_children();
            this.m_map[_child] = _n;
            this.m_queue.push_back(_child);
            _child.set_parent(this);
        end
    endfunction

    // Function: add_children
    //
    // See <patterns::composite::add_children()>.
    //
    virtual function void
    add_children(iterable _children);
        iterator i = _children.iter();
        for (; i.iter() != null; i = i.next())
            this.add_child(i.item());
    endfunction

    // Function: remove_child
    //
    // See <patterns::composite::remove_child()>.
    //
    virtual function void
    remove_child(composite _child);
        uvm_sequence_base _seq;

        if (this.m_map.exists(_child)) begin
            this.m_queue.delete(this.m_map[_child]);
            this.m_map.delete(_child);

            if ($cast(_seq, _child))
                _seq.set_parent_sequence(null);
        end
    endfunction

    // Function: remove_child_at
    //
    // See <patterns::composite::remove_child_at()>.
    //
    virtual function void
    remove_child_at(int _index);
        this.remove_child(this.child(_index));
    endfunction

    // Function: remove_children
    //
    // See <patterns::composite::remove_children()>.
    //
    virtual function void
    remove_children();
        int _n = this.num_children();
        while (_n--)
            this.m_queue.get(_n).set_parent(null);
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Composite Hierarchy - Iteration Interface
    // ---------------------------------------------------------------------------

    // Function: iter
    //
    // See <patterns::iterable::iter()>.
    //
    virtual function iterator
    iter();
        composition_iterator _iter;
        _iter = new(this);
        $cast(iter, _iter);
    endfunction

    // Function: next_child
    //
    // See <patterns::composite::next_child()>.
    //
    virtual function bit
    next_child(ref composite _child);
        return bit'(this.m_map.next(_child));
    endfunction

    // Function: prev_child
    //
    // See <patterns::composite::prev_child()>.
    //
    virtual function bit
    prev_child(ref composite _child);
        return bit'(this.m_map.prev(_child));
    endfunction

    // Function: first_child
    //
    // See <patterns::composite::first_child()>.
    //
    virtual function composite
    first_child();
        if (!this.m_map.first(first_child))
            return null;
    endfunction

    // Function: last_child
    //
    // See <patterns::composite::last_child()>.
    //
    virtual function composite
    last_child();
        if (!this.m_map.last(last_child))
            return null;
    endfunction

    // Function: dft_child
    //
    // Note: Unimplemented.
    //
    // See <patterns::composite::dft_child()>.
    //
    virtual function composite
    dft_child();
        `NICE_FTL(("Unimplemented."))
    endfunction

    // Function: bft_child
    //
    // Note: Unimplemented.
    //
    // See <patterns::composite::bft_child()>.
    //
    virtual function composite
    bft_child();
        `NICE_FTL(("Unimplemented."))
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Ownership Interface
    // ---------------------------------------------------------------------------

    // Function: has_child
    //
    // See <patterns::composite::has_child()>.
    //
    virtual function bit
    has_child(composite _child);
        return this.m_map.exists(_child);
    endfunction

    // Function: is_node
    //
    // See <patterns::composite::is_node()>.
    //
    virtual function bit
    is_node();
        return 1;
    endfunction

    // Function: is_leaf
    //
    // See <patterns::composite::is_leaf()>.
    //
    virtual function bit
    is_leaf();
        return this.has_children();
    endfunction

    // ---------------------------------------------------------------------------
    // Internal
    // ---------------------------------------------------------------------------

    protected int m_map[composite];
    protected composite_queue m_queue;

endclass: composition_node

`endif // NICE_PATTERNS_COMPOSITION_NODE_ADAPTER_SVH
