///////////////////////////////////////////////////////////////////////
// (c) Copyright 2007 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mailbox_consumer_m.sv
// Title       : Mailbox Transaction Consumer
// Project     : SystemVerilog Verify Training
// Created     : 2013-4-8
// Description : Demonstrates the use of a mailbox to synchronize
//               between producers and consumers of transactions.
// Notes       : This unit consumes transactions. Its "dispatch_blk"
//               continually gets transactions from the interface
//               into a base class handle and queues it to the
//               appropriate consumer block.
// Changes     : 2009-10-24 mikep Parameterized mailboxes.
//
///////////////////////////////////////////////////////////////////////

module consumer_m
#(
  // The transaction consumer service time is a uniform distribution
  parameter int unsigned consume_time_min=5, consume_time_max=15
 )
 (
  interface intfc // Mailbox is in interface
 );

  timeunit       1ns;
  timeprecision 10ps;

  import ex_trans_pkg::*;

  mailbox #(my_tr_base_c) config_box = new ; // Queue for configurations
  mailbox #(my_tr_base_c) synch_box  = new ; // Queue for synchronizations
  mailbox #(my_tr_base_c) comms_box  = new ; // Queue for communications

  // Helper task does the actual consumption
  task automatic consume(ref my_tr_base_c trans) ;
    $display( "%t: Begin consuming transaction %d of type %s",
              $stime, trans.id, trans.get_type() ) ;
    // Simulate some sort of consumption occurring
    #($urandom_range( consume_time_max,consume_time_min) ) ;
    $display( "%t: End   consuming transaction %d of type %s",
              $stime, trans.id, trans.get_type() ) ;
  endtask : consume

  // Consume configuration transactions
  always
    begin : consume_config
      my_tr_base_c trans ;
      config_box.get(trans) ;
      consume(trans) ;
    end : consume_config

  // Consume synchronization transactions
  always
    begin : consume_synch
      my_tr_base_c trans ;
      synch_box.get(trans) ;
      consume(trans) ;
    end : consume_synch

  // Consume communications transactions
  always
    begin : consume_comms
      my_tr_base_c trans ;
      comms_box.get(trans) ;
      consume(trans) ;
    end : consume_comms

  // Retrieve and dispatch transactions
  always
    begin : dispatch_blk
      my_tr_base_c trans ;
      intfc.get(trans) ;
      case ( trans.get_type() )
        "my_tr_config_c" : config_box.put(trans) ;
        "my_tr_synch_c"  : synch_box.put(trans) ;
        "my_tr_comms_c"  : comms_box.put(trans) ;
      endcase
    end : dispatch_blk

endmodule : consumer_m
