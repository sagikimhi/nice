`ifndef NICE_COMPONENTS_BROADCASTER_SVH
`define NICE_COMPONENTS_BROADCASTER_SVH

// Class: components::broadcaster
//
// A utility component providing broadcast facilities.
//
// Simply call <add_provider()> to register a uvm_component as a provider of the
// broadcaster, and <add_subscriber()> to register any uvm_component as
// a subscriber of the broadcaster.
//
// Any items sent to the broadcaster by its providers will be broadcasted in
// order to any subscriber, allowing one to many, many to one, and many to many
// connections.
//
class broadcaster#(type T=uvm_object)
extends uvm_component;
    `define nice_init_cb
    `nice_param_component_utils(broadcaster#(T))

    // ---------------------------------------------------------------------------
    // Group: Types
    // ---------------------------------------------------------------------------

    // Type: uvm_port_t
    //
    // Typedef for the base uvm port class <uvm_port_base> with parameters
    // fitting to the broadcaster's item type parameter.
    //
    typedef uvm_port_base#(uvm_tlm_if_base#(T, T)) uvm_port_t;

    // ---------------------------------------------------------------------------
    // Group: Broadcast API
    // ---------------------------------------------------------------------------

    // Function: mute
    //
    // Mutes this broadcaster instance.
    //
    virtual function void
    mute();
        this.m_muted = 1;
    endfunction: mute

    // Function: muted
    //
    // Returns 1 if broadcast is muted or 0 otherwise.
    //
    virtual function bit
    muted();
        return this.m_muted;
    endfunction: muted

    // Function: unmute
    //
    // Unmutes this broadcaster instance.
    //
    virtual function void
    unmute();
        this.m_muted = 0;
    endfunction: unmute

    // Function: write
    //
    // Write a broadcast item to the broadcaster's fifo.
    //
    // Written items are broadcasted in-order during UVM run phase.
    //
    virtual function void
    write(T _item);
        this.m_fifo.write(_item);
    endfunction: write

    // Function: broadcast
    //
    // Broadcast an item through the <broadcast_port>.
    //
    // if _call_pre_post is set to 1, <pre_broadcast> and <post_broadcast> will
    // be called before and after writing the item to the <broadcast_port>.
    //
    // if _call_pre_post is set to 0, the calls to <pre_broadcast> and
    // <post_broadcast> are skipped.
    //
    virtual function void
    broadcast(ref T _item, input bit _call_pre_post=1);
        if (!this.muted()) begin
            if (_call_pre_post)
                this.pre_broadcast(_item);

            if (this.is_item_valid(_item))
                this.m_port.write(_item);

            if (_call_pre_post)
                this.post_broadcast(_item);
        end
    endfunction: broadcast

    // ---------------------------------------------------------------------------
    // Group: Provider-Subscriber API
    // ---------------------------------------------------------------------------

    // Function: providers
    //
    // Returns a list of providers registered to provide items to this
    // <broadcaster> instance.
    //
    virtual function uvm_port_list
    providers();
        this.m_fifo.analysis_export.get_comp().get_connected_to(providers);
    endfunction: providers

    // Function: subscribers
    //
    // Returns a list of subscribers registered to receive items from this
    // <broadcaster> instance.
    //
    virtual function uvm_port_list
    subscribers();
        this.m_port.get_provided_to(subscribers);
    endfunction: subscribers

    // Function: num_providers
    //
    // Returns the number of providers registered to provide items to this
    // broadcaster instance.
    //
    virtual function int
    num_providers();
        return this.m_fifo.analysis_export.size();
    endfunction: num_providers

    // Function: num_subscribers
    //
    // Returns the number of providers registered to receive items from this
    // broadcaster instance.
    //
    virtual function int
    num_subscribers();
        return this.m_port.size();
    endfunction: num_subscribers

    // Function: provide_to
    //
    // Registers _subscriber as a subscriber of this broadcaster instance and
    // appends it to this broadcaster's <subscribers> list.
    //
    virtual function void
    provide_to(uvm_port_t _subscriber);
        if (_subscriber != null)
            this.m_port.connect(_subscriber);
    endfunction: provide_to

    // Function: subscribe_to
    //
    // Registers _provider as a provider to this broadcaster instance and
    // appends it to this broadcaster's <providers> list.
    //
    virtual function void
    subscribe_to(uvm_port_t _provider);
        if (_provider != null && !_provider.is_imp())
            _provider.connect(this.m_fifo.analysis_export);
    endfunction: subscribe_to

    // Function: add_provider
    //
    // Synonym for <subscribe_to>.
    //
    virtual function void
    add_provider(uvm_port_t _provider);
        this.subscribe_to(_provider);
    endfunction: add_provider

    // Function: add_subscriber
    //
    // Synonym for <provide_to>.
    //
    virtual function void
    add_subscriber(uvm_port_t _subscriber);
        this.provide_to(_subscriber);
    endfunction: add_subscriber

    // ---------------------------------------------------------------------------
    // Group: User Definable Hooks
    // ---------------------------------------------------------------------------

    // Function: pre_broadcast
    //
    // User-definable hook method that is called right after an item was popped
    // from the fifo, and before the call to <is_item_valid> is made.
    //
    // A user may modify the and perform any operations required on the
    // broadcast item before it will be determined that it should be
    // skipped/broadcasted by the proceeding logic.
    //
    virtual function void
    pre_broadcast(ref T _broadcast);
    endfunction: pre_broadcast

    // Function: post_broadcast
    //
    // Default implementation of user-definable hook called after an item has
    // been broadcasted.
    //
    // This may be overriden by subclass incase a subclass broadcaster
    // implements some sort of states that requires updating after every
    // broadcast for example.
    //
    virtual function void
    post_broadcast(ref T _broadcast);
    endfunction: post_broadcast

    // Function: is_item_valid
    //
    // Default implementation of user-definable hook which tells the broadcaster
    // instance whether or not a broadcast item should be skipped instead of
    // being broadcasted.
    //
    // The current default implementation simply assures that the item is not
    // null, but a user may extend this method to perform additional checks if
    // needed.
    //
    virtual function bit
    is_item_valid(ref T _broadcast);
        return _broadcast != null;
    endfunction: is_item_valid

    // ---------------------------------------------------------------------------
    // Internal
    // ---------------------------------------------------------------------------

    // A handle to the process of the running run-phase broadcast.
    //
    protected std::process m_proc;

    // The current item being broadcasted.
    //
    protected T m_item;

    // Set and get this variable via the <mute>, <muted>, and <unmute> methods.
    //
    // When set, any items written to the fifo will not be broadcasted and will
    // instead be discarded from the fifo.
    //
    protected bit m_muted;

    // When set to 1, indicates the broadcast has started via a call to
    // <start()> task.
    //
    protected bit m_started;

    // A <uvm_analysis_port> from which items are broadcasted out.
    //
    protected uvm_analysis_port#(T) m_port;

    // A <uvm_tlm_analysis_fifo> for storing broadcast items sent to the
    // broadcaster via <write> that have not yet been broadcast.
    //
    protected uvm_tlm_analysis_fifo#(T) m_fifo;

    virtual function void
    init();
        this.m_proc = null;
        this.m_item = null;
        this.m_muted = 0;
        this.m_started = 0;
        this.m_fifo = new("m_fifo", this);
        this.m_port = new("m_port", this);
    endfunction: init

    virtual task
    run_phase(uvm_phase phase);
        super.run_phase(phase);
        this.start_broadcast();
    endtask: run_phase

    protected virtual task start_broadcast();
        if (this.broadcast_started())
            return;

        fork
            begin
                this.m_proc = std::process::self();
                forever begin
                    this.get_next_item(this.m_item);
                    this.broadcast(this.m_item);
                end
            end
        join_none
    endtask: start_broadcast

    protected virtual function
    broadcast_started();
        return this.m_proc != null;
    endfunction: broadcast_started

    protected virtual task
    suspend_broadcast();
        this.m_proc.suspend();
    endtask

    protected virtual task
    resume_broadcast();
        this.m_proc.resume();
    endtask: resume_broadcast

    protected virtual task
    kill_broadcast();
        this.m_proc.kill();
    endtask: kill_broadcast

    protected virtual task
    get_next_item(ref T _item);
        this.m_fifo.get(_item);
    endtask: get_next_item

endclass: broadcaster

`endif // NICE_COMPONENTS_BROADCASTER_SVH
