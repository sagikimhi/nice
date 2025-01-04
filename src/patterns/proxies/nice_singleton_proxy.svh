//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_singleton_proxy.svh
// Author        : skimhi
// Created       : Wed Sep 2024, 18:44:06
// Last modified : Wed Sep 2024, 18:44:06
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Wed Sep 2024, 18:44:06
//-----------------------------------------------------------------------------

`ifndef NICE_SINGLETON_PROXY_SVH
`define NICE_SINGLETON_PROXY_SVH

// Class: patterns::singleton_proxy
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
class singleton_proxy#(type T=uvm_object);
    local static T m_inst;

    static function T get();
        if (m_inst == null)
            m_inst = new();
        return m_inst;
    endfunction: get
endclass: singleton_proxy


`endif // NICE_SINGLETON_PROXY_SVH
