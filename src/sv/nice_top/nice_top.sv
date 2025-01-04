`ifndef NICE_TOP_SV
`define NICE_TOP_SV


`timescale 1ns / 1ns


`include "uvm_macros.svh"
`include "nice_defines.svh"

package nice_test_pkg;
    import uvm_pkg::*;
    import nice_pkg::*;
    typedef byte bytes[$];

    class nice_test extends uvm_test;
        `nice_component_utils(nice_test)

        io::file m_file;

        virtual task automatic
        run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            this.main();
            phase.drop_objection(this);
        endtask

        virtual task automatic
        main();
            automatic string _lines[$];
            automatic string _fname;

            _fname = "./nice_test.txt";
            _lines.push_back("abcdefg");
            _lines.push_back("");
            _lines.push_back("gfedcba");
            _lines.push_back("acdb");

            this.write_testfile(_fname, _lines);
            this.invoke_methods_and_print_res();
            this.read_testfile(_fname, _lines);
        endtask

        virtual task automatic
        write_testfile(string _fname, string _lines[$]);
            m_file = io::file::open(_fname, "w");

            foreach (_lines[i])
                m_file.writeln(_lines[i]);

            m_file.close();
        endtask

        virtual task automatic
        read_testfile(string _fname, string _expected_q[$]);
            automatic int _qsize;

            _qsize = _expected_q.size();

            for (int _i = 0; _i < _qsize; _i++) begin
                automatic string _expected = {_expected_q[_i], "\n"};
                automatic string _actual = this.m_file.readline();
                this.report_file_info();
                this.report_value_info(_expected, _actual);
                this.check_result(_expected, _actual);
            end
        endtask

        virtual function automatic void
        check_result(string _expected, string _actual);
            assert (_expected == _actual)
            else this.panic(_expected, _actual);
        endfunction

        virtual function automatic void
        panic(string _expected, string _actual);
            this.m_file.close();
            `NICE_FTL((
                "Expected != Actual\nASCII: (%s != %s)\nBytes: (%p != %p)",
                _expected, _actual, bytes'(_expected), bytes'(_actual)
            ));
        endfunction

        virtual task automatic
        invoke_methods_and_print_res();
            this.m_file = this.m_file.open(this.m_file.path(), "r");
            `NICE_INFO(($sformatf("")));
            `NICE_INFO(($sformatf("after open (mode): %s", this.m_file.mode())));
            `NICE_INFO(($sformatf("after open (path): %s", this.m_file.path())));
            `NICE_INFO(($sformatf("after open (eof): %%0d=%0d, %%0h=%0h", this.m_file.eof(), this.m_file.eof())));
            `NICE_INFO(($sformatf("after open (tell): %%0d=%0d, %%0h=%0h", this.m_file.tell(), this.m_file.tell())));
            `NICE_INFO(($sformatf("after open (size): %%0d=%0d, %%0h=%0h", this.m_file.size(), this.m_file.size())));
            `NICE_INFO(($sformatf("after open (fileno): %%0d=%0d, %%0h=%0h", this.m_file.fileno(), this.m_file.fileno())));
            `NICE_INFO(($sformatf("after open (bytes_read): %%0d=%0d, %%0h=%0h", this.m_file.bytes_read(), this.m_file.bytes_read())));
            `NICE_INFO(($sformatf("after open (bytes_unread): %%0d=%0d, %%0h=%0h", this.m_file.bytes_unread(), this.m_file.bytes_unread())));
            `NICE_INFO(($sformatf("")));
            `NICE_INFO(($sformatf("")));
            `NICE_INFO(($sformatf("read()=%s", this.m_file.read())));
            `NICE_INFO(($sformatf("after read (mode): %s", this.m_file.mode())));
            `NICE_INFO(($sformatf("after read (path): %s", this.m_file.path())));
            `NICE_INFO(($sformatf("after read (eof): %%0d=%0d, %%0h=%0h", this.m_file.eof(), this.m_file.eof())));
            `NICE_INFO(($sformatf("after read (tell): %%0d=%0d, %%0h=%0h", this.m_file.tell(), this.m_file.tell())));
            `NICE_INFO(($sformatf("after read (size): %%0d=%0d, %%0h=%0h", this.m_file.size(), this.m_file.size())));
            `NICE_INFO(($sformatf("after read (fileno): %%0d=%0d, %%0h=%0h", this.m_file.fileno(), this.m_file.fileno())));
            `NICE_INFO(($sformatf("after read (bytes_read): %%0d=%0d, %%0h=%0h", this.m_file.bytes_read(), this.m_file.bytes_read())));
            `NICE_INFO(($sformatf("after read (bytes_unread): %%0d=%0d, %%0h=%0h", this.m_file.bytes_unread(), this.m_file.bytes_unread())));
            `NICE_INFO(($sformatf("")));
            `NICE_INFO(($sformatf("")));
            this.m_file.rewind();
            `NICE_INFO(($sformatf("readall()=%s", this.m_file.readall())));
            `NICE_INFO(($sformatf("after readall (mode): %s", this.m_file.mode())));
            `NICE_INFO(($sformatf("after readall (path): %s", this.m_file.path())));
            `NICE_INFO(($sformatf("after readall (eof): %%0d=%0d, %%0h=%0h", this.m_file.eof(), this.m_file.eof())));
            `NICE_INFO(($sformatf("after readall (tell): %%0d=%0d, %%0h=%0h", this.m_file.tell(), this.m_file.tell())));
            `NICE_INFO(($sformatf("after readall (size): %%0d=%0d, %%0h=%0h", this.m_file.size(), this.m_file.size())));
            `NICE_INFO(($sformatf("after readall (fileno): %%0d=%0d, %%0h=%0h", this.m_file.fileno(), this.m_file.fileno())));
            `NICE_INFO(($sformatf("after readall (bytes_read): %%0d=%0d, %%0h=%0h", this.m_file.bytes_read(), this.m_file.bytes_read())));
            `NICE_INFO(($sformatf("after readall (bytes_unread): %%0d=%0d, %%0h=%0h", this.m_file.bytes_unread(), this.m_file.bytes_unread())));
            `NICE_INFO(($sformatf("")));
            `NICE_INFO(($sformatf("")));
            this.m_file.rewind();
            `NICE_INFO(($sformatf("after rewind (mode): %s", this.m_file.mode())));
            `NICE_INFO(($sformatf("after rewind (path): %s", this.m_file.path())));
            `NICE_INFO(($sformatf("after rewind (eof): %%0d=%0d, %%0h=%0h", this.m_file.eof(), this.m_file.eof())));
            `NICE_INFO(($sformatf("after rewind (tell): %%0d=%0d, %%0h=%0h", this.m_file.tell(), this.m_file.tell())));
            `NICE_INFO(($sformatf("after rewind (size): %%0d=%0d, %%0h=%0h", this.m_file.size(), this.m_file.size())));
            `NICE_INFO(($sformatf("after rewind (fileno): %%0d=%0d, %%0h=%0h", this.m_file.fileno(), this.m_file.fileno())));
            `NICE_INFO(($sformatf("after rewind (bytes_read): %%0d=%0d, %%0h=%0h", this.m_file.bytes_read(), this.m_file.bytes_read())));
            `NICE_INFO(($sformatf("after rewind (bytes_unread): %%0d=%0d, %%0h=%0h", this.m_file.bytes_unread(), this.m_file.bytes_unread())));
            `NICE_INFO(($sformatf("")));
            `NICE_INFO(($sformatf("")));
            `NICE_INFO(($sformatf("readline()=%s", this.m_file.readline())));
            `NICE_INFO(($sformatf("after readline (mode): %s", this.m_file.mode())));
            `NICE_INFO(($sformatf("after readline (path): %s", this.m_file.path())));
            `NICE_INFO(($sformatf("after readline (eof): %%0d=%0d, %%0h=%0h", this.m_file.eof(), this.m_file.eof())));
            `NICE_INFO(($sformatf("after readline (tell): %%0d=%0d, %%0h=%0h", this.m_file.tell(), this.m_file.tell())));
            `NICE_INFO(($sformatf("after readline (size): %%0d=%0d, %%0h=%0h", this.m_file.size(), this.m_file.size())));
            `NICE_INFO(($sformatf("after readline (fileno): %%0d=%0d, %%0h=%0h", this.m_file.fileno(), this.m_file.fileno())));
            `NICE_INFO(($sformatf("after readline (bytes_read): %%0d=%0d, %%0h=%0h", this.m_file.bytes_read(), this.m_file.bytes_read())));
            `NICE_INFO(($sformatf("after readline (bytes_unread): %%0d=%0d, %%0h=%0h", this.m_file.bytes_unread(), this.m_file.bytes_unread())));
            `NICE_INFO(($sformatf("")));
            `NICE_INFO(($sformatf("")));
        endtask

        virtual function automatic void
        report_file_info();
            `NICE_INFO(($sformatf("fileno: %%0d=%0d, %%0h=%0h", this.m_file.fileno(), this.m_file.fileno())));
            `NICE_INFO(($sformatf("mode: %s", this.m_file.mode())));
            `NICE_INFO(($sformatf("path: %s", this.m_file.path())));
            `NICE_INFO(($sformatf("eof: %%0d=%0d, %%0h=%0h", this.m_file.eof(), this.m_file.eof())));
            `NICE_INFO(($sformatf("tell: %%0d=%0d, %%0h=%0h", this.m_file.tell(), this.m_file.tell())));
            `NICE_INFO(($sformatf("size: %%0d=%0d, %%0h=%0h", this.m_file.size(), this.m_file.size())));
            `NICE_INFO(($sformatf("bytes_read: %%0d=%0d, %%0h=%0h", this.m_file.bytes_read(), this.m_file.bytes_read())));
            `NICE_INFO(($sformatf("bytes_unread: %%0d=%0d, %%0h=%0h", this.m_file.bytes_unread(), this.m_file.bytes_unread())));
        endfunction

        virtual function automatic void
        report_value_info(string _expected, string _actual);
            `NICE_INFO(($sformatf("Expected (bytes): %p", bytes'(_expected))));
            `NICE_INFO(($sformatf("Actual (bytes): %p", bytes'(_actual))));
            `NICE_INFO(($sformatf("Expected (ASCII): %s", _expected)));
            `NICE_INFO(($sformatf("Actual (ASCII): %s", _actual)));
        endfunction

    endclass
endpackage: nice_test_pkg

module nice_top();
    // -------------------------------------------------------------------------
    //  Sim Base Run
    // -------------------------------------------------------------------------

    initial begin
        uvm_pkg::run_test();
        $finish();
    end
endmodule // nice_top

`endif // NICE_TOP_SV
