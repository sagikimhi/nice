`ifndef NICE_COMPONENTS_CHAINED_SEQUENCER_SVH
`define NICE_COMPONENTS_CHAINED_SEQUENCER_SVH

// Class: seq::chained_sequencer
//
// A chained sequencer is a sequencer component that can be used in the same way
// by receiving items from a sequence and sending them in the form of requests
// to a driver, but it can also be connected to one or more chained sequencers,
// forming a chain of sequencers, which is where its name comes from.
//
// One advantage of this unorthodox approach is there is no one giant class that
// needs to maintain the complete protocol hierarchy. Each chaining sequence can
// manage its own level of the protocol, which can simplify design and debug.
//
// Secondly, multiple chained sequences may operate in parallel on the same
// chained sequencer. By using varying priority levels, this further isolates
// the different tasks between the levels of the protocol.
//
// A third advantage is that one can break the chain at any point and send its
// request items either directly into a driver, or skip the DUT altogether and
// send them via TLM ports directly to the corresponding chained sequencer. This
// allows engineers to simulate the design at different levels of abstraction.
//
// To better understand this are a few terms to familiarize yourself with.
//
// Upstream - the upstream refers to anything that represents the data
// and the protocol in a higher level of abstracton, relative to this level.
//
// Downstream - the downstream refers to anything that represents the data
// and the protocol as a lower level of abstracton, relative to this level.
//
// Requests - Sequence items that go from upstream to downstream (towards the
// driver, through one are more chained sequencers).
//
// Traffic - Sequence items that are monitored and have been received by the
// agent. Traffic items flow from downstream to upstream (away from the driver,
// through one or more chained sequencers).
//
class chained_sequencer#(
    type UP_REQ=uvm_sequence_item,
    type DOWN_REQ=uvm_sequence_item,
    type UP_TRAFFIC=UP_REQ,
    type DOWN_TRAFFIC=DOWN_REQ
)
extends uvm_sequencer#(DOWN_REQ);
    `define nice_init_cb
    `nice_param_component_utils(
        chained_sequencer#(
            UP_REQ, DOWN_REQ, UP_TRAFFIC, DOWN_TRAFFIC
        )
    )

    // -------------------------------------------------------------------------
    // Group: TLM Ports
    // -------------------------------------------------------------------------

    // Variable: up_req_port
    //
    // This port is used for pulling upstream requests from an upstream
    // component.
    //
    // This port is usually connected to an upstream sequencer's
    // seq_item_export.
    //
    uvm_seq_item_pull_port#(UP_REQ) up_req_port;

    // Variable: up_traffic_port
    //
    // This port is used for sending traffic upstream by a <chaining_sequence>.
    //
    // This port is usually connected to the upstream sequencer's
    // <down_traffic_export>.
    //
    uvm_analysis_port#(UP_TRAFFIC) up_traffic_port;

    // Variable: down_traffic_export
    //
    // This port is used for exporting traffic from the downstream.
    //
    // Exported items are then written to the downstream traffic fifo to be
    // handled and sent back upstream by the chainig sequence.
    //
    uvm_analysis_export#(DOWN_TRAFFIC) down_traffic_export;

    // Variable: down_req_port
    //
    // When chain is broken, this port is used to pull downstream requests from
    // a sequence, just like a driver. Pulled items are directly written to this
    // sequencer's downstream traffic fifo to be sent back as upstream traffic
    //
    uvm_seq_item_pull_port#(DOWN_REQ, DOWN_TRAFFIC) down_req_port;

    // -------------------------------------------------------------------------
    // Group: TLM FIFOs
    // -------------------------------------------------------------------------

    // Variable: up_req_fifo
    //
    // Temporarily stores requests pulled from upstream until they are handled
    // and sent downstream by the <chaining_sequence> running on this
    // <chained_sequencer>.
    //
    uvm_tlm_analysis_fifo#(UP_REQ) up_req_fifo;

    // Variable: down_traffic_fifo
    //
    // Temporarily stores traffic exported by downstream until it is fetched and
    // handled by the <chaining_sequence> running on this <chained_sequencer>.
    //
    uvm_tlm_analysis_fifo#(DOWN_TRAFFIC) down_traffic_fifo;

    // -------------------------------------------------------------------------
    // Group: Sequencer API
    // -------------------------------------------------------------------------

    // Function: cfg
    //
    // Get a handle to the sequencer's current config object.
    //
    virtual function uvm_object
    cfg();
        return this.m_config_object;
    endfunction

    // Function: set_cfg
    //
    // Set _cfg as the sequencer's current config object.
    //
    virtual function void
    set_cfg(uvm_object _cfg);
        if (!$cast(this.m_config_object, _cfg))
            `NICE_FTL(("Failed to set sequencer configuration object"))
    endfunction

    // Function: arbitration
    //
    // Get the sequencer's current arbitration mode.
    //
    virtual function uvm_sequencer_arb_mode
    arbitration();
        return this.get_arbitration();
    endfunction

    // -------------------------------------------------------------------------
    // Group: Chain API
    // -------------------------------------------------------------------------

    // Function: break_chain
    //
    // Marks a <chained_sequencer> as a "chain breaker", i.e. the last sequencer
    // in a chain of one or more <chained_sequencers>.
    //
    // A <chained_sequencer> marked as "chain breaker" actively pulls downstream
    // requests through the <down_req_port>, converting them to downstream
    // traffic, and writing them to the <down_traffic_fifo> to be sent back
    // upstream by a <chaining_sequence>.
    //
    virtual function void
    break_chain();
        this.m_break_chain = 1;
    endfunction

    // Function: is_chain_breaker
    //
    // Returns 1 if a <chained_sequencer> is a chain breaker, i.e. marks the end
    // of the chain, and is actively pulling downstream requests, converting
    // them to downstream traffic and storing them temporarily to be sent back
    // upstream by a <chaining_sequence>.
    //
    virtual function bit
    is_chain_breaker();
        return this.m_break_chain == 1;
    endfunction

    // -------------------------------------------------------------------------
    // Group: Chain Breaker API
    // -------------------------------------------------------------------------

    // Function: mend_chain
    //
    // Reverts a "chain breaker" mark of a previous call to <break_chain()>,
    // mending the chain and allowing its continuation through this
    // <chained_sequencer> instance.
    //
    // See <break_chain()> for more info.
    //
    virtual function void
    mend_chain();
        this.m_break_chain = 0;
    endfunction

    // Task: fetch_downstream
    //
    // Pulls an item from the <down_req_port> and writes it to the
    // <down_traffic_fifo> so that it can be later fetched by the chaining
    // sequence and driven as upstream traffic.
    //
    // In addition, this task also calls the <handle_down_traffic()>
    // user-definable callback so that any user defined tasks can be done on the
    // downstream item before calling the item_done() method.
    //
    virtual task
    fetch_downstream();
        DOWN_REQ down_req;
        DOWN_TRAFFIC down_traffic;

        forever begin
            this.down_req_port.get_next_item(down_req);
            this.convert_down_req(down_req, down_traffic);
            this.down_traffic_fifo.analysis_export.write(down_traffic);
            this.handle_down_traffic(down_traffic);
            this.down_req_port.item_done(down_traffic);
        end
    endtask

    // Function: convert_down_req
    //
    // User-definable hook called to convert a downstream request item to
    // downstream traffic item.
    //
    // Default implementation simply attempts to cast the item and returns the
    // cast operation's result.
    //
    virtual function void
    convert_down_req(
        ref DOWN_REQ down_req, ref DOWN_TRAFFIC down_traffic
    );
        $cast(down_traffic, down_req);
    endfunction

    // Task: handle_down_traffic
    //
    // Only called by a <chained_sequencer> marked as a "chain breaker".
    //
    // See <break_chain()> for additional information on that regard.
    //
    // User-definable hook called to handle downstream traffic right before the
    // call to down_req_port.item_done() is made, and right after its conversion
    // from downstream request to downstream traffic.
    //
    virtual task
    handle_down_traffic(DOWN_TRAFFIC traffic);
    endtask

    // -------------------------------------------------------------------------
    // Internal
    // -------------------------------------------------------------------------

    protected bit m_break_chain;

    virtual function void
    init();
        this.m_break_chain = 0;
        this.set_arbitration(UVM_SEQ_ARB_STRICT_FIFO);
    endfunction

    function void
    build_phase(uvm_phase phase);
        super.build_phase(phase);
        this.build_tlm_ports();
        this.build_tlm_fifos();
    endfunction

    virtual function void
    build_tlm_ports();
        this.up_req_port = new("up_req_port", this);
        this.up_traffic_port = new("up_traffic_port", this);
        this.down_traffic_export = new("down_traffic_export", this);

        if (this.is_chain_breaker())
            this.down_req_port = new("down_req_port", this);
    endfunction

    virtual function void
    build_tlm_fifos();
        this.up_req_fifo = new("up_req_fifo", this);
        this.down_traffic_fifo = new("down_traffic_fifo", this);
    endfunction

    virtual function void
    connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        this.down_traffic_export.connect(
            this.down_traffic_fifo.analysis_export
        );
    endfunction

    virtual task
    run_phase(uvm_phase phase);
        super.run_phase(phase);

        fork
            this.fetch_upstream();

            if (this.is_chain_breaker())
                this.fetch_downstream();
        join
    endtask

    virtual task
    fetch_upstream();
        UP_REQ up_req;

        forever begin
            this.up_req_port.get_next_item(up_req);
            this.up_req_fifo.analysis_export.write(up_req);
            this.up_req_port.item_done(up_req);
        end
    endtask

endclass: chained_sequencer

`endif // NICE_COMPONENTS_CHAINED_SEQUENCER_SVH
