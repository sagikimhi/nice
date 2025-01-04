`ifndef NICE_COMPOSITE_SVH
`define NICE_COMPOSITE_SVH

// Interface Class: patterns::composite
//
// Composite design-pattern.
//
// composite provides an interface for a single composite in a composite,
// and may either be a leaf or an inner-node.
//
// The composite pattern provides a means for composing objects into tree
// structures to represent part-whole hierarchies.
//
// Composite lets clients treat individual objects and compositions of objects
// uniformly.
//
interface class composite
extends iterable#(composite);

    // ---------------------------------------------------------------------------
    // Group: Composite Identifiers
    // ---------------------------------------------------------------------------

    // Function: uid
    //
    // Returns an instance id that is unique accross the instance's type, but
    // that is not universally unique.
    //
    // Such id can then be used to link between different types of nodes in a
    // composite by giving them the same per-type id, yet diffrentiate between
    // them by inspecting their universally unique id.
    //
    pure virtual function int
    uid();

    // Function: uuid
    //
    // Get the composite's Universal-Unique-Identifier.
    //
    pure virtual function int
    uuid();

    // ---------------------------------------------------------------------------
    // Group: Composite Inquiries
    // ---------------------------------------------------------------------------

    // Function: depth
    //
    // Get the depth of the composite relative to the root.
    //
    pure virtual function int
    depth();

    // Function: index
    //
    // Get the index of a composite as a child of its parent.
    //
    pure virtual function int
    index();

    // Function: child_index
    //
    // Get the index of <_child> as a child of the composite in its queue of
    // <children()>.
    //
    // Parameters:
    //  _child - A child of the composite for which a corresponding index should
    //  be returned.
    //
    pure virtual function int
    child_index(composite _child);

    // Function: num_children
    //
    // Get the number of children in the composite's list of <children()>.
    //
    pure virtual function int
    num_children();

    // ---------------------------------------------------------------------------
    // Group: Composite Hierarchey
    // ---------------------------------------------------------------------------
    //
    // The below functions provide the interface to a composite's children
    // hierarchy.
    //
    // The composite interface design assumes user familiarity with the possible
    // types of composite classes, and its implementation should follows the
    // same assumptions.
    //
    // The meaning of this assumption in regard to implementation is that a
    // concrete implementation should only be provided in components of the
    // composite type, and that a call to any of the below methods made on a
    // leaf composite indicates a bug in the logic of the user, and therefore
    // should produce a fatal error.
    //
    // This is a design decision made in order to prefer transparency over type
    // safety, and leave the control in the hands of the user of this API.
    //
    // ---------------------------------------------------------------------------

    // Function: root
    //
    // Get the root of the composite hierarchy.
    //
    pure virtual function composite
    root();

    // Function: parent
    //
    // Get the composite's parent.
    //
    pure virtual function composite
    parent();

    // Function: set_parent
    //
    // Set <_parent> as the parent of this composite.
    //
    // Parameters:
    //  _parent - The parent to set.
    //
    pure virtual function void
    set_parent(composite _parent);

    // Function: child
    //
    // Get the composite's child at the specified <_index>.
    //
    // Parameters:
    //  _index - The index of the child in the composite's list of <children()>.
    //
    pure virtual function composite
    child(int _index);

    // Function: children
    //
    // Get a builtin SystemVerilog queue containing the composite's children in
    // the order they were set/added.
    //
    pure virtual function iterator
    children();

    // Function: add_child
    //
    // Add <_child> to the composite's list of <children()>.
    //
    // Parameters:
    //  _child - The child to be added to the composite's list of <children()>.
    //
    pure virtual function void
    add_child(composite _child);

    // Function: add_children
    //
    // Add <_children> to this composite's queue of <children()>.
    //
    // Parameters:
    //  _children - A queue of children to be added to the back of the
    //  composite's queue of <children()>.
    //
    pure virtual function void
    add_children(iterable _children);

    // Function: remove_child
    //
    // Remove <_child> from this composite's children.
    //
    // Parameters:
    //  _child - The child to remove from the composite's queue of <children()>.
    //
    pure virtual function void
    remove_child(composite _child);

    // Function: remove_child_at
    //
    // Remove the child at the specified <_index> from this composite's
    // children.
    //
    // Paremeters:
    //  _index - The index of the child to be removed from the composite's queue
    //  of <children()>.
    //
    pure virtual function void
    remove_child_at(int _index);

    // Function: remove_children
    //
    // Remove all of the composite's <children()>, making it a leaf node in the
    // hierarchy until new children are added to it.
    //
    pure virtual function void
    remove_children();

    // ---------------------------------------------------------------------------
    // Group: Composite Hierarchy - Iteration Interface
    // ---------------------------------------------------------------------------

    // Function: next_child
    //
    // Iterate over composite's children, setting <_child> to the next child
    // handle of this composite.
    //
    // Returns:
    //  - 1 upon success setting <_child> to the next child in the composite's
    //  <children()> queue.
    //  - 0 upon error, setting _child to null, or reporting a fatal if called
    //  on a leaf composite.
    //
    pure virtual function bit
    next_child(ref composite _child);

    // Function: prev_child
    //
    // Iterate over composite's children, setting <_child> to the previous child
    // handle of this composite.
    //
    // Returns:
    //  - 1 upon success setting <_child> to the previous child in the
    //  composite's <children()> queue.
    //  - 0 upon error, setting _child to null, or reporting a fatal if called
    //  on a leaf composite.
    //
    pure virtual function bit
    prev_child(ref composite _child);

    // Function: first_child
    //
    // Get the first child in the composite's queue of <children()>.
    //
    // Returns:
    //  - A handle to the first child composite upon success.
    //  - A null handle if called on a composite composite which has no
    //  <children()>.
    //  - reports a fatal error if called on a leaf composite (see Group
    //  documentation of the composite Hierarchy Interface).
    //
    pure virtual function composite
    first_child();

    // Function: last_child
    //
    // Get the last child in the composite's queue of <children()>.
    //
    // Returns:
    //  - A handle to the last child composite upon success.
    //  - A null handle if called on a composite composite which has no
    //  <children()>.
    //  - reports a fatal error if called on a leaf composite (see Group
    //  documentation of the composite Hierarchy Interface).
    //
    pure virtual function composite
    last_child();

    // Function: dft_child
    //
    // Get the child of the composite, in Depth-First-Traversal order.
    //
    // Returns:
    //  - A handle to the Depth-First-Traversal ordered child composite upon
    //  success.
    //  - A null handle if called on a composite composite which has no
    //  <children()>.
    //  - reports a fatal error if called on a leaf composite (see Group
    //  documentation of the composite Hierarchy Interface).
    //
    pure virtual function composite
    dft_child();

    // Function: bft_child
    //
    // Get the child of the composite, in Breadth-First-Traversal order.
    //
    // Returns:
    //  - A handle to the Breadth-First-Traversal ordered child composite upon
    //  success.
    //  - A null handle if called on a composite composite which has no
    //  <children()>.
    //  - reports a fatal error if called on a leaf composite (see Group
    //  documentation of the composite Hierarchy Interface).
    //
    pure virtual function composite
    bft_child();

    // ---------------------------------------------------------------------------
    // Group: Ownership Interface
    // ---------------------------------------------------------------------------

    // Function: has_parent
    //
    // Returns 1 if a parent composite is set for the composite, or 0 otherwise.
    //
    pure virtual function bit
    has_parent();

    // Function: has_child
    //
    // Returns 1 if <_child> is a direct child of the composite the method was
    // called on, or 0 otherwise.
    //
    pure virtual function bit
    has_child(composite _child);

    // Function: has_children
    //
    // Returns 1 if this composite has 1 or more children, or 0 otherwise.
    // Note that this *does not* check whether or not a composite can have
    // children, but *only if it has* children.
    //
    pure virtual function bit
    has_children();

    // Function: has_next_child
    //
    // Returns 1 if <_child> is not the last child of the composite this method
    // was called on, or 0 otherwise.
    //
    pure virtual function bit
    has_next_child(ref composite _child);

    // Function: has_prev_child
    //
    // Returns 1 if <_child> is not the first child of the composite this method
    // was called on, or 0 otherwise.
    //
    pure virtual function bit
    has_prev_child(ref composite _child);

    // ---------------------------------------------------------------------------
    // Group: Logical Interface
    // ---------------------------------------------------------------------------

    // Function: is
    //
    // Performs an identity check, returning 1 if <_other> is a handle pointing
    // to this composite, or 0 otherwise.
    //
    pure virtual function bit
    is(composite _other);

    // Function: is_not
    //
    // The negated form if the <is()> identity check method.
    //
    pure virtual function bit
    is_not(composite _other);

    // Function: is_root
    //
    // Returns 1 if the composite is a root composite, or 0 otherwise.
    //
    pure virtual function bit
    is_root();

    // Function: is_leaf
    //
    // Checks if the composite is a composite type composite and returns the
    // result.
    //
    // Returns:
    //  - 1 if the composite is a leaf composite, i.e. a composite which
    //  *can not* have children, and represents a leaf in the composite
    //  hierarchy graph.
    //  - 0 if the former condition does not hold.
    //
    pure virtual function bit
    is_leaf();

    // Function: is_node
    //
    // Checks if the composite is a composite type composite and returns the
    // result.
    //
    // Returns:
    //  - 1 if the composite is an inner node in the composition graph.
    //  - 0 if the former condition does not hold.
    //
    pure virtual function bit
    is_node();

    // Function: is_index_valid
    //
    // Checks if <_index> is a valid index to a child in the composite's queue
    // of <children()>.
    //
    // Returns:
    //  - 1 if <_index> is a valid child index to this composite's <children()>
    //  queue.
    //  - 0 if the former condition does not hold.
    //
    pure virtual function bit
    is_index_valid(int _index);

    // Function: is_parent_of
    //
    // Checks if the composite is a parent of <_child> and returns the result.
    //
    // Returns:
    //  - 1 if the composite is a parent of <_child>.
    //  - 0 if the former condition does not hold.
    //
    // See Also:
    //  <is_child_of()>
    //
    pure virtual function bit
    is_parent_of(composite _child);

    // Function: is_child_of
    //
    // Checks if the composite is a child of <_parent> and returns the result.
    //
    // Returns:
    //  - 1 if the composite is a child of <_parent>.
    //  - 0 if the former condition does not hold.
    //
    // See Also:
    //  <is_parent_of()>
    //
    pure virtual function bit
    is_child_of(composite _parent);

endclass: composite

`endif // NICE_COMPOSITE_SVH
