////////////////////////////////////////////////////////////////////////
// (c) Copyright 2007 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mailbox_if.sv
// Title       : Mailbox Transaction Interface
// Project     : SystemVerilog Verify Training
// Created     : 2013-4-8
// Description : Demonstrates the use of a mailbox to synchronize
//               between producers and consumers of transactions.
// Notes       : This unit is a "wrapper" around a mailbox. It declares
//               and constructs the mailbox and provides mailbox-like
//               methods that users can call in lieu of the mailbox.
//               When IUS supports hierarchical references to mailboxes
//               we will simply instantiate a mailbox at the top level.
//
///////////////////////////////////////////////////////////////////////

interface mailbox_if ;

  timeunit       1ns;
  timeprecision 10ps;

  import ex_trans_pkg::*;

  /////////////////////////////////////////////////////////////////////////////
  // TO DO: DECLARE AND CONSTRUCT THE mbox UNLIMITED UNPARAMETERIZED MAILBOX //
  /////////////////////////////////////////////////////////////////////////////



  //////////////////////////////////////////////////////////////////////////
  // IMPLEMENT THIS FUNCTION TO RETURN THE NUMBER OF ITEMS IN THE MAILBOX //
  //////////////////////////////////////////////////////////////////////////

  function int num() ;

  endfunction : num

  /////////////////////////////////////////////////////////////////////////////
  // This is the users "blocking put" interface to the mailbox. We need to   //
  // pass the base transaction class handle by reference as passing by value //
  // copies only the base parts. Having a reference argument means we must   //
  // make the task automatic, and as the task consumes time and is used by   //
  // multiple callers, we need to make it automatic anyway. This task takes  //
  // the incoming transaction, determines what kind it is, dynamically casts //
  // it to its particular kind, and puts it in the mailbox.                  //
  /////////////////////////////////////////////////////////////////////////////
  task automatic put(ref my_tr_base_c my_tr_base) ;
    my_tr_config_c my_tr_config ;
    my_tr_synch_c  my_tr_synch  ;
    my_tr_comms_c  my_tr_comms  ;
         if ( my_tr_base.get_type() == "my_tr_config_c" )
      begin // post the configuration transaction
        if ( $cast(my_tr_config, my_tr_base) == 0 )
          begin $display("Cannot cast trans class"); $finish(0); end
        ////////////////////////////////////////////////////////////////////
        // TO DO: PUT CONFIGURATION TRANSACTION IN THE MAILBOX (BLOCKING) //
        ////////////////////////////////////////////////////////////////////

      end
    else if ( my_tr_base.get_type() == "my_tr_synch_c" )
      begin // post the synchronization transaction
        if ( $cast(my_tr_synch, my_tr_base) == 0 )
          begin $display("Cannot cast trans class"); $finish(0); end
        //////////////////////////////////////////////////////////////////////
        // TO DO: PUT SYNCHRONIZATION TRANSACTION IN THE MAILBOX (BLOCKING) //
        //////////////////////////////////////////////////////////////////////

      end
    else if ( my_tr_base.get_type() == "my_tr_comms_c" )
      begin // post the communications transaction
        if ( $cast(my_tr_comms, my_tr_base) == 0 )
          begin $display("Cannot cast trans class"); $finish(0); end
        /////////////////////////////////////////////////////////////////////
        // TO DO: PUT COMMUNICATIONS TRANSACTION IN THE MAILBOX (BLOCKING) //
        /////////////////////////////////////////////////////////////////////

      end
  endtask : put

  /////////////////////////////////////////////////////////////////////////////
  // This is the users "non-blocking put" interface to the mailbox.          //
  // It is much like the blocking put but of course does not block           //
  // and returns the status.                                                 //
  /////////////////////////////////////////////////////////////////////////////
  function automatic int try_put(ref my_tr_base_c my_tr_base) ;
    my_tr_config_c my_tr_config ;
    my_tr_synch_c  my_tr_synch  ;
    my_tr_comms_c  my_tr_comms  ;
         if ( my_tr_base.get_type() == "my_tr_config_c" )
      begin // post the configuration transaction
        if ( $cast(my_tr_config, my_tr_base) == 0 )
          begin $display("Cannot cast trans class"); $finish(0); end
        ////////////////////////////////////////////////////////////////////
        // TO DO: PUT CONFIGURATION TRANSACTION IN MAILBOX (NON-BLOCKING) //
        //        RETURN STATUS (WAS IT SUCCESSFUL)                       //
        ////////////////////////////////////////////////////////////////////

      end
    else if ( my_tr_base.get_type() == "my_tr_synch_c" )
      begin // post the synchronization transaction
        if ( $cast(my_tr_synch, my_tr_base) == 0 )
          begin $display("Cannot cast trans class"); $finish(0); end
        //////////////////////////////////////////////////////////////////////
        // TO DO: PUT SYNCHRONIZATION TRANSACTION IN MAILBOX (NON-BLOCKING) //
        //        RETURN STATUS (WAS IT SUCCESSFUL)                         //
        //////////////////////////////////////////////////////////////////////

      end
    else if ( my_tr_base.get_type() == "my_tr_comms_c" )
      begin // post the communications transaction
        if ( $cast(my_tr_comms, my_tr_base) == 0 )
          begin $display("Cannot cast trans class"); $finish(0); end
        /////////////////////////////////////////////////////////////////////
        // TO DO: PUT COMMUNICATIONS TRANSACTION IN MAILBOX (NON-BLOCKING) //
        //        RETURN STATUS (WAS IT SUCCESSFUL)                        //
        /////////////////////////////////////////////////////////////////////

      end
  endfunction : try_put


  ////////////////////////////////////////////////////////////////////////
  // IMPLEMENT THIS FUNCTION TO GET TRANSACTION FROM MAILBOX (BLOCKING) //
  ////////////////////////////////////////////////////////////////////////

  task automatic get(ref my_tr_base_c my_tr_base) ;

  endtask : get


  ////////////////////////////////////////////////////////////////////////////
  // IMPLEMENT THIS FUNCTION TO GET TRANSACTION FROM MAILBOX (NON-BLOCKING) //
  // RETURN STATUS (WAS IT SUCCESSFUL)                                      //
  ////////////////////////////////////////////////////////////////////////////

  function automatic int try_get(ref my_tr_base_c my_tr_base) ;

  endfunction : try_get


  /////////////////////////////////////////////////////////////////////
  // IMPLEMENT THIS TASK TO PEEK AT A MAILBOX TRANSACTION (BLOCKING) //
  /////////////////////////////////////////////////////////////////////

  task automatic peek(ref my_tr_base_c my_tr_base) ;

  endtask : peek


  /////////////////////////////////////////////////////////////////////////////
  // IMPLEMENT THIS FUNCTION TO PEEK AT A MAILBOX TRANSACTION (NON-BLOCKING) //
  // RETURN STATUS (WAS IT SUCCESSFUL)                                       //
  /////////////////////////////////////////////////////////////////////////////

  function automatic int try_peek(ref my_tr_base_c my_tr_base) ;

  endfunction : try_peek

  modport put_port (import num, put, try_put);
  modport get_port (import num, get, try_get, peek, try_peek);

endinterface : mailbox_if
