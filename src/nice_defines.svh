`ifndef NICE_DEFINES_SVH
`define NICE_DEFINES_SVH

// ---------------------------------------------------------------------------
// UVM Object Macros
// ---------------------------------------------------------------------------

`ifndef nice_object_utils
`define nice_object_utils(OBJ)  \
    typedef OBJ this_type; \
    `uvm_object_utils(OBJ) \
     \
    function new(string name=""); \
        super.new(name); \
        `ifdef nice_init_cb \
        this.init(); \
        `undef nice_init_cb \
        `endif \
    endfunction: new
`endif  //nice_object_utils

`ifndef nice_param_object_utils
`define nice_param_object_utils(OBJ)  \
    typedef OBJ this_type; \
    `uvm_object_param_utils(OBJ) \
     \
    function new(string name=""); \
        super.new(name); \
        `ifdef nice_init_cb \
        this.init(); \
        `undef nice_init_cb \
        `endif \
    endfunction: new
`endif  //nice_param_object_utils

// ---------------------------------------------------------------------------
// UVM Component Macros
// ---------------------------------------------------------------------------

`ifndef nice_component_utils
`define nice_component_utils(COMP)  \
    typedef COMP this_type; \
    `uvm_component_utils(COMP) \
     \
    function new(string name, uvm_component parent); \
        super.new(name, parent); \
        `ifdef nice_init_cb \
        this.init(); \
        `undef nice_init_cb \
        `endif \
    endfunction: new
`endif  //nice_component_utils

`ifndef nice_param_component_utils
`define nice_param_component_utils(COMP)  \
    typedef COMP this_type; \
    `uvm_component_param_utils(COMP) \
     \
    function new(string name, uvm_component parent); \
        super.new(name, parent); \
        `ifdef nice_init_cb \
        this.init(); \
        `undef nice_init_cb \
        `endif \
    endfunction
`endif  //nice_param_component_utils

// ---------------------------------------------------------------------------
// Group: UID Macros
// ---------------------------------------------------------------------------

`ifndef nice_uid_field_util
`define nice_uid_field_util \
        local uid_object m_uid; \
        \
        virtual function void \
        init_uid(); \
            string uid_name = this.get_name(); \
            \
            if (uid_name == "") \
                uid_name = this.get_type_name(); \
            else if (uid_name != type_name) \
                uid_name = {this.get_type_name(), "::", uid_name}; \
            \
            this.m_uid = uid_object::type_id::create(uid_name); \
        endfunction
`endif  // nice_uid_field_util


// ---------------------------------------------------------------------------
// Group: Report Macros
// ---------------------------------------------------------------------------

// Macro: NICE_CHECK
//
// Evaluates CONDITION as an expression and reports a uvm_error if the
// expression evaluates to false/0, similar to an assertion, but uses uvm
// reporting mechanism instead of the standard builtin assertion error.
//
`ifndef NICE_CHECK
`define NICE_CHECK(CONDITION) \
        if (!(CONDITION)) begin \
            `NICE_ERROR(("CHECK FAILED: %S", `"``CONDITION`")) \
        end
`endif  //NICE_CHECK

// Macro: NICE_ENSURE
//
// Evaluates CONDITION as an expression and reports a uvm_fatal if the
// expression evaluates to false/0, similar to an assertion, but uses uvm
// reporting mechanism instead of the standard builtin assertion error.
//
`ifndef NICE_ENSURE
`define NICE_ENSURE(CONDITION) \
        if (!(CONDITION)) begin \
            `NICE_FTL(("CHECK FAILED: %S", `"``CONDITION`")) \
        end
`endif  //NICE_ENSURE

// Macro: NICE_ERROR
//
// formats SFORMATF_MSG with $sformatf and reports it via `uvm_error macro.
//
`ifndef NICE_ERROR
`define NICE_ERROR(SFORMATF_MSG) \
        begin \
            `uvm_error(this.get_name(), $sformatf``SFORMATF_MSG) \
        end
`endif  //NICE_ERROR

// Macro: NICE_FTL
//
// formats SFORMATF_MSG with $sformatf and reports it via `uvm_fatal macro.
//
`ifndef NICE_FTL
`define NICE_FTL(SFORMATF_MSG) \
        begin \
            `uvm_fatal(this.get_name(), $sformatf``SFORMATF_MSG) \
        end
`endif  //NICE_FTL

// Macro: NICE_PRINT
//
// formats SFORMATF_MSG with $sformatf and reports it via `uvm_info macro with
// verbosity set to UVM_MEDIUM.
//
`ifndef NICE_PRINT
`define NICE_PRINT(SFORMATF_MSG) \
        begin \
            `uvm_info(this.get_name(), $sformatf``SFORMATF_MSG, UVM_LOW) \
        end
`endif  //NICE_PRINT

// Macro: NICE_INFO
//
// formats SFORMATF_MSG with $sformatf and reports it via `uvm_info macro with
// verbosity set to UVM_MEDIUM.
//
`ifndef NICE_INFO
`define NICE_INFO(SFORMATF_MSG) \
        begin \
            `uvm_info(this.get_name(), $sformatf``SFORMATF_MSG, UVM_MEDIUM) \
        end
`endif  //NICE_INFO

// Macro: NICE_DEBUG
//
// formats SFORMATF_MSG with $sformatf and reports it via `uvm_info macro with
// verbosity set to UVM_DEBUG.
//
`ifndef NICE_DEBUG
`define NICE_DEBUG(SFORMATF_MSG) \
    begin \
        `uvm_info(this.get_name(), $sformatf``SFORMATF_MSG, UVM_DEBUG) \
    end
`endif  //NICE_DEBUG

// ---------------------------------------------------------------------------
// Group: X-Macros
// ---------------------------------------------------------------------------
//
// For the X-Macro newcomer::
// --------------------------
//
//  Simply put, X-Macros is a shorthand for "Execute-Macro", and thats exactly
//  what it does. It provides a mean for executing a user-defined operation on
//  a pre-defined set of "things".
//
//  In other words, instead of defining an operation to run against an argument
//  passed by the user, it defines arguments, on which it will perform an
//  operation passed as an argument by the user.
//
//  Below is an explanation and walkthrough on the process of defining your own
//  X-Macro, followed by a code snippet example:
//
//  1.  Define (In your mind) a group of "things" on which you want to
//      perform various operations.
//
//  2.  define (LITERAL `define) AN OPERATION THAT RECEIVES ANOTHER Macro AS
//      an argument.
//
//      For each "thing" in the group of "things" from step one, invoke the
//      operation passed as argument on the "thing".
//
//  3.  Define one or more macros for every operation you would like to perform
//      on the group of "things" from step one.
//
//      For example, a macro that declares its argument as a constant string, or
//      a macro which declares an enum field with a specific prefix.
//
//  4.  Define a macro for each operation to invoke the X-Macro and pass the
//      operation as argument.
//
//  5.  Use the macro defined in step 4.
//
//
// Example - Defining an x-macro to run a user-defined operation against "foo",
// "bar", and "bazz".
// (start code)
//
//  // Steps 1 + 2 - Define x-macro to run "operation" against "foo", "bar",
//  // and "bazz".
//
//  `define MY_X_MACRO(OPERATION)  \
//      operation(foo) \
//      operation(bar) \
//      operation(bazz)
//
//  // Step 3 - Define the operation, for this example, we will define a
//  // simple macro that declares an extern function that returns void.
//
//  `define INTERNAL_FN_DECLARATION(FN_NAME, FN_TYPE=VOID) \
//      `ifdef FN_NAME``_ARGS \
//          EXTERN FUNCTION FN_TYPE FN_NAME(`FN_NAME``_ARGS); \
//          `undef FN_NAME``_ARGS \
//      `ELSE \
//          extern function fn_type fn_name(); \
//      `endif
//
//  // Step 4 - Define a macro to invoke the X macro with the appropriate
//  // operation passed as argument.
//
//  `define INTERNAL_FN_DECLARATIONS  \
//      `MY_X_MACRO(`INTERNAL_FN_DECLARATION)
//
//  // Step 5 - Use Macro from step 4
//
//  `define BAZZ_ARGS  \
//      int foo, string bar
//
//  class foo_bar_bazz extends uvm_object;
//
//      // User API Code
//      ...
//
//      // Insert internal declarations with x_macro
//
//      `INTERNAL_FN_DECLARATIONS
//
//  endclass: foo_bar_bazz
//
// (end)
//
// ---------------------------------------------------------------------------

// Macro: NICE_X
//
// An X-Macro to run an operation against all sub-package namespaces of
// nice_pkg
//
`ifndef NICE_X
`define NICE_X(OPERATION)  \
    `OPERATION(io) \
    `OPERATION(seq) \
    `OPERATION(misc) \
    `OPERATION(patterns) \
    `OPERATION(components) \
    `OPERATION(collections)
`endif  //NICE_X

`ifndef NICE_NAMESPACE
`define NICE_NAMESPACE(NAMESPACE) \
        NICE_PKG_``NAMESPACE
`endif  //NICE_NAMESPACE

`ifndef NICE_IMPORT_NAMESPACE
`define NICE_IMPORT_NAMESPACE(NAMESPACE) \
        import nice``NAMESPACE``_pkg::*;
`endif  //NICE_IMPORT_NAMESPACE

`ifndef NICE_EXPORT_NAMESPACE
`define NICE_EXPORT_NAMESPACE(NAMESPACE) \
        export nice_``NAMESPACE``_pkg::*;
`endif  //NICE_EXPORT_NAMESPACE

`ifndef NICE_INCLUDE_NAMESPACE
`define NICE_INCLUDE_NAMESPACE(NAMESPACE) \
        `include "``NAMESPACE/NICE_``NAMESPACE.SVH"
`endif  //NICE_INCLUDE_NAMESPACE

`ifndef NICE_DEFINE_NAMESPACE
`define NICE_DEFINE_NAMESPACE(NAMESPACE) \
        `ifndef NAMESPACE \
            `define NAMESPACE nice``NAMESPACE``_pkg \
        `endif
`endif  //NICE_DEFINE_NAMESPACE

`ifndef NICE_UNDEFINE_NAMESPACE
`define NICE_UNDEFINE_NAMESPACE(NAMESPACE) \
        `ifdef NAMESPACE \
            `undef NAMESPACE \
        `endif
`endif  //NICE_UNDEFINE_NAMESPACE

`ifndef NICE_IMPORT_NAMESPACES
`define NICE_IMPORT_NAMESPACES `NICE_X(NICE_IMPORT_NAMESPACE)
`endif  //NICE_IMPORT_NAMESPACES

`ifndef NICE_EXPORT_NAMESPACES
`define NICE_EXPORT_NAMESPACES `NICE_X(NICE_EXPORT_NAMESPACE)
`endif  //NICE_EXPORT_NAMESPACES

`ifndef NICE_INCLUDE_NAMESPACES
`define NICE_INCLUDE_NAMESPACES `NICE_X(NICE_INCLUDE_NAMESPACE)
`endif  //NICE_INCLUDE_NAMESPACES

`ifndef NICE_DEFINE_NAMESPACES
`define NICE_DEFINE_NAMESPACES `NICE_X(NICE_DEFINE_NAMESPACE)
`endif  //NICE_DEFINE_NAMESPACES

`ifndef NICE_UNDEFINE_NAMESPACES
`define NICE_UNDEFINE_NAMESPACES `NICE_X(NICE_UNDEFINE_NAMESPACE)
`endif  //NICE_UNDEFINE_NAMESPACES

`ifndef NICE_BEGIN_NAMESPACE
`define NICE_BEGIN_NAMESPACE `NICE_DEFINE_NAMESPACES
`endif  //NICE_BEGIN_NAMESPACE

`ifndef NICE_END_NAMESPACE
`define NICE_END_NAMESPACE `NICE_UNDEFINE_NAMESPACES
`endif  //NICE_END_NAMESPACE

`ifndef NICE_INCLUDE_DEPENDENCIES
`define NICE_INCLUDE_DEPENDENCIES \
        `include "uvm_macros.svh"
`endif  //NICE_INCLUDE_DEPENDENCIES

`ifndef NICE_IMPORT_DEPENDENCIES
`define NICE_IMPORT_DEPENDENCIES \
        import uvm_pkg::*;
`endif  //NICE_IMPORT_DEPENDENCIES

`endif  //NICE_DEFINES_SVH
