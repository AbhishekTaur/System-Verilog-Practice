///////////////////////////////////////////////////////////////////////
// (c) Copyright 2007 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mailbox_top_m.sv
// Title       : Mailbox Testcase Top Wrapper
// Project     : SystemVerilog Verify Training
// Created     : 2013-4-8
// Description : Demonstrates the use of a mailbox to synchronize
//               between producers and consumers of transactions.
// Notes       : The top unit instantiates and connects the poducer,
//               interface, and consumer.
//
///////////////////////////////////////////////////////////////////////

module top_m;

  timeunit       1ns;
  timeprecision 10ps;

  localparam int unsigned number_of_transactions=20 ; // How long to sim
  // Producer should run slightly slower than consumers or FIFO blows up
  // Producer distribution is exponential to approximate Poisson arrival
  localparam int unsigned produce_time_ave=10 ;
  // Service time is uniformly distributed
  localparam int unsigned consume_time_min=5, consume_time_max=15 ;

  mailbox_if intfc() ;

  producer_m
 #(
    .number_of_transactions(number_of_transactions),
    .produce_time_ave(produce_time_ave)
  )
    producer
  (
    .intfc(intfc.put_port)
  ) ;

  consumer_m
 #(
    .consume_time_min(consume_time_min),
    .consume_time_max(consume_time_max)
  )
    consumer
  (
    .intfc(intfc.get_port)
  ) ;

endmodule : top_m
