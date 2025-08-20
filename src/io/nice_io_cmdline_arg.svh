`ifndef NICE_IO_CMDLINE_ARG_SVH
`define NICE_IO_CMDLINE_ARG_SVH

// Class: io::cmdline_arg
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
//      if (bar.arg_exists())
//          this.bazz();
//
//      // Check whether a value was specified with the argument
//      if (bar.value_exists()) begin
//          this.foo_bar_bazz(
//              bar.value()
//          );
//      end
//  endfunction
// (end)
//
class cmdline_arg#(type T=int, string FORMAT="=%d")
extends uvm_object;
    `define nice_init_cb
    `nice_param_object_utils(cmdline_arg#(T, FORMAT))

    // Function: arg
    //
    // Get the command line argument checked against argv as a string.
    //
    virtual function string arg();
        return this.get_name();
    endfunction

    // Function: arg_exists
    //
    // Returns 1 if the argument was provided via command line or 0 otherwise.
    //
    virtual function bit arg_exists();
        return this.m_exists;
    endfunction

    // Function: value
    //
    // Get the value of the command line argument, if provided through the
    // command line, if no value was provided, a fatal is reported.
    //
    virtual function T value();
        this._check_value_exists();
        return this.m_value;
    endfunction

    // Function: value_exists
    //
    // Returns 1 if both an argument and a value were provided through the
    // command line, or 0 otherwise.
    //
    virtual function bit value_exists();
        return this.m_value_exists;
    endfunction

    // Function: format
    //
    // Get the format used to extract the value of the command line argument as
    // a string.
    //
    virtual function string format();
        return FORMAT;
    endfunction

    // Function: arg_with_format
    //
    // Get the entire command line argument including the format tested against
    // the "$value$plusarg" system task as a string.
    //
    virtual function string arg_with_format();
        return {this.arg(), this.format()};
    endfunction

    // ---------------------------------------------------------------------------
    // Internal
    // ---------------------------------------------------------------------------

    local T m_value;
    local bit m_exists;
    local bit m_value_exists;

    virtual function void init();
        this.m_exists = bit'($test$plusargs(this.get_name()));
        this.m_value_exists = bit'(
            $value$plusargs(this.arg_with_format(), this.m_value)
        );
    endfunction

    virtual function void
    _check_value_exists();
        if (!this.value_exists())
            this._report_invalid_access();
    endfunction

    virtual function void
    _report_invalid_access();
    `NICE_FTL(({
        "Cannot get non-existent value, ",
        "this method should only be called if value_exists() returns 1."
    }))
    endfunction
endclass: cmdline_arg

// Typedef: int_cmdline_arg
//
// Integral command line argument class typedef.
//
typedef cmdline_arg#(int, "=%d")
int_cmdline_arg;

// Typedef: string_cmdline_arg
//
// String type command line argument typedef.
//
typedef cmdline_arg#(string, "=%s")
string_cmdline_arg;

`endif // NICE_IO_CMDLINE_ARG_SVH
