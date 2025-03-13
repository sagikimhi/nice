`ifndef NICE_PATTERNS_COMPOSITE_LEAF_ADAPTER_SVH
`define NICE_PATTERNS_COMPOSITE_LEAF_ADAPTER_SVH

// Class: patterns::composition_leaf
//
// Base composite adapter class for leaf node classes.
//
// Implements a common interface for leaf and composite sequence items to act as a
// single unit type and vary seamlessly.
//
// The <is_composite()> and <is_leaf()> methods may be used to differentiate
// between leaf and composite item types.
//
class composition_leaf#(type IMP_T=uvm_sequence_base)
extends IMP_T implements composite;
    `define nice_init_cb
    `nice_param_object_utils(composition_leaf#(IMP_T))
    `nice_uid_field_util
    localparam type composite_queue = uvm_queue#(composite);

    // ---------------------------------------------------------------------------
    // Group: Identification Interface
    // ---------------------------------------------------------------------------

    // Function: uid
    //
    // See <misc::uid_object::uid()>.
    //
    virtual function int
    uid();
        return this.m_uid.uid();
    endfunction

    // Function: uuid
    //
    // See <patterns::composite::uuid()>.
    //
    virtual function int
    uuid();
        return this.get_inst_id();
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Get Methods
    // ---------------------------------------------------------------------------

    // Function: depth
    //
    // See <patterns::composite::depth()>.
    //
    virtual function int
    depth();
        return this.get_depth() - this.root().depth();
    endfunction

    // Function: index
    //
    // See <patterns::composite::index()>.
    //
    virtual function int
    index();
        return this.has_parent() ? this.parent().child_index(this): -1;
    endfunction

    // Function: child_index
    //
    // See <patterns::composite::child_index()>.
    //
    virtual function int
    child_index(composite _child);
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: num_children
    //
    // See <patterns::composite::num_children()>.
    //
    virtual function int
    num_children();
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Hierarchy Interface
    // ---------------------------------------------------------------------------

    // Function: root
    //
    // See <patterns::composite::root()>.
    //
    virtual function composite
    root();
        if (!$cast(root, this.get_root_sequence()))
            return null;
    endfunction

    // Function: parent
    //
    // See <patterns::composite::parent()>.
    //
    virtual function composite
    parent();
        if (!$cast(parent, this.get_parent_sequence()))
            return null;
    endfunction

    // Function: child
    //
    // See <patterns::composite::child()>.
    //
    virtual function composite
    child(int _index);
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: children
    //
    // See <patterns::composite::children()>.
    //
    virtual function composite_queue
    children();
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: set_parent
    //
    // See <patterns::composite::set_parent()>.
    //
    virtual function void
    set_parent(composite _parent);
        IMP_T newp;

        if ($cast(newp, _parent))
            this.set_parent_sequence(newp);
        else
            this._set_parent(_parent);
    endfunction

    // Function: add_child
    //
    // See <patterns::composite::add_child()>.
    //
    virtual function void
    add_child(composite _child);
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: add_children
    //
    // See <patterns::composite::add_children()>.
    //
    virtual function void
    add_children(composite_queue _children);
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: remove_child
    //
    // See <patterns::composite::remove_child()>.
    //
    virtual function void
    remove_child(composite _child);
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: remove_child_at
    //
    // See <patterns::composite::remove_child_at()>.
    //
    virtual function void
    remove_child_at(int _index);
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: remove_children
    //
    // See <patterns::composite::remove_children()>.
    //
    virtual function void
    remove_children();
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Iteration Interface
    // ---------------------------------------------------------------------------

    // Function: iter
    //
    // See <patterns::composite::iter()>.
    //
    virtual function iterator
    iter();
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: next_child
    //
    // See <patterns::composite::next_child()>.
    //
    virtual function bit
    next_child(ref composite _child);
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: prev_child
    //
    // See <patterns::composite::prev_child()>.
    //
    virtual function bit
    prev_child(ref composite _child);
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: first_child
    //
    // See <patterns::composite::first_child()>.
    //
    virtual function composite
    first_child();
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: last_child
    //
    // See <patterns::composite::last_child()>.
    //
    virtual function composite
    last_child();
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: dft_child
    //
    // See <patterns::composite::dft_child()>.
    //
    virtual function composite
    dft_child();
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // Function: bft_child
    //
    // See <patterns::composite::bft_child()>.
    //
    virtual function composite
    bft_child();
        `NICE_FTL(("Undefined for leaf components"))
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Composite Inquiries
    // ---------------------------------------------------------------------------

    // Function: is
    //
    // See <patterns::composite::is()>.
    //
    virtual function bit
    is(composite _other);
        return this == _other;
    endfunction

    // Function: is_not
    //
    // See <patterns::composite::is_not()>.
    //
    virtual function bit
    is_not(composite _other);
        return !this.is(_other);
    endfunction

    // Function: is_root
    //
    // See <patterns::composite::is_root()>.
    //
    virtual function bit
    is_root();
        return this.parent() == null;
    endfunction

    // Function: is_composite
    //
    // See <patterns::composite::is_composite()>.
    //
    virtual function bit
    is_node();
        return 0;
    endfunction

    // Function: is_leaf
    //
    // See <patterns::composite::is_leaf()>.
    //
    virtual function bit
    is_leaf();
        return 1;
    endfunction

    // Function: has_parent
    //
    // See <patterns::composite::has_parent()>.
    //
    virtual function bit
    has_parent();
        return this.parent() != null;
    endfunction

    // Function: has_child
    //
    // See <patterns::composite::has_child()>.
    //
    virtual function bit
    has_child(composite _child);
        return 0;
    endfunction

    // Function: has_children
    //
    // See <patterns::composite::has_children()>.
    //
    virtual function bit
    has_children();
        return this.num_children() > 0;
    endfunction

    // Function: has_next_child
    //
    // See <patterns::composite::has_next_child()>.
    //
    virtual function bit
    has_next_child(ref composite _child);
        return this.child_index(_child) < this.num_children();
    endfunction

    // Function: has_prev_child
    //
    // See <patterns::composite::has_prev_child()>.
    //
    virtual function bit
    has_prev_child(ref composite _child);
        return this.child_index(_child) > 0;
    endfunction

    // Function: is_index_valid
    //
    // See <patterns::composite::is_index_valid()>.
    //
    virtual function bit
    is_index_valid(int _index);
        return _index > 0
            && _index < this.num_children();
    endfunction

    // Function: is_parent_of
    //
    // See <patterns::composite::is_parent_of()>.
    //
    virtual function bit
    is_parent_of(composite _child);
        return _child != null
            && this.is_node()
            && _child.is_child_of(this);
    endfunction

    // Function: is_child_of
    //
    // See <patterns::composite::is_child_of()>.
    //
    virtual function bit
    is_child_of(composite _parent);
        return this.has_parent() && this.parent().is(_parent);
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Sequence Overrides
    // ---------------------------------------------------------------------------

    // Function: set_parent_sequence
    //
    // See <uvm_sequence_item::set_parent_sequence()>.
    //
    virtual function void
    set_parent_sequence(IMP_T parent);
        composite _newp;

        super.set_parent_sequence(parent);

        if ($cast(_newp, parent))
            this._set_parent(_newp);
    endfunction

    // ---------------------------------------------------------------------------
    // Internal
    // ---------------------------------------------------------------------------

    virtual function void
    init();
        this.init_uid();
        this.set_root(null);
        this.set_parent(null);
        this.set_depth(0);
    endfunction

    protected virtual function void
    set_root(composite _root);
        this.root().set_parent(_root);
    endfunction

    protected virtual function void
    _set_parent(composite _newp);
        composite _oldp;

        _oldp = this.parent();

        if (_newp != null && _newp.is_not(_oldp)) begin
            if (_oldp != null)
                _oldp.remove_child(this);

            if (_newp.is_not(this))
                _newp.add_child(this);
        end
    endfunction

endclass: composition_leaf


`endif // NICE_PATTERNS_COMPOSITE_LEAF_ADAPTER_SVH
