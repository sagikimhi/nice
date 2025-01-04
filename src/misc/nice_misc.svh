//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_misc.svh
// Author        : skimhi
// Created       : Wed Oct 2024, 08:13:58
// Last modified : Wed Oct 2024, 08:13:58
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Wed Oct 2024, 08:13:58
//-----------------------------------------------------------------------------

`ifndef NICE_MISC_SVH
`define NICE_MISC_SVH

`include "nice_defines.svh"
`nice_include_dependencies

// Package: misc
//
// A collection of miscellaneous utility classes.
//
package misc;
    `nice_import_dependencies

    // ---------------------------------------------------------------------------
    // Group: Utility Classes
    // ---------------------------------------------------------------------------

    // Type: uid_object
    //
    // A simple class for assigning unique identifier sequences to named objects.
    //
    // Each unique name (most usually an instantiating class's ~type_name~) is
    // assigned with a seperate incremental unique-id value counting up from 0.
    //
    // Simply add a <uid_object> member variable and create it in the constructor
    // using the object's <type_name> in the constructor's ~name~ argument.
    //
    // By doing so, each new instance of an object will be automatically assigned
    // with its own incremental unique instance id (see example below).
    //
    //(start code)
    //
    //  class some_object extends uvm_object;
    //      // The uvm_object_utils macro provides the "get_type_name()" method which
    //      // can be used from a base class to assign each subclass its own unique id
    //      // sequence for its instances (see constructor implementation).
    //      `uvm_object_utils(some_object)
    //
    //      // Unique-ID Handle
    //      local uid_object m_uid;
    //
    //      // Other member declarations
    //      ...
    //
    //      // Function: new
    //      //
    //      // Creates a new "some_object" class instance.
    //      //
    //      function new(string name="");
    //          // Standard call to super constructor
    //          super.new(name);
    //
    //          // Create the unique id instance, a unique id is set automatically.
    //          this.m_uid = uid_object::type_id::create(this.get_type_name());
    //
    //          // Do more constructor stuff
    //          ...
    //      endfunction: new
    //
    //      // Function: uid
    //      //
    //      // Returns the unique identifier of the instance.
    //      //
    //      virtual function int unsigned uid();
    //          // Simply delegate the method call to the unique id instance.
    //          return this.m_uid.uid();
    //      endfunction: uid
    //  endclass: some_object
    //(end)
    //
    typedef class uid_object;
    `include "misc/nice_uid_object.svh"

endpackage: misc

`endif // NICE_MISC_SVH
