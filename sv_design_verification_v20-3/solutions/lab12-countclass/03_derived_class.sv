///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : 03_derived.sv
// Title       : Class with inheritance
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Extended classes upcounter and downcounter
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////
 
module counterclass3;
    
 class counter;
  int count;
  
  function new(input int start);
    count = start;
  endfunction
  
  function int getcount();
    return (count);
  endfunction

  function void load(input int value);
    count = value;
  endfunction

endclass

class upcounter extends counter;

  function new(input int start);
    super.new(start);
  endfunction

  function void next();
    count++;
    $display("upcounter next %0d", count);
  endfunction

 endclass

class downcounter extends counter;

  function new(input int start);
    super.new(start);
  endfunction

  function void next();
    count--;
    $display("downcounter next %0d", count);
   endfunction
   
endclass   
    
int countval;

upcounter up1 = new(4);
downcounter down2 = new(0);


initial
begin

  countval = up1.getcount();
  $display("getcount from up1 constructor %0d", countval);

  up1.next();
  
  countval = down2.getcount();
  $display("getcount from down2 constructor %0d", countval);

  down2.next();  
  down2.next();
 
    
end

endmodule
