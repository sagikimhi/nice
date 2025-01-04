`ifndef NICE_BUFFER_SVH
`define NICE_BUFFER_SVH


class buffer#(type T=uvm_object)
extends collections::deque#(T);
    `nice_param_object_utils(buffer#(T))
endclass: buffer

`endif // NICE_BUFFER_SVH
