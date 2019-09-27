///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : 02_constructor.sv
// Title       : Class with constructor
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Simple counter class with explcit constructor
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module counterclass2;
    
 class counter;
  int count;
  
  function new(input int start=0);
    count = start;
  endfunction
  
  function int getcount();
    return (count);
  endfunction

  function void load(input int value);
    count = value;
  endfunction
   
endclass   
    
int countval;

counter c1 = new(6);

initial
begin

  countval = c1.getcount();
  $display("getcount from constructor %0d", countval);
  c1.load(3); 
  countval = c1.getcount();
  $display("getcount from load %0d", countval);
 
    
end

endmodule
