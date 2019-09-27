///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : 04_counter_limits.sv
// Title       : Classes with count limits
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Max and min limits added to count class for upcounter and downcounter
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module counterclass4;
    
 class counter;
  int count;
  int max, min;
  
  function new(input int start, upper, lower);
    check_limits(upper, lower);
    check_set(start);
  endfunction

  function void check_limits (input int upper, lower);
    if (lower > upper) begin
      $display("lower bound %0d > upper bound %0d - bounds swapped", lower, upper);
      max = lower;
      min = upper;
      end
    else begin
      max = upper;
      min = lower;
    end
  endfunction

  function void check_set(input int set);
    if ((set < min) || (set > max))
      begin
      $display("count set value %0d outside bounds %0d to %0d - set to min", set, min, max);
      count = min;
      end
    else
      count = set;
  endfunction
  
  function int getcount();
    return (count);
  endfunction

  function void load(input int value);
    check_set(value);
  endfunction

endclass

class upcounter extends counter;

  function new(input int start, upper, lower);
    super.new(start, upper, lower);
  endfunction

  function void next();
    if (count == max)
      count = min;
    else
      count++;
    $display("upcounter next %0d", count);
  endfunction

endclass

class downcounter extends counter;

  function new(input int start, upper, lower);
    super.new(start, upper, lower);
  endfunction

  function void next();
    if (count == min)
      count = max;
    else
      count--;
    $display("downcounter next %0d", count);
   endfunction
   
endclass   
    
int countval;

upcounter up1 = new(4, 3, 1);  // start outside bounds
downcounter down2 = new(4, 2, 5);  // upper < lower
upcounter up3 = new(2, 3, 0);
downcounter down4 = new(2, 3, 0);


initial
begin

  up3.next();
  up3.next();
  up3.next();
  down4.next();  
  down4.next();
  down4.next();
    
end

endmodule
