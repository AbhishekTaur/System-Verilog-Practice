///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : 05_roll_over_under.sv
// Title       : Classes with count limits and roll over/under indication
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Properties added to extended classes
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module counterclass5;
    
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

  logic carry;

  function new(input int start, upper, lower);
    super.new(start, upper, lower);
  endfunction

  function void next();
    if (count == max) begin
      carry = 1;
      count = min;
    end
    else begin
      carry = 0;
      count++;
    end
    $display("upcounter next %0d %0d", count, carry);
  endfunction

endclass

class downcounter extends counter;

  logic borrow;

  function new(input int start, upper, lower);
    super.new(start, upper, lower);
  endfunction

  function void next();
    if (count == min) begin
      borrow = 1;
      count = max;
    end
    else begin
      borrow = 0;
      count--;
    end
    $display("downcounter next %0d %0d", count, borrow);
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
  down4.next();
    
end

endmodule
