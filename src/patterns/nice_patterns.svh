`ifndef NICE_PATTERNS_SVH
`define NICE_PATTERNS_SVH

`include "nice_defines.svh"
`NICE_INCLUDE_DEPENDENCIES

// Package: patterns
//
// A collection of classes, virtual classes, and interface classes that
// allow programmers to easily implement common design patterns such as
// builder, composite, iterator, visitor, etc.
//
package patterns;
    import misc::uid_object;
    `NICE_IMPORT_DEPENDENCIES
    `include "patterns/nice_patterns_typedefs.svh"

    // ---------------------------------------------------------------------------
    // Group: Interface Classes
    // ---------------------------------------------------------------------------

    // Type: iterable
    //
    // Iterator design-pattern.
    //
    // An object capable of returning its members one at a time.
    //
    `include "patterns/api/nice_iterable.svh"

    // Type: iterator
    //
    // Iterator design-pattern.
    //
    // Defines an inerface for iterating over containers.
    //
    `include "patterns/api/nice_iterator.svh"

    // Type: composite
    //
    // Composite design-pattern.
    //
    // composite provides an interface for a single composite in a composition,
    // and may either be a leaf or an inner-node.
    //
    // The composite pattern provides a means for composing objects into tree
    // structures to represent part-whole hierarchies.
    //
    // Composite lets clients treat individual objects and compositions of objects
    // uniformly.
    //
    `include "patterns/api/nice_composition.svh"

    // ---------------------------------------------------------------------------
    // Group: Concrete Iterator Classes
    // ---------------------------------------------------------------------------

    // Type: enum_iterator
    //
    // Concrete <patterns::iterator> class.
    //
    // A concrete <patterns::iterator> class for iterating over members of an
    // enumerations.
    //
    `include "patterns/iterators/nice_enum_iterator.svh"

    // Type: composite_iterator
    //
    // A concrete <patterns::iterator> class for iterating over child components in a
    // composition.
    //
    `include "patterns/iterators/nice_composition_iterator.svh"

    // ---------------------------------------------------------------------------
    // Group: Concrete Composite Classes
    // ---------------------------------------------------------------------------

    // Type: composition_leaf
    //
    // TBD.
    //
    `include "patterns/composite/nice_patterns_composition_leaf_adapter.svh"

    // Type: composition_node
    //
    // TBD.
    //
    `include "patterns/composite/nice_patterns_composition_node_adapter.svh"

    // ---------------------------------------------------------------------------
    // Group: Proxy Classes
    // ---------------------------------------------------------------------------

    // Type: singleton_proxy
    //
    // Concrete proxy class.
    //
    // A proxy to easily make singleton classes, that can also be instantiated
    // as a normal class.
    //
    // The instance is created only once on the first call to
    // <singleton_proxy::get()> and is then set to the local static ~m_inst~
    // variable to retreieve the same instance on subsequent calls.
    //
    // Usage is super simple, see the following example.
    //
    //| // To use the singleton proxy, simply add a typedef to your class as shown
    //| // below:
    //| class myclass extends some_uvm_class;
    //|     typedef singleton_proxy#(myclass) singleton;
    //|     ...
    //| endclass: myclass
    //|
    //| // Then to use it from a different class all you need to do is:
    //| class some_other_class extends uvm_object;
    //|     virtual function void foo();
    //|         // Get the singleton instance
    //|         myclass singleton_inst = myclass::singleton::get();
    //|         ...
    //|     endfunction: foo
    //|
    //|     // Alternatively use both singleton and normal instance
    //|     // if you need to keep track of a global state and a seperate
    //|     // local state for example.
    //|     virtual function void bar();
    //|         // Create a normal instance.
    //|         myclass normal_inst = myclass::type_id::get();
    //|         // Get the global singleton instance.
    //|         myclass singleton_inst = myclass::singleton::get();
    //|         ...
    //|     endfunction: bar
    //| endclass: some_other_class
    //
    `include "patterns/proxies/nice_singleton_proxy.svh"

endpackage: patterns

`endif // NICE_PATTERNS_SVH
