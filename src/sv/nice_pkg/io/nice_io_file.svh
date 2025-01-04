`ifndef NICE_IO_FILE_SVH
`define NICE_IO_FILE_SVH

// Class: io::file
//
// Concrete <stream> class for handling file I/O stream operations.
//
// See following example for basic usage:
// (start code)
//  function main();
//      file f;
//      string content;
//
//      f = file::open("file.txt", "r");
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
//      f = file::open("file.txt", "w");
//      f.write("This requires adding a newline. \n");
//      f.writeln("But this does not.");
//      f.close();
//
//  endfunction
// (end)
//
class file
extends uvm_object
implements stream;
    `nice_object_utils(file)

    // ---------------------------------------------------------------------------
    // Group: Opening files
    // ---------------------------------------------------------------------------

    // Function: open
    //
    // Open the file stream at the specified _path for the specified _mode.
    //
    static function file
    open(string _path, string _mode="r");
        open = new(_path);
        open._set_mode(_mode);
        open._set_path(_path);
        open._set_fileno($fopen(_path, _mode));
        open.init();
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Closing and flushing
    // ---------------------------------------------------------------------------

    // Function: flush
    //
    // Flush the write buffers of the stream if such exist.
    //
    // This method does nothing for read-only streams.
    //
    virtual function void
    flush();
        $fflush(this.m_fd);
        this.m_buffer = "";
    endfunction

    // Function: close
    //
    // Flush and close the stream.
    //
    // If the stream is already closed, this method silently returns.
    //
    // Once a stream is closed, any read/write operation on the stream is will
    // result in a fatal error.
    //
    virtual function void
    close();
        if (!this.closed()) begin
            this.flush();
            $fclose(this.m_fd);
            this._set_fileno(0);
            this.init();
        end
    endfunction

    // Function: closed
    //
    // Returns 1 if the stream is closed, or 0 otherwise.
    //
    virtual function bit
    closed();
        return this.m_fd == 0;
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Positioning
    // ---------------------------------------------------------------------------

    // Function: tell
    //
    // Returns the current stream position.
    //
    virtual function int
    tell();
        this._check_seekable();
        return $ftell(this.m_fd);
    endfunction

    // Function: seek
    //
    // seek to a new position in stream.
    //
    // offset specifies the number of bytes to seek from a given position.
    //
    // whence is an optional argument that defaults to <io::whence_enum::SEEK_SET>,
    // see <io::whence_enum> for more info.
    //
    virtual function void
    seek(int _offset, io::whence_enum _whence=io::SEEK_SET);
        this._check_seekable();
        if ($fseek(this.m_fd, _offset, _whence) == -1)
            this._check_errno();
        this._set_bytes_read(this.tell());
    endfunction

    // Function: rewind
    //
    // Rewinds the current position to the start of the stream.
    //
    virtual function void
    rewind();
        this._check_seekable();
        if ($rewind(this.m_fd) == -1)
            this._check_errno();
        this._reset_bytes_read();
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Inquiries
    // ---------------------------------------------------------------------------

    // Function: seekable
    //
    // Returns 1 if the stream supports random access, or 0 otherwise.
    //
    virtual function bit
    seekable();
        return !this.closed() && this.readable();
    endfunction

    // Function: readable
    //
    // Returns 1 if the stream was opened for reading, or 0 otherwise.
    //
    virtual function bit
    readable();
        return !this.closed() && !uvm_re_match(".*r.*", this.mode());
    endfunction

    // Function: writeable
    //
    // Returns 1 if the stream was opened for writing, or 0 otherwise.
    //
    virtual function bit
    writeable();
        return !this.closed() && !uvm_re_match(".*w.*", this.mode());
    endfunction

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
    virtual function string
    read(int _size=0);
        if (!this.readinto(read, _size))
            this._check_errno();
    endfunction

    // Function: readbyte
    //
    // Read at most _size bytes.
    //
    // If _size is left unspecified, the entire stream data is read.
    //
    // Data is returned as <string>.
    //
    virtual function bit
    readbyte(ref string _s);
        int _c;
        this._check_readable();

        if (this.eof())
            return 0;

        _c = $fgetc(this.m_fd);

        if (_c == io::EOF)
            return 0;

        _s = {_s, byte'(_c)};
        return 1;
    endfunction

    // Function: readline
    //
    // Read and return one line from the stream.
    //
    // if size is specified, at most size bytes will be read.
    //
    virtual function string
    readline(int _size=0);
        int i;

        this._check_readable();
        _size = this._corrected_size(_size);
        void'(this.readbyte(readline));

        while (!this.eof() && !io::is_newline(readline[i]) && i < _size)
            i += int'(this.readbyte(readline));

        this._increment_bytes_read(i);
    endfunction

    // Function: readinto
    //
    // Read at most _size bytes of data from the stream into buffer _b.
    //
    // If _size is not specified, all stream data will be read into _b.
    //
    // Returns the total number of bytes read from the stream.
    //
    virtual function int
    readinto(ref string _b, input int _size=0);
        byte _bytes[];
        this._check_readable();
        _size = this._corrected_size(_size);
        _bytes = new[_size];
        readinto = $fread(_bytes, this.m_fd, 0, _size);

        if (!readinto)
            this._check_errno();

        this._increment_bytes_read(readinto);
        _b = string'(_bytes);
    endfunction

    // Function: readall
    //
    // Read all data from the stream, returned as <string>.
    //
    virtual function string
    readall();
        void'(this.readinto(readall));
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Writing
    // ---------------------------------------------------------------------------

    // Function: write
    //
    // Write _str to stream and return the number of bytes written.
    //
    virtual function void
    write(string _str);
        this._check_writeable();
        $fwrite(this.m_fd, "%s", _str);
    endfunction

    // Function: writeln
    //
    // Same as <write> but appends a newline at the end of the string.
    //
    virtual function void
    writeln(string _str);
        this.write({_str, "\n"});
    endfunction

    // ---------------------------------------------------------------------------
    // Group: Low-level API
    // ---------------------------------------------------------------------------

    // Function: eof
    //
    // Tests the end-of-file condition for the current file stream.
    //
    // Returns a nonzero value when EOF has previously been detected reading the
    // stream, or 0 otherwise.
    //
    virtual function int
    eof();
        this._check_readable();
        return $feof(this.m_fd) != 0;
    endfunction

    // Function: size
    //
    // Returns the total byte size of the stream.
    //
    virtual function int
    size();
        return this.m_size;
    endfunction

    // Function: mode
    //
    // Returns the string of the mode for which the stream was opened.
    //
    virtual function string
    mode();
        return this.m_filemode;
    endfunction

    // Function: path
    //
    // Returns the file path that was used for opening the stream.
    //
    virtual function string
    path();
        return this.m_filepath;
    endfunction

    // Function: fileno
    //
    // Returns the underlying file descriptor of the stream, if it exists.
    //
    // If the object does not use a file descriptor, 0 is returned.
    //
    virtual function int
    fileno();
        fileno = this.m_fd;
    endfunction

    // Function: bytes_read
    //
    // Returns a count of the number of bytes read so far.
    //
    virtual function int
    bytes_read();
        this._check_readable();
        return this.m_bytes_read;
    endfunction

    // Function: bytes_unread
    //
    // Returns a count of the number of bytes left to be read until eof.
    //
    virtual function int
    bytes_unread();
        this._check_readable();
        return (
            this.size() - this.bytes_read()
        );
    endfunction

    // ---------------------------------------------------------------------------
    // Internal
    // ---------------------------------------------------------------------------

    local static int m_fds[string];

    local int m_fd;
    local int m_size;
    local int m_bytes_read;
    local string m_buffer;
    local string m_filepath;
    local string m_filemode;

    protected virtual function void
    init();
        if (this.seekable())
            this._init_size();
    endfunction

    protected virtual function void
    _init_size();
        this._reset_size();
        this.seek(0, io::SEEK_END);
        this._set_size(this.tell());
        this.rewind();
    endfunction

    protected virtual function void
    _init_buffer();
        this._reset_buff();

        if (!this.readinto(this.m_buffer))
            this._check_errno();

        this.rewind();
        `NICE_DEBUG(("readinto(this.m_buffer): m_buffer=%s", this.m_buffer))
    endfunction

    protected virtual function void
    _set_mode(string _mode);
        this.m_filemode = _mode;
    endfunction

    protected virtual function void
    _set_path(string _path);
        this.m_filepath = _path;
    endfunction

    protected virtual function void
    _set_size(int _size);
        this.m_size = _size;
    endfunction

    protected virtual function void
    _set_fileno(int _fd);
        this.m_fd = _fd;

        if (this.closed())
            this._check_errno();
    endfunction

    protected virtual function void
    _set_bytes_read(int _bytes_read);
        this.m_bytes_read = _bytes_read;
    endfunction

    protected virtual function void
    _reset_mode();
        this.m_filemode = "";
    endfunction

    protected virtual function void
    _reset_path();
        this.m_filepath = "";
    endfunction

    protected virtual function void
    _reset_size();
        this.m_size = 0;
    endfunction

    protected virtual function void
    _reset_fileno();
        this.m_fd = 0;

        if (this.closed())
            this._check_errno();
    endfunction

    protected virtual function void
    _reset_buff();
        this.m_buffer = "";
        this._reset_bytes_read();
    endfunction

    protected virtual function void
    _reset_bytes_read();
        this.m_bytes_read = 0;
    endfunction

    protected virtual function void
    _increment_bytes_read(int _bytes_read);
        this.m_bytes_read += _bytes_read;
    endfunction

    protected virtual function void
    _check_errno();
        string err;
        if ($ferror(this.m_fd, err)) begin
            $stacktrace();
            `NICE_FTL(({"An error occured during a stream operation: ", err}))
        end
    endfunction

    protected virtual function void
    _check_open();
        if (this.closed()) begin
            $stacktrace();
            `NICE_FTL(("stream is closed."))
        end
    endfunction

    protected virtual function void
    _check_closed();
        if (!this.closed()) begin
            $stacktrace();
            `NICE_FTL(("stream is open."))
        end
    endfunction

    protected virtual function void
    _check_readable();
        if (!this.readable()) begin
            $stacktrace();
            `NICE_FTL(("current stream does not support read operations."))
        end
    endfunction

    protected virtual function void
    _check_writeable();
        if (!this.writeable()) begin
            $stacktrace();
            `NICE_FTL(("current stream does not support write operations."))
        end
    endfunction

    protected virtual function void
    _check_seekable();
        if (!this.seekable()) begin
            $stacktrace();
            `NICE_FTL(("current stream does not support random access operations."))
        end
    endfunction

    protected virtual function int
    _corrected_size(int _size);
        int _bytes_unread = this.bytes_unread();
        return (_size <= 0 || _size > _bytes_unread ?  _bytes_unread: _size);
    endfunction

endclass: file

`endif // NICE_IO_FILE_SVH
