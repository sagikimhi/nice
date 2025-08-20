`ifndef NICE_COMPOSITION_ITERATOR_SVH
`define NICE_COMPOSITION_ITERATOR_SVH

// Class: patterns::composition_iterator
//
// A concrete iterator class to iterate over a composition graph, i.e. a
// parent-child relational graph of composite classes.
// //
// For additional information regarding iterators, see <patterns::iterator>.
//
// For additional information regarding composite pattern and classes, see
// <patterns::composite>.
//
class composition_iterator implements iterator#(composite);

    localparam type iterator = patterns::iterator#(composite);

    // Function: iter
    //
    // See <patterns::iterable::iter()>.
    //
    virtual function iterator
    iter();
        if (this.m_done || !$cast(iter, this))
            return null;
    endfunction

    // Function: item
    //
    // See <patterns::iterator::item()>.
    //
    virtual function composite
    item();
        if (this.m_done)
            return null;

        if (this.m_index == -1)
            void'(this.next());

        return this.m_comp.child(this.m_index);
    endfunction

    // Function: next
    //
    // See <patterns::iterator::next()>.
    //
    virtual function iterator
    next();
        if (this.m_done)
            return null;
        this.m_index++;
        this._validate();
        return this.iter();
    endfunction

    // -------------------------------------------------------------------------
    // Internal
    // -------------------------------------------------------------------------

    local bit m_done;
    local int m_index;
    local composite m_comp;

    function new(composite comp);
        this.m_index = -1;
        this.m_comp = comp;
        this.m_done = !this._is_valid();
    endfunction

    protected virtual function void
    _validate();
        this.m_done = !this._is_valid();
    endfunction

    protected virtual function bit
    _is_valid();
        return !this.m_done
            && this._is_comp_valid()
            && this._is_index_valid(this.m_comp.num_children());
    endfunction

    protected virtual function bit
    _is_comp_valid();
        return (
            this.m_comp != null
            && this.m_comp.is_node()
            && this.m_comp.has_children()
        );
    endfunction

    protected virtual function bit
    _is_index_valid(int _n);
        return this.m_index >= -1 && this.m_index < _n;
    endfunction

endclass: composition_iterator

`endif // NICE_COMPOSITION_ITERATOR_SVH
