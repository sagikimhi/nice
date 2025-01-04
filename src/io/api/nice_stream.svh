//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_io_stream.svh
// Author        : skimhi
// Created       : Sat Sep 2024, 13:53:39
// Last modified : Sat Sep 2024, 13:53:39
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Sat Sep 2024, 13:53:39
//-----------------------------------------------------------------------------

`ifndef NICE_IO_STREAM_SVH
`define NICE_IO_STREAM_SVH

// Interface Class: io::stream
//
// Provides a higher level interface to an I/O stream device.
//
interface class stream;
    // ---------------------------------------------------------------------------
    // Group: Closing and flushing
    // ---------------------------------------------------------------------------

    // Function: close
    //
    // Flush and close the stream.
    //
    // If the stream is already closed, this method silently returns.
    //
    // Once a stream is closed, any read/write operation on the stream is will
    // result in a fatal error.
    //
    pure virtual function void
    close();

    // Function: flush
    //
    // Flush the write buffers of the stream if such exist.
    //
    // This method does nothing for read-only streams.
    //
    pure virtual function void
    flush();

    // Function: closed
    //
    // Returns 1 if the stream is closed, or 0 otherwise.
    //
    pure virtual function bit
    closed();

    // ---------------------------------------------------------------------------
    // Group: Positioning
    // ---------------------------------------------------------------------------

    // Function: position
    //
    // Returns the current stream position.
    //
    pure virtual function int
    tell();

    // Function: seek
    //
    // seek to a new position in stream.
    //
    // offset specifies the number of bytes to seek from a given position.
    //
    // whence is an optional argument that defaults to <whence_enum::SEEK_SET>
    // and may be set to any one of the 3 values:
    //
    // SEEK_SET - offset is added tothe start position of stream, and should be
    // a positive int.
    //
    // SEEK_CUR - offset is added to the current stream position, and can be
    // positive (to seek forward) or negative (to seek backwards).
    //
    // SEEK_END - offset is added to the last stream position and is usually
    // negative, although some platfroms allow seeking beyond the end of a
    // stream.
    //
    pure virtual function void
    seek(int _offset, io::whence_enum _whence=io::SEEK_SET);

    // Function: rewind
    //
    // Rewinds the current position to the start of the stream.
    //
    pure virtual function void
    rewind();

    // ---------------------------------------------------------------------------
    // Group: Inquiries
    // ---------------------------------------------------------------------------

    // Function: seekable
    //
    // Returns 1 if the stream supports random access, or 0 otherwise.
    //
    pure virtual function bit
    seekable();

    // Function: readable
    //
    // Returns 1 if the stream was opened for reading, or 0 otherwise.
    //
    pure virtual function bit
    readable();

    // Function: writeable
    //
    // Returns 1 if the stream was opened for writing, or 0 otherwise.
    //
    pure virtual function bit
    writeable();

    // ---------------------------------------------------------------------------
    // Group: Reading
    // ---------------------------------------------------------------------------

    // Function: read
    //
    // Read at most _size bytes.
    //
    // If _size is left unspecified, the entire stream data is read.
    //
    // Data is returned as <string>.
    //
    pure virtual function string
    read(int _size=0);

    // Function: readline
    //
    // Read and return one line from the stream.
    //
    // if size is specified, at most size bytes will be read.
    //
    pure virtual function string
    readline(int _size=0);

    // Function: readinto
    //
    // Read at most _size bytes of data from the stream into _b.
    //
    // If _size is left unspecified, the entire stream data is read.
    //
    // Returns the total number of bytes read from the stream.
    //
    pure virtual function int
    readinto(ref string _b, input int _size=0);

    // Function: readall
    //
    // Read all data from the stream, returned as <string>.
    //
    pure virtual function string
    readall();

    // ---------------------------------------------------------------------------
    // Group: Writing
    // ---------------------------------------------------------------------------

    // Function: write
    //
    // Write _str to stream.
    //
    pure virtual function void
    write(string _str);

    // Function: writeln
    //
    // Same as <write> but appends a newline at the end of the string.
    //
    pure virtual function void
    writeln(string _str);

    // ---------------------------------------------------------------------------
    // Group: Low-level API
    // ---------------------------------------------------------------------------

    // Function: mode
    //
    // Returns the string of the mode for which the stream was opened.
    //
    pure virtual function string
    mode();

    // Function: fileno
    //
    // Returns the underlying file descriptor of the stream, if it exists.
    //
    // If the object does not use a file descriptor, 0 is returned.
    //
    pure virtual function int
    fileno();
endclass: stream

`endif // NICE_IO_STREAM_SVH
