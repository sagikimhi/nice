//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_uid_object.svh
// Author        : skimhi
// Created       : Wed Oct 2024, 08:14:16
// Last modified : Wed Oct 2024, 08:14:16
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Wed Oct 2024, 08:14:16
//-----------------------------------------------------------------------------

`ifndef NICE_UID_OBJECT_SVH
`define NICE_UID_OBJECT_SVH

// Class: misc::uid_object
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
class uid_object extends sp_base_object;
    `uvm_object_utils_begin(uid_object)
    `uvm_object_utils_end

    // ---------------------------------------------------------------------------
    // Group: Constructor
    // ---------------------------------------------------------------------------

    // Function: new
    //
    // Creates a new <uid_object> instance.
    //
    function new(string name="");
        super.new(name);
        this.m_uid = this.next_uid(name);
    endfunction: new

    // ---------------------------------------------------------------------------
    // Group: UID Interface
    // ---------------------------------------------------------------------------

    // Function: uid
    //
    // Returns the unique identifier value of the <uid_object> instance.
    //
    virtual function int unsigned uid();
        return this.m_uid;
    endfunction: uid

    virtual function void
    reset_uid();
        this.next_name_uid[this.get_name()] = 0;
    endfunction: reset_uid

    // ---------------------------------------------------------------------------
    // Group: Policy Methods
    // ---------------------------------------------------------------------------

    virtual function void
    do_print(uvm_printer printer);
        printer.print_int("uid", this.m_uid, $bits(this.m_uid), UVM_DEC);
    endfunction: do_print

    // ---------------------------------------------------------------------------
    // Internal
    // ---------------------------------------------------------------------------

    // Variable: m_uid
    //
    // The unique identifier value.
    //
    local const int unsigned m_uid;

    // Static Variable: next_name_uid
    //
    // An associative array of integer uids indexed by name strings.
    //
    local static int unsigned next_name_uid[string];

    // Function: next_uid
    //
    // Returns the next unique id value for the specified ~name~ argument.
    //
    protected virtual function int unsigned
    next_uid(string name);
        if (!uid_object::next_name_uid.exists(name))
            uid_object::next_name_uid[name] = 0;
        return uid_object::next_name_uid[name]++;
    endfunction: next_uid

endclass: uid_object

`endif // NICE_UID_OBJECT_SVH
