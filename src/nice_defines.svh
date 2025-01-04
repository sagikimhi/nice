//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_defines.svh
// Author        : skimhi
// Created       : Mon Sep 2024, 17:48:17
// Last modified : Mon Sep 2024, 17:48:17
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Mon Sep 2024, 17:48:17
//-----------------------------------------------------------------------------

`ifndef NICE_DEFINES_SVH
`define NICE_DEFINES_SVH

// ---------------------------------------------------------------------------
// UVM Object Macros
// ---------------------------------------------------------------------------

`ifndef nice_object
`define nice_object(obj)  \
    typedef obj this_type; \
    `uvm_object_utils(obj) \
     \
    function new(string name=""); \
        super.new(name); \
        `ifdef nice_init \
        this.init(); \
        `undef nice_init \
        `endif \
    endfunction: new
`endif //nice_object

`ifndef nice_param_object
`define nice_param_object(obj)  \
    typedef obj this_type; \
    `uvm_object_param_utils(obj) \
     \
    function new(string name=""); \
        super.new(name); \
        `ifdef nice_init \
        this.init(); \
        `undef nice_init \
        `endif \
    endfunction: new
`endif //nice_param_object

// ---------------------------------------------------------------------------
// UVM Component Macros
// ---------------------------------------------------------------------------

`ifndef nice_component
`define nice_component(comp)  \
    typedef comp this_type; \
    `uvm_component_utils(comp) \
     \
    function new(string name, uvm_component parent); \
        super.new(name, parent); \
        `ifdef nice_init \
        this.init(); \
        `undef nice_init \
        `endif \
    endfunction: new
`endif //nice_component

`ifndef nice_param_component
`define nice_param_component(comp)  \
    typedef comp this_type; \
    `uvm_component_param_utils(comp) \
     \
    function new(string name, uvm_component parent); \
        super.new(name, parent); \
        `ifdef nice_init \
        this.init(); \
        `undef nice_init \
        `endif \
    endfunction: new
`endif //nice_param_component

// ---------------------------------------------------------------------------
// Group: UID Macros
// ---------------------------------------------------------------------------

`ifndef nice_uid_object_field
    `define nice_uid_object_field \
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
        endfunction: init_uid \
        \
        virtual function int \
        uid(); \
            if (this.m_uid == null) \
                this.init_uid(); \
            return this.m_uid.uid(); \
        endfunction: uid
`endif // nice_uid_object_field


// ---------------------------------------------------------------------------
// Group: Report Macros
// ---------------------------------------------------------------------------

// Macro: nice_check
//
// Evaluates CONDITION as an expression and reports a uvm_error if the
// expression evaluates to false/0, similar to an assertion, but uses uvm
// reporting mechanism instead of the standard builtin assertion error.
//
 `ifndef nice_check
    `define nice_check(condition) \
        if (!(condition)) begin \
            `nice_error(("Check failed: %s", `"``condition`")) \
        end
`endif

// Macro: nice_ensure
//
// Evaluates CONDITION as an expression and reports a uvm_fatal if the
// expression evaluates to false/0, similar to an assertion, but uses uvm
// reporting mechanism instead of the standard builtin assertion error.
//
 `ifndef nice_ensure
    `define nice_ensure(condition) \
        if (!(condition)) begin \
            `nice_ftl(("Check failed: %s", `"``condition`")) \
        end
`endif

// Macro: nice_error
//
// Formats sformatf_msg with $sformatf and reports it as uvm error using `sp_err macro
// invocation.
//
`ifndef nice_error
    `define nice_error(sformatf_msg) \
        `sp_err($sformatf``sformatf_msg)
`endif //nice_error

// Macro: nice_ftl
//
// Formats sformatf_msg with $sformatf and reports it as uvm fatal using `sp_ftl macro
// invocation.
//
`ifndef nice_ftl
    `define nice_ftl(sformatf_msg) \
        `sp_ftl($sformatf``sformatf_msg)
`endif //nice_ftl

// Macro: nice_print
//
// Formats sformatf_msg with $sformatf and reports it as uvm print using `sp_print macro
// invocation (uses UVM_print verbosity).
//
`ifndef nice_print
    `define nice_print(sformatf_msg) \
        `sp_print($sformatf``sformatf_msg)
`endif //nice_print

// Macro: nice_info
//
// Formats sformatf_msg with $sformatf and reports it as uvm info using `sp_info macro
// invocation (uses UVM_INFO verbosity).
//
`ifndef nice_info
    `define nice_info(sformatf_msg) \
        `sp_info($sformatf``sformatf_msg)
`endif //nice_info

// Macro: nice_debug
//
// Formats sformatf_msg with $sformatf and reports it as uvm debug info using `sp_debug
// macro invocation (uses UVM_DEBUG verbosity).
//
`ifndef nice_debug
    `define nice_debug(sformatf_msg) \
        `sp_debug($sformatf``sformatf_msg)
`endif //nice_debug

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
//  2.  Define (literal `define) an operation that receives another macro as
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
//  `define my_x_macro(operation)  \
//      operation(foo) \
//      operation(bar) \
//      operation(bazz)
//
//  // Step 3 - Define the operation, for this example, we will define a
//  // simple macro that declares an extern function that returns void.
//
//  `define internal_fn_declaration(fn_name, fn_type=void) \
//      `ifdef fn_name``_args \
//          extern function fn_type fn_name(`fn_name``_args); \
//          `undef fn_name``_args \
//      `else \
//          extern function fn_type fn_name(); \
//      `endif
//
//  // Step 4 - Define a macro to invoke the X macro with the appropriate
//  // operation passed as argument.
//
//  `define internal_fn_declarations  \
//      `my_x_macro(`internal_fn_declaration)
//
//  // Step 5 - Use Macro from step 4
//
//  `define bazz_args  \
//      int foo, string bar
//
//  class foo_bar_bazz extends uvm_object;
//
//      // User API Code
//      ...
//
//      // Insert internal declarations with x_macro
//
//      `internal_fn_declarations
//
//  endclass: foo_bar_bazz
//
// (end)
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// X-Macro Defines
// ---------------------------------------------------------------------------

// Macro: nice_x
//
// An X-Macro to run an operation against all sub-package namespaces of
// nice_pkg
//
`ifndef nice_x
`define nice_x(operation)  \
    ```operation(api) \
    ```operation(collections) \
    ```operation(components) \
    ```operation(iterators) \
    ```operation(proxies) \
    ```operation(seq) \
    ```operation(io)
`endif //nice_x

// ---------------------------------------------------------------------------
// Internal
// ---------------------------------------------------------------------------

`ifndef nice_namespace
    `define nice_namespace(namespace)  \
        nice_pkg_``namespace
`endif //nice_namespace

`ifndef nice_import_namespace
    `define nice_import_namespace(namespace)  \
        import nice_pkg_``namespace::*;
`endif //nice_import_namespace

`ifndef nice_export_namespace
    `define nice_export_namespace(namespace)  \
        export nice_pkg_``namespace::*;
`endif //nice_export_namespace

`ifndef nice_include_namespace
    `define nice_include_namespace(namespace)  \
        `include `"namespace/nice_``namespace.svh`"
`endif //nice_include_namespace

`ifndef nice_define_namespace
    `define nice_define_namespace(namespace)  \
        `ifndef namespace \
            `define namespace nice_pkg_``namespace \
        `endif
`endif //nice_define_namespace

`ifndef nice_undefine_namespace
    `define nice_undefine_namespace(namespace)  \
        `ifdef namespace \
            `undef namespace \
        `endif
`endif //nice_undefine_namespace

`ifndef nice_import_namespaces
`define nice_import_namespaces  \
    `nice_x(nice_import_namespace)
`endif //nice_import_namespaces

`ifndef nice_export_namespaces
`define nice_export_namespaces  \
    `nice_x(nice_export_namespace)
`endif //nice_export_namespaces

`ifndef nice_include_namespaces
`define nice_include_namespaces  \
    `nice_x(nice_include_namespace)
`endif //nice_include_namespaces

`ifndef nice_define_namespaces
`define nice_define_namespaces  \
    `nice_x(nice_define_namespace)
`endif //nice_define_namespaces

`ifndef nice_undefine_namespaces
`define nice_undefine_namespaces  \
    `nice_x(nice_undefine_namespace)
`endif //nice_undefine_namespaces

`ifndef nice_begin_namespace
    `define nice_begin_namespace  \
        `nice_define_namespaces
        // `nice_define_api_namespaces
`endif //nice_begin_namespace

`ifndef nice_end_namespace
    `define nice_end_namespace  \
        `nice_undefine_namespaces
        // `nice_undefine_api_namespaces \
`endif //nice_end_namespace

`ifndef nice_include_dependencies
    `define nice_include_dependencies  \
        `include "uvm_macros.svh" \
        `include "verif_common_defines.svh"
`endif // nice_include_dependencies

`ifndef nice_import_dependencies
    `define nice_import_dependencies  \
        import uvm_pkg::*; \
        import verif_common_pkg::*; \
        import sp_base_classes_pkg::*;
`endif // nice_import_dependencies

`endif // NICE_DEFINES_SVH
