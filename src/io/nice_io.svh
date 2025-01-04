//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_io.svh
// Author        : skimhi
// Created       : Fri Sep 2024, 14:13:14
// Last modified : Fri Sep 2024, 14:13:14
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Fri Sep 2024, 14:13:14
//-----------------------------------------------------------------------------

`ifndef NICE_IO_SVH
`define NICE_IO_SVH

`include "nice_defines.svh"
`nice_include_dependencies


// Package: io
//
// Provides various facillities for handling I/O.
//
// Interface Classes::
//
// io::stream - Provides a higher level interface to an I/O device.
//
// Concrete Classes::
//
// io::file - Concrete stream class which implements the io::stream interface.
//
// io::file_reader - Utility class for reading through files. requires a rework
// to work together with io::file, TBD.
//
// io::cmd
//
package io;
    `nice_import_dependencies
    `include "io/nice_io_types.svh"

    // ---------------------------------------------------------------------------
    // Group: Enumerations
    // ---------------------------------------------------------------------------

    // Enum: whence_enum
    //
    // An enumeration specifying whence should the seek operation start.
    //
    // In other words, it specifies the starting position of a seek operation to
    // which the offset will be added to determine the final position to seek
    // to.
    //
    // SEEK_SET - sets position equal to offset bytes.
    //
    // SEEK_CUR - sets position to current location plus offset.
    //
    // SEEK_END - sets position to EOF plus offset.
    //
    typedef enum {
        // SEEK_SET: sets position equal to offset bytes.
        //
        SEEK_SET = 0,

        // SEEK_CUR: sets position to current location plus offset.
        //
        SEEK_CUR = 1,

        // SEEK_END: sets position to end of stream plus offset.
        //
        SEEK_END = 2

    } whence_enum;

    // ---------------------------------------------------------------------------
    // Group: Value Parameters
    // ---------------------------------------------------------------------------

    // Constant: EOF
    //
    // End-Of-File indicator.
    //
    parameter int EOF = 32'hffff_ffff;

    // Constant: stdin
    //
    // File descriptor to standard input stream.
    //
    parameter int stdin = 32'h8000_0000;

    // Constant: stdout
    //
    // File descriptor to standard output stream.
    //
    parameter int stdout = 32'h8000_0001;

    // Constant: stderr
    //
    // File descriptor to standard error stream.
    //
    parameter int stderr = 32'h8000_0002;

    // ---------------------------------------------------------------------------
    // Group: Functions
    // ---------------------------------------------------------------------------

    // Function: is_newline
    //
    // returns 1 if byte _b is a newline byte or 0 otherwise.
    //
    function bit
    is_newline(byte _b);
        return _b == "\n" || _b == "\r";
    endfunction: is_newline

    // Function: fopen
    //
    // Open a file device at location _path under the specified _mode
    // permissions.
    //
    function stream
    fopen(string _path, string _mode="r");
        return file::open(_path, _mode);
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Types
    // ---------------------------------------------------------------------------

    // Type: stream
    //
    // Interface class for handling I\O stream devices as high level objects.
    //
    // See <io::stream>.
    //
    `include "io/api/nice_stream.svh"

    // Type: file
    //
    // Concrete <io::stream> class for handling file stream I/O.
    //
    // See following example for basic usage:
    // (start code)
    //  function main();
    //      io::file f;
    //      string content;
    //
    //      f = io::fopen("file.txt", "r");
    //
    //      // Option 1:
    //      content = f.readall();
    //
    //      // Rewind, and parse differently:
    //      f.rewind();
    //
    //      // Option 2:
    //      while (!f.eof()) begin
    //          $display("Reading a line: %s", f.readline());
    //          $display("Querying nof bytes read: %d", f.bytes_read());
    //          $display("Querying nof bytes unread: %d", f.bytes_unread());
    //          // Explore the api for more.
    //      end
    //
    //      // And finally, close it.
    //      f.close();
    //
    //      // You can also use it for writing
    //      f = io::file::open("file.txt", "w");
    //      f.write("This requires adding a newline. \n");
    //      f.writeln("But this does not.");
    //      f.close();
    //
    //  endfunction: main
    // (end)
    //
    `include "io/nice_io_file.svh"

    // Type: cmdline_arg
    //
    // Command-line argument representation as an object.
    //
    // Upon creation, specified constructor name argument is used to parse argv and
    // extract information and values regarding the argument.
    //
    // Basic usage is as follows:
    //
    // (start code)
    //  function void foo();
    //      cmdline_arg#() bar;
    //
    //      // Create an instance which corrosponds to +BAR command-line argument.
    //      bar = cmdline_arg#()::type_id::create("BAR");
    //
    //      // Check whether the argument was passed to run
    //      // command (with or w/o specific value)
    //      if (bar.exists())
    //          this.bazz();
    //
    //      // Check whether a value was specified with the argument
    //      if (bar.value_exists()) begin
    //          this.foo_bar_bazz(
    //              bar.value()
    //          );
    //      end
    //  endfunction: foo
    // (end)
    //
    `include "io/nice_io_cmdline_arg.svh"

    // Type: file_reader
    //
    // Base reader class for reading unformatted data from a file.
    //
    `include "io/nice_io_file_reader.svh"

endpackage: io

`endif // NICE_IO_SVH
