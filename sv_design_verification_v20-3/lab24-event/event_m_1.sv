///////////////////////////////////////////////////////////////////////
// (c) Copyright 2007 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : event_m_1.sv
// Title       : Event Testcase 1
// Project     : SystemVerilog Verify Training
// Created     : 2007-10-01
// Description : Defines a race between a process triggering an event
//               and a process waiting for the event.
// Notes       :
//
///////////////////////////////////////////////////////////////////////

module event_m ;

  timeunit      1ns;
  timeprecision 1ns;

  event e1, e2 ;

  initial begin
      fork

        /////////////////////////////////////////////////////////////
        // TO DO PART 2 - REPLACE WITH WAIT FOR triggered PROPERTY //
        /////////////////////////////////////////////////////////////
        begin : WAITER_1
          $display ( "%m  waiting  event e1" ) ;
          @ e1
          $display ( "%m  received event e1" ) ;
        end  : WAITER_1

        ///////////////////////////////////////////////////////
        // TO DO PART 1 - REPLACE WITH NON-BLOCKING OPERATOR //
        ///////////////////////////////////////////////////////
        begin : EMITTER_1
          $display ( "%m emitting event e1" ) ;
          -> e1 ;
        end  : EMITTER_1

        ///////////////////////////////////////////////////////
        // TO DO PART 1 - REPLACE WITH NON-BLOCKING OPERATOR //
        ///////////////////////////////////////////////////////
        begin : EMITTER_2
          $display ( "%m emitting event e2" ) ;
          -> e2 ;
        end  : EMITTER_2

        /////////////////////////////////////////////////////////////
        // TO DO PART 2 - REPLACE WITH WAIT FOR triggered PROPERTY //
        /////////////////////////////////////////////////////////////
        begin : WAITER_2
          $display ( "%m  waiting  event e2" ) ;
          @ e2
          $display ( "%m  received event e2" ) ;
        end  : WAITER_2

      join_none
      #10ns;
      disable fork;
      $display("TEST COMPLETE");
      $finish(0);
    end

endmodule : event_m
