`ifndef NICE_PKG_SV
`define NICE_PKG_SV

`timescale 1ns / 1ns

`include "uvm_macros.svh"
`include "nice_defines.svh"
`NICE_INCLUDE_DEPENDENCIES
`include "io/nice_io.svh"
`include "seq/nice_seq.svh"
`include "misc/nice_misc.svh"
`include "patterns/nice_patterns.svh"
`include "components/nice_components.svh"
`include "collections/nice_collections.svh"

// Package: nice_pkg
//
// Groups together a wide range of common utility classes, uvm_objects,
// uvm_components, etc. and exports them as seperate namespaces.
//
package nice_pkg;
    `NICE_IMPORT_DEPENDENCIES

    import io::*;
    export io::EOF;
    export io::file;
    export io::fopen;
    export io::STDIN;
    export io::STDOUT;
    export io::STDERR;
    export io::stream;
    export io::is_newline;
    export io::whence_enum;
    export io::cmdline_arg;
    export io::file_reader;
    export io::reader_config;
    export io::int_cmdline_arg;
    export io::string_cmdline_arg;

    import seq::*;
    export seq::chained_sequencer;
    export seq::chaining_sequence;

    import misc::*;
    export misc::uid_object;

    import patterns::*;
    export patterns::iterable;
    export patterns::iterator;
    export patterns::composite;
    export patterns::enum_iterator;
    export patterns::singleton_proxy;
    export patterns::composition_leaf;
    export patterns::composition_node;
    export patterns::composition_iterator;

    import components::*;
    export components::broadcaster;

    import annotations::*;
    export annotations::sized;
    export annotations::hashable;
    export annotations::container;
    export annotations::sequential;

    import collections::*;
    export collections::deque;
    export collections::collection;
    export collections::unordered_set;
    export collections::sequential_iterator;
    export collections::unordered_collection;
    export collections::sequential_collection;

endpackage: nice_pkg

`endif // NICE_PKG_SV
