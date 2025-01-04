//-----------------------------------------------------------------------------
// Project       : Callisto
//-----------------------------------------------------------------------------
// File          : nice_seq.svh
// Author        : skimhi
// Created       : Mon Sep 2024, 03:05:24
// Last modified : Mon Sep 2024, 03:05:24
//
//-----------------------------------------------------------------------------
// Copyright (c) Speedata.
//------------------------------------------------------------------------------
// Modification history:
// Mon Sep 2024, 03:05:24
//-----------------------------------------------------------------------------

`ifndef NICE_SEQ_SVH
`define NICE_SEQ_SVH

`include "nice_defines.svh"
`nice_include_dependencies


// Package: seq
//
// Contains various utility classes based off on one of UVM's sequence,
// sequencer, sequence_item class family.
//
package seq;
    `nice_import_dependencies

    // Type: chained_sequencer
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
    typedef class chained_sequencer;

    // Type: chaining_sequence
    //
    // A chaining sequence is a sequence running on a <chained_sequencer>.
    //
    // See documentation of <chained_sequencer> for more info.
    //
    typedef class chaining_sequence;

    `include "seq/nice_chained_sequencer.svh"
    `include "seq/nice_chaining_sequence.svh"
endpackage: seq

`endif // NICE_SEQ_SVH
