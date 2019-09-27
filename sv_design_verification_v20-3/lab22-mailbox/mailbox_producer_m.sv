///////////////////////////////////////////////////////////////////////
// (c) Copyright 2007 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mailbox_producer_m.sv
// Title       : Mailbox Transaction Producer
// Project     : SystemVerilog Verify Training
// Created     : 2013-4-8
// Description : Demonstrates the use of a mailbox to synchronize
//               between producers and consumers of transactions.
// Notes       : This unit randomly produces transactions and puts them
//               in the mailbox.
//
///////////////////////////////////////////////////////////////////////

module producer_m
#(
  parameter int unsigned number_of_transactions=20, // How long to sim
  parameter int unsigned produce_time_ave=10 // Interarrival mean
 )
 (
  interface intfc // Mailbox is in interface
 );

  timeunit       1ns;
  timeprecision 10ps;

  import ex_trans_pkg::*;

  initial
    begin : producer_blk

      my_tr_base_c   my_tr_base   ; // A base transaction class handle
      my_tr_config_c my_tr_config ; // A configuration transaction handle
      my_tr_synch_c  my_tr_synch  ; // A synchronization transaction handle
      my_tr_comms_c  my_tr_comms  ; // A communications transaction handle

      $timeformat(-9,0,"",3); // change as needed

      for ( int unsigned i=1; i<=number_of_transactions; ++i )
        begin

          // Wait an exponentially distributed amount of time
          // to approximates a Poisson arrival process
          int seed; seed=$urandom; // stabilize an unstable RNG
          #($dist_exponential(seed, produce_time_ave) ) ;

          // Produce a random transaction (mostly comms) and mail it
          randsequence(main)
            main: A:=1 | B:=2 | C:=7 ;
            A: {my_tr_config = new(1);
                $display( "%t:       Produced  transaction %d of type %s",
                          $stime,my_tr_config.id,my_tr_config.get_type() ) ;
                my_tr_base = my_tr_config;
                intfc.put(my_tr_base) ;
               };
            B: {my_tr_synch  = new(2);
                $display( "%t:       Produced  transaction %d of type %s",
                          $stime,my_tr_synch.id,my_tr_synch.get_type() ) ;
                my_tr_base = my_tr_synch;
                intfc.put(my_tr_base) ;
               };
            C: {my_tr_comms  = new(3);
                $display( "%t:       Produced  transaction %d of type %s",
                          $stime,my_tr_comms.id,my_tr_comms.get_type() ) ;
                my_tr_base = my_tr_comms;
                intfc.put(my_tr_base) ;
               };
          endsequence

        end // for
    end : producer_blk

endmodule : producer_m
