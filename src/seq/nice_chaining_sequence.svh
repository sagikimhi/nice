//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_chaining_sequence.svh
// Author        : skimhi
// Created       : Mon Sep 2024, 03:08:27
// Last modified : Mon Sep 2024, 03:08:27
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Mon Sep 2024, 03:08:27
//-----------------------------------------------------------------------------

`ifndef NICE_CHAINING_SEQUENCE_SVH
`define NICE_CHAINING_SEQUENCE_SVH

// Class: seq::chaining_sequence
//
// A chaining sequence is a sequence attached to a <chained_sequencer> instance.
//
class chaining_sequence#(
    type UP_REQ=uvm_sequence_item,
    type DOWN_REQ=uvm_sequence_item,
    type UP_TRAFFIC=UP_REQ,
    type DOWN_TRAFFIC=DOWN_REQ,
    type CHAINED_SEQR=chained_sequencer#(
        .UP_REQ(UP_REQ),
        .DOWN_REQ(DOWN_REQ),
        .UP_TRAFFIC(UP_TRAFFIC),
        .DOWN_TRAFFIC(DOWN_TRAFFIC)
    )
)
extends sp_base_seq#(DOWN_REQ);
    `nice_param_object(chaining_sequence#(
        .UP_REQ(UP_REQ),
        .DOWN_REQ(DOWN_REQ),
        .UP_TRAFFIC(UP_TRAFFIC),
        .DOWN_TRAFFIC(DOWN_TRAFFIC),
        .CHAINED_SEQR(CHAINED_SEQR)
    ))
    `uvm_declare_p_sequencer(CHAINED_SEQR)

    // ---------------------------------------------------------------------------
    // Group: Sequence Execution
    // ---------------------------------------------------------------------------

    // Task: body
    //
    // Forks two seperate processes, one for handling requests from upstream to
    // downstream, and another for handling traffic from downstream to upstream.
    //
    //| virtual task body();
    //|     fork
    //|         this.handle_requests();
    //|         this.handle_traffic();
    //|     join
    //| endtask: body
    //
    // This implementation is presented as part of the API to better highlight
    // the general responsibilities of a <chaining_sequence>, and to direct the
    // user as towards the relevant area in code where each of these
    // responsibilities should be handled.
    //
    // In most cases the given implementation is enough and should not be
    // overriden in sub-classes to customize handling of requests and traffic.
    //
    // To customize handling of requests and traffic, see Request API and
    // Traffic API documentation groups, and override any relevant hook
    // presented in each of these groups to fit behavior to your own custom
    // requirements.
    //
    // In all cases, this method should not be called directly by the user.
    //
    // For more general info about the body task and why it should not be called
    // directly, see documentation of <uvm_sequence_base::body()>.
    //
    virtual task body();
        fork
            this.handle_requests();
            this.handle_traffic();
        join
    endtask: body

    // ---------------------------------------------------------------------------
    // Group: Request API
    // ---------------------------------------------------------------------------

    // Task: handle_requests
    //
    // Main request handling task.
    //
    //| virtual task
    //| handle_requests();
    //|     UP_REQ up_req;
    //|     DOWN_REQ down_req;
    //|
    //|     forever begin
    //|         this.get_upstream_request(up_req);
    //|
    //|         if (this.should_handle_request(down_req)) begin
    //|             this.create_downstream_request(down_req);
    //|             this.make_downstream_request(up_req, down_req);
    //|             this.send_downstream_request(down_req);
    //|         end
    //|     end
    //| endtask: handle_requests
    //
    // This task fetches any available upstream requests from the chained
    // sequencer's fifo, converts it to the proper downstream request type, and
    // sends the downstream request down the chain through the sequencer's
    // ~seq_item_export~ like a normal sequence.
    //
    // The user-definable hooks <get_upstream_request()>,
    // <create_downstream_request()>, <make_downstream_request()>, and
    // <send_downstream_request()> are provided with a default implementation to
    // allow modification/adjustment of each step in the process.
    //
    virtual task
    handle_requests();
        UP_REQ up_req;
        DOWN_REQ down_req;

        forever begin
            this.get_upstream_request(up_req);

            if (this.should_handle_request(down_req)) begin
                this.create_downstream_request(down_req);
                this.make_downstream_request(up_req, down_req);
                this.send_downstream_request(down_req);
            end
        end
    endtask: handle_requests

    // Function: should_handle_request
    //
    // Returns 1 if sequence should handle the upstream request represented by
    // the argument up_req, or 0 if it should be ignored and discarded.
    //
    // The provided default implementation performs a minimal nullity check and
    // returns 1 if up_req is defined, or 0 if it is null.
    //
    // Users should probably override the default implementation and modify it
    // to return a result fitting to their own custom terms and requirements.
    //
    virtual function bit
    should_handle_request(ref UP_REQ up_req);
        return up_req != null;
    endfunction: should_handle_request

    // Function: create_downstream_request
    //
    // User-definable hook called to create a downstream request from the
    // fetched ~upstream~ request.
    //
    virtual function void
    create_downstream_request(ref DOWN_REQ down_req);
        down_req = DOWN_REQ::type_id::create("down_req");
        down_req.set_item_context(this, this.p_sequencer);
    endfunction: create_downstream_request

    // Task: make_downstream_request
    //
    // User definable hook called to initialize a downstream request after it has been created.
    //
    // The original upstream request from which the downstream request was
    // created is also provided as an argument incase needed to initialize the
    // downstream request.
    //
    virtual task
    make_downstream_request(
        ref UP_REQ up_req,
        ref DOWN_REQ down_req
    );
    endtask: make_downstream_request

    // Task: send_downstream_request
    //
    // User definable hook called to send the ~downstream~ request down the
    // chain through the sequencer.
    //
    virtual task
    send_downstream_request(DOWN_REQ down_req);
        this.start_item(down_req);

        if (!down_req.randomize())
            `sp_ftl({"Failed to randomize downstream request item:\n", down_req.sprint()})

        this.finish_item(down_req);
    endtask: send_downstream_request

    // Task: next_upstream_request
    //
    // Get the next upstream request from the <chained_sequencer>'s upstream
    // fifo.
    //
    virtual task
    get_upstream_request(output UP_REQ up_req);
        this.p_sequencer.up_req_fifo.get(up_req);
    endtask: get_upstream_request

    // Function: try_next_upstream_request
    //
    // Try to get the next upstream request from the <chained_sequencer>'s
    // upstream fifo.
    //
    virtual function bit
    try_get_upstream_request(output UP_REQ up_req);
        return this.p_sequencer.up_req_fifo.try_get(up_req);
    endfunction: try_get_upstream_request

    // ---------------------------------------------------------------------------
    // Group: Traffic API
    // ---------------------------------------------------------------------------

    // Task: handle_traffic
    //
    // Main traffic handling task.
    //
    //
    //| virtual task
    //| handle_traffic();
    //|     DOWN_TRAFFIC down_traffic;
    //|     UP_TRAFFIC up_traffic;
    //|
    //|     forever begin
    //|         this.get_downstream_traffic(down_traffic);
    //|
    //|         if (this.should_handle_traffic(down_traffic)) begin
    //|             this.create_upstream_traffic(up_traffic);
    //|             this.make_upstream_traffic(down_traffic, up_traffic);
    //|             this.send_upstream_traffic(up_traffic);
    //|         end
    //|     end
    //| endtask: handle_traffic
    //
    // This task fetches any available downstream traffic from retrieved to the
    // chained sequencer from the chained sequencer's fifo, converts it to the
    // proper upstream traffic type, and sends the upstream traffic back up the
    // chain through the sequencer's ~up_traffic_port~.
    //
    // The user-definable hooks <get_downstream_traffic()>,
    // <create_upstream_traffic()>, <make_upstream_traffic()>, and
    // <send_upstream_traffic()> are provided with a default implementation to
    // allow modification/adjustment of each step in the process.
    //
    virtual task
    handle_traffic();
        DOWN_TRAFFIC down_traffic;
        UP_TRAFFIC up_traffic;

        forever begin
            this.get_downstream_traffic(down_traffic);

            if (this.should_handle_traffic(down_traffic)) begin
                this.create_upstream_traffic(up_traffic);
                this.make_upstream_traffic(down_traffic, up_traffic);
                this.send_upstream_traffic(up_traffic);
            end
        end
    endtask: handle_traffic

    // Function: should_handle_traffic
    //
    // Returns 1 if sequence should handle the downstream traffic represented by
    // the argument down_traffic, or 0 if it should be ignored and discarded.
    //
    // The provided default implementation performs a minimal nullity check and
    // returns 1 if down_traffic is defined, or 0 if it is null.
    //
    // Users should probably override the default implementation and modify it
    // to return a result fitting to their own custom terms and requirements.
    //
    virtual function bit
    should_handle_traffic(ref DOWN_TRAFFIC down_traffic);
        return down_traffic != null;
    endfunction: should_handle_traffic

    // Function: create_upstream_traffic
    //
    // User-definable hook called to create upstream traffic from the retrieved
    // downstream traffic response.
    //
    virtual function void
    create_upstream_traffic(ref UP_TRAFFIC up_traffic);
        up_traffic = UP_TRAFFIC::type_id::create("up_traffic");
        up_traffic.set_parent_sequence(this);
    endfunction: create_upstream_traffic

    // Task: make_upstream_traffic
    //
    // User-definable hook called to handle the retrieved downstream traffic and
    // make the upstream traffic to be sent by <send_upstream_traffic>.
    //
    virtual task
    make_upstream_traffic(
        ref DOWN_TRAFFIC down_traffic,
        ref UP_TRAFFIC up_traffic
    );
    endtask: make_upstream_traffic

    // Task: send_upstream_traffic
    //
    // Send the upstream traffic item through the <chained_sequencer>'s
    // <upstream traffic port: chained_sequencer.up_traffic_port>.
    //
    virtual task
    send_upstream_traffic(UP_TRAFFIC up_traffic);
        this.p_sequencer.up_traffic_port.put(up_traffic);
    endtask: send_upstream_traffic

    // Task: get_downstream_traffic
    //
    // Get the next downstream traffic from the <chained_sequencer>'s
    // ~downstream traffic fifo~.
    //
    virtual task
    get_downstream_traffic(output DOWN_TRAFFIC down_traffic);
        this.p_sequencer.down_traffic_fifo.get(down_traffic);
    endtask: get_downstream_traffic

    // Function: try_get_downstream_traffic
    //
    // Try to get the next downstream traffic from the <chained_sequencer>'s
    // ~downstream traffic fifo~.
    //
    virtual function bit
    try_get_downstream_traffic(output DOWN_TRAFFIC down_traffic);
        this.p_sequencer.down_traffic_fifo.try_get(down_traffic);
    endfunction: try_get_downstream_traffic

endclass: chaining_sequence


`endif // NICE_CHAINING_SEQUENCE_SVH
