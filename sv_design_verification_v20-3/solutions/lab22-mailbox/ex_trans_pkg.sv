///////////////////////////////////////////////////////////////////////
// (c) Copyright 2007 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : ex_trans_pkg.sv
// Title       : Transaction Class Package
// Project     : SystemVerilog Verify Training
// Created     : 2013-4-8
// Description : Declares transaction classes for mailbox lab.
// Notes       :
//
///////////////////////////////////////////////////////////////////////

package ex_trans_pkg ;

  // Base transaction type

  virtual class my_tr_base_c ;
    int unsigned id   ; // transaction number
    int unsigned addr ; // unused property
    int unsigned size ; // unused property
    protected static int unsigned cnt=0 ;
    function new ;
      id = ++cnt ;
    endfunction
    virtual function string get_type ;
    endfunction
  endclass


  // Derived configuration transaction

  class my_tr_config_c extends my_tr_base_c ;
    function new(int unsigned config) ;
      super.new() ;
      this.config = config ;
    endfunction
    function string get_type ;
      return "my_tr_config_c" ;
    endfunction
    local int unsigned config ; // meaningless incremental property
  endclass


  // Derived synchronization transaction

  class my_tr_synch_c extends my_tr_base_c ;
    function new(int unsigned synch) ;
      super.new() ;
      this.synch = synch ;
    endfunction
    function string get_type ;
      return "my_tr_synch_c" ;
    endfunction
    local int unsigned synch ; // meaningless incremental property
  endclass


  // Derived communications transaction

  class my_tr_comms_c extends my_tr_base_c ;
    function new(int unsigned comms) ;
      super.new() ;
      this.comms = comms ;
    endfunction
    function string get_type ;
      return "my_tr_comms_c" ;
    endfunction
    local int unsigned comms ; // meaningless incremental property
  endclass

endpackage : ex_trans_pkg
