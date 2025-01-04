//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_io_file_reader.svh
// Author        : skimhi
// Created       : Mon Sep 2024, 15:19:48
// Last modified : Mon Sep 2024, 15:19:48
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Mon Sep 2024, 15:19:48
//-----------------------------------------------------------------------------

`ifndef NICE_IO_FILE_READER_SVH
`define NICE_IO_FILE_READER_SVH

// Class: io::reader_config
//
// Base reader configuration object class.
//
class reader_config extends sp_base_object;
    `nice_object(reader_config)

    // ---------------------------------------------------------------------------
    // Group: Variables
    // ---------------------------------------------------------------------------

    // Variable: m_file_handle
    //
    // A handle to the file, when no file is open, it is set to 0 by default.
    //
    // Method <is_open()> may be used to check if a file is currently open.
    //
    int m_file_handle;

    // Variable: m_file_path
    //
    // The path to the file IO.
    //
    string m_file_path;

    // Variable: m_file_mode
    //
    // The mode in which the file should be opened, since this is a reader,
    // it is either "r" for normal reading or "rb" for reading binary data.
    //
    string m_file_mode;

endclass: reader_config


// Class: io::file_reader
//
// Base file reader class.
//
class file_reader extends sp_base_object;
    `define nice_init
    `nice_object(file_reader)

    // ---------------------------------------------------------------------------
    // Group: Types
    // ---------------------------------------------------------------------------

    typedef byte bytearray_t[];

    typedef string string_queue[$];

    // ---------------------------------------------------------------------------
    // Group: Variables
    // ---------------------------------------------------------------------------

    // Variable: m_buff
    //
    // When reading the entire file instead of parsing line by line, it will be
    // loaded onto this variable.
    //
    byte m_buffer[];

    // Variable: m_lines
    //
    // Any previously read lines can be accessed through this field.
    //
    string m_lines[$];

    // Variable: m_cfg
    //
    // Reader configuration object.
    //
    reader_config m_cfg;

    // ---------------------------------------------------------------------------
    // Group: IO Operations
    // ---------------------------------------------------------------------------

    // Function: eof
    //
    // Returns the result from $feof system task on the current file handle.
    //
    // If no file handle is currently open, returns -1.
    //
    virtual function int
    eof();
        if (this.is_open())
            return $feof(this.file_handle());
        else
            return -1;
    endfunction: eof

    // Function: open
    //
    // Attempts to open the given ~_filepath~ for reading and sets a handle to
    // the file internally upon success for further operations and processing.
    //
    // Upon failure, it will report a fatal and exit.
    //
    // Any previous open file handles will be automatically closed by the
    // reader.
    //
    virtual function void
    open();
        int _fd;
        string _error;

        _fd = $fopen(this.file_path(), this.file_mode());

        if (this.has_error()) begin
            this.close(); // No-op if no stream is open.
            `sp_ftl({"Open file error: ", this.error_string()})
        end

        this.set_file_handle(_fd);
    endfunction: open

    // Function: close
    //
    // Closes the current I/O stream.
    //
    // If no stream is active, the method silently returns
    //
    virtual function void
    close();
        if (this.is_open())
            $fclose(this.file_handle());
    endfunction: close

    // Function: read
    //
    // Read the entire file into the reader's buffer.
    //
    virtual function void
    read();
        if (!this.is_open())
            return;

        this.increment_bytes_read(
            $fread(this.m_buffer, this.file_handle())
        );

        if (this.has_error())
            `sp_ftl(this.error_string())
    endfunction: read

    // Function: read_line
    //
    // Read a line of input and return it.
    //
    // If ~_lineno~ is set to the default, the reader will attempt to read the
    // next available line of input.
    //
    // If ~_lineno~ is specified, the reader will attempt to read the specified
    // line.
    //
    // Both when specified, and when left unspecified, a valid read would return
    // the string buffer, and an invalid string would return null.
    //
    virtual function void
    read_line();
        if (this.is_open() && !this.eof()) begin
            string _line;
            int _bytes_read;

            _bytes_read = $fgets(_line, this.file_handle());

            if (_bytes_read == 0 && this.has_error())
                `sp_ftl(this.error_string())


            this.m_lines.push_back(_line);
            this.increment_bytes_read(_bytes_read);
        end
    endfunction: read_line

    // Function: read_lines
    //
    // Read all lines into the queue until reaching eof or an error occurs,
    // whichever happens first.
    //
    virtual function void
    read_lines();
        while (this.is_open() && !this.eof())
            this.read_line();
    endfunction: read_lines

    // ---------------------------------------------------------------------------
    // Group: IO Configuration
    // ---------------------------------------------------------------------------

    // Variable: cfg
    //
    // Get the reader's configuration object instance.
    //
    virtual function reader_config
    cfg();
        return this.m_cfg;
    endfunction: cfg

    // Function: set_cfg
    //
    // Set _cfg as the reader's configuration object instance.
    //
    virtual function void
    set_cfg(reader_config _cfg);
        this.m_cfg = _cfg;
    endfunction: set_cfg

    // Function: file_path
    //
    // Get the currently set file path.
    //
    virtual function string
    file_path();
        return this.cfg().m_file_path;
    endfunction: file_path

    // Function: set_file_path
    //
    // Set ~_path~ as the reader's file path.
    //
    virtual function void
    set_file_path(string _path);
        this.m_cfg.m_file_path = _path;
    endfunction: set_file_path

    // Function: file_mode
    //
    // Get the currently set file mode.
    //
    virtual function string
    file_mode();
        return this.cfg().m_file_mode;
    endfunction: file_mode

    // Function: set_file_mode
    //
    // Set ~_mode~ as the reader's file open mode.
    //
    virtual function void
    set_file_mode(string _mode="r");
        this.m_cfg.m_file_mode = _mode;
    endfunction: set_file_mode

    // Function: file_handle
    //
    // Get the handle to the file.
    //
    // When no file is currently open, it returns 0.
    //
    virtual function int
    file_handle();
        return this.cfg().m_file_handle;
    endfunction: file_handle

    // ---------------------------------------------------------------------------
    // Group: IO Data
    // ---------------------------------------------------------------------------

    // Function: line
    //
    // Returns the line from the read lines queue at the specified ~_index~.
    //
    // If the index is left with its default value, returns the last line that
    // was read by the reader instance.
    //
    // If ~_index~ is invalid, returns null.
    //
    virtual function string
    line(int _index=-1);
        if (_index == -1)
            return this.m_lines[$];
        else
            return this.m_lines[_index];
    endfunction: line

    // Function: lines
    //
    // Returned all previously read lines that are still available under
    // <m_lines> queue.
    //
    virtual function string_queue
    lines();
        return this.m_lines;
    endfunction: lines

    // Function: buffer
    //
    // Returns the byte array buffer.
    //
    // This buffer is used when reading an entire stream via <read()>.
    //
    // When reading line by line via <read_line()>, the ~line~ and/or ~lines~
    // methods should be used instead.
    //
    virtual function bytearray_t
    buffer();
        return this.m_buffer;
    endfunction: buffer

    // Function: pop_line
    //
    // Same as method <line()>, but also pops the line from the fifo before
    // returning it.
    //
    virtual function string
    pop_line(int _index=-1);
        if (_index == -1)
            return this.m_lines.pop_back();
        else begin
            pop_line = this.m_lines[_index];
            this.m_lines.delete(_index);
        end
    endfunction: pop_line

    // Function: num_lines
    //
    // Returns the current size of the <lines()> queue.
    //
    virtual function int
    num_lines();
        return this.m_lines.size();
    endfunction: num_lines

    // Function: is_open
    //
    // Returns 1 if an I/O stream is currently open for reading, or 0 otherwise.
    //
    virtual function bit
    is_open();
        return this.file_handle() != 0;
    endfunction: is_open

    // Function: has_error
    //
    // Returns 1 if an error occured during the last reading operation or 0
    // otherwise.
    //
    virtual function bit
    has_error();
        return $ferror(this.m_cfg.m_file_handle, this.m_error_string) != 0;
    endfunction: has_error

    virtual function bit
    is_index_valid(int _index);
        return _index >= 0 && _index < this.num_lines();
    endfunction: is_index_valid

    // ---------------------------------------------------------------------------
    // Group: Printing Data
    // ---------------------------------------------------------------------------

    // Function: print_line
    //
    // Prints a single line from the queue at the specified index to the
    // standard output.
    //
    virtual function void
    print_line(int _index=-1);
        `sp_print(this.line(_index))
    endfunction: print_line

    // Function: print_lines
    //
    // Prints all lines in the queue to the standard output.
    //
    virtual function void
    print_lines();
        for (int _i = 0; _i < this.num_lines(); _i++)
            this.print_line(_i);
    endfunction: print_lines

    // Function: last_error_code
    //
    // Returns the latest returned error code, if any.
    //
    // If no error code was ever returned, returns 0.
    //
    virtual function int
    error_code();
        return this.m_error_code;
    endfunction: error_code

    // Function: error_string
    //
    // Returns the latest error string retrieved from <$ferror()>, or an empty
    // string if no error previously occured.
    //
    virtual function string
    error_string();
        return this.m_error_string;
    endfunction: error_string

    // ---------------------------------------------------------------------------
    // Internal
    // ---------------------------------------------------------------------------

    local int m_bytes_read;
    local int m_error_code;
    local string m_error_string;

    protected virtual function void init();
        this.set_cfg(reader_config::type_id::create("m_cfg"));
        this.set_bytes_read(0);
        this.set_file_path("");
        this.set_file_mode("r");
    endfunction: init

    protected virtual function void
    set_file_handle(int _handle);
        this.m_cfg.m_file_handle = _handle;
    endfunction: set_file_handle

    protected virtual function void
    set_bytes_read(int _n);
        this.m_bytes_read = _n;
    endfunction: set_bytes_read

    protected virtual function void
    increment_bytes_read(int _n);
        this.m_bytes_read += _n;
    endfunction: increment_bytes_read

endclass: file_reader

`endif // NICE_IO_FILE_READER_SVH
