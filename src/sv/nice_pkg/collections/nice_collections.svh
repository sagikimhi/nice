`ifndef NICE_COLLECTIONS_SVH
`define NICE_COLLECTIONS_SVH

`include "nice_defines.svh"
`NICE_INCLUDE_DEPENDENCIES

// Package: annotations
//
// A collection of interfaces that can be used to annotate classes that
// adhere to, require, or provide a result, that is of a particualr
// interface and provide a defined functionallity, regardless and
// independent of the type actual type and/or any base types that it
// extends.
//
// This is useful as it is possible for any class to implement multiple
// interface classes, to use them for declaring variables, and specifying
// arguments or return types, regardless of inheritence and indepentedent of
// the type, allowing the programmer to use a single common interface to
// make requests to multiple unrelated class objects, and alternate between
// them via casting, without the requirement of a common base class.
//
package annotations;
    `NICE_IMPORT_DEPENDENCIES
    import patterns::*;

    // Type: Iterable
    //
    // An annotation for sequence container types.
    //
    // Annotates an object capable of returning its members one at a time.
    //
    // Implementations must define the <iter()> method.
    //
    // See Also:
    //
    // <patterns::iterable> - Iterable interface class definition
    //
    export patterns::iterable;

    // Type: iterator
    //
    // An object representing a stream of data.
    //
    // Repeated calls to the iterator's <next()> method return successive items in
    // the stream.
    //
    // When no more data items are available null is returned instead.
    //
    // At this point, the iterator object is exhausted and any further calls to
    // <next()> simply return null again.
    //
    // Iterators are required to have an <iter()> method that returns the iterator
    // object itself so every iterator is also iterable and may be used in most
    // places where other iterables are accepted.
    //
    // One notable exception is code which attempts multiple iteration passes.
    //
    // A container object produces a fresh new iterator each time you pass it to the
    // <iter()> function.
    //
    // Attempting this with an iterator will just return the same exhausted iterator
    // object used in the previous iteration pass, making it appear like an empty
    // container.
    //
    // Implementations must define the <iter()> and <next()> method.
    //
    // See Also:
    //
    // <patterns::iterator> - Iterator interface class definition
    //
    export patterns::iterator;

    // Type: sized
    //
    // An annotation for container types.
    //
    // Implementations must define the <size()> method.
    //
    typedef interface class sized;

    // Type: hashable
    //
    // An annotation for associative container types.
    //
    // Implementations must define the <hash()> method.
    //
    typedef interface class hashable;

    // Type: container
    //
    // An annotation for container types.
    //
    // Implementations must define the <contains()> method.
    //
    typedef interface class container;

    // Type: sequential
    //
    // An annotation for sequential container types.
    //
    // A sequential container is an <iterable> which supports efficient element
    // access using integer indices via the <get()> method.
    //
    typedef interface class sequential;

    `include "collections/api/nice_annotations.svh"
endpackage: annotations


// Package: collections
//
// A collection of abstract and concrete container classes, that allow
// programmers to easily implement and use common container data structures
// like queues, lists and stacks.
//
// The package defines three main types of container classes.
//
// Collection - A collection is simply any class that implements the iterable,
// sized, container interfaces
//
// Unordered Collections - An <unordered_collection> is an interface for an
// unordered associative <collection> which implement unsorted (hashed) data
// structures that can be quickly searched.
//
// Concrete Unordered Collections:
//
// - set (WIP).
//
// - map (TBD).
//
// Sequential Collections - A <sequential_collection> is an abstract class for
// iterable, sized, container classes,
// also known as <collection> classes, which support efficient access using
// indices via the get() method.
//
// Concrete Sequential Collections:
//
// - <deque>
//
// - list (TBD).
//
// - buffer (TBD).
//
// See Also:
// Annotations - The <annotations> package defines the collections interfaces
// <annotations::sized>, <annotations::container>, <annotations::sequential>,
// <annotations::hashable>.
//
// Patterns - The <patterns> package defines the <patterns::iterable>
// and <patterns::iterator> classes exported by the annotations package.
//
package collections;
    `NICE_IMPORT_DEPENDENCIES

    // ---------------------------------------------------------------------------
    // Group: Sub Packages
    // ---------------------------------------------------------------------------
    //
    // - <annotations> - A collection of interface classes used to annotate
    // interface and concrete collection classes.
    //
    // ---------------------------------------------------------------------------

    import annotations::*;
    export annotations::*;

    // ---------------------------------------------------------------------------
    // Group: Interface Classes
    // ---------------------------------------------------------------------------

    // Type: collection
    //
    // A collection is a <sized> <iterable> <container> that stores objects of the
    // same type in a linear arrangement.
    //
    typedef interface class collection;

    // Type: unordered_collection
    //
    // An <unordered_collection> is an interface for an unordered associative
    // <collection> which implement unsorted (hashed) data structures that can be
    // quickly searched.
    //
    typedef interface class unordered_collection;

    // Type: sequential_collection
    //
    // A <collection> which supports efficient element access using integer indices
    // via the <get()> method and defines a <size()> method that returns the length
    // of the sequence.
    //
    typedef interface class sequential_collection;

    // Type: unordered_set
    //
    // An <unordered_collection> interface extension that defines the
    // interface of <set> classes.
    //
    typedef interface class unordered_set;

    // ---------------------------------------------------------------------------
    // Group: Concrete Classes
    // ---------------------------------------------------------------------------

    // Type: set
    //
    // WIP - Should not be used yet unless you'd like to contribute to the
    // code.
    //
    typedef class set;

    // Type: buffer
    //
    // WIP - Should not be used yet unless you'd like to contribute to the
    // code.
    //
    typedef class buffer;

    // Type: deque
    //
    // An impelmentation of a deque, similar to <uvm_pkg::uvm_queue> but
    // with a wider and richer interface and some additional utilities such as
    // iterators.
    //
    // Note: initial implementation version - non-interface defined methods may
    // be due to change and may still have issues I have not yet encounterd. In
    // such case, please open a jira if an issue is found. Your help is
    // appreciated. So are contributions to the codebase.
    //
    typedef class deque;

    // Type: sequential_iterator
    //
    // A generic iterator class for iterating over <sequential_collection>
    // classes.
    //
    typedef class sequential_iterator;

    `include "collections/api/nice_collection.svh"
    `include "collections/api/nice_unordered_collection.svh"
    `include "collections/api/nice_sequential_collection.svh"
    `include "collections/api/nice_unordered_set.svh"

    `include "collections/nice_set.svh"
    `include "collections/nice_deque.svh"
    `include "collections/nice_buffer.svh"
    `include "collections/nice_sequential_iterator.svh"
endpackage: collections

`endif // NICE_COLLECTIONS_SVH
