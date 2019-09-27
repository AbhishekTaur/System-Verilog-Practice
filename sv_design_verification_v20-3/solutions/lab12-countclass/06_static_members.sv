///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : 06_static_members.sv
// Title       : Classes with static members
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Static properties and methods added to extended classes
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module counterclass6;
    
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

  static int no_up;

  function new(input int start, upper, lower);
    super.new(start, upper, lower);
    no_up++;
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

  static function int number_of();
    return (no_up);
  endfunction

endclass

class downcounter extends counter;

  logic borrow;

  static int no_down;

  function new(input int start, upper, lower);
    super.new(start, upper, lower);
    no_down++;
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

  static function int number_of();
    return (no_down);
  endfunction
   
endclass   
    
int countval;

upcounter up1 = new(4, 3, 1);  // start outside bounds
downcounter down2 = new(4, 2, 5);  // upper < lower
upcounter up3 = new(2, 3, 0);
downcounter down4 = new(2, 3, 0);


initial
begin

  countval = upcounter::number_of();
  $display("number of upcounters is %d", countval);
  countval = downcounter::number_of();
  $display("number of downcounters is %d", countval);
  up1 = new (0, 5, 0);
  down2 = new(5, 5, 0);
  countval = upcounter::number_of();
  $display("number of upcounters is %d", countval);
  countval = downcounter::number_of();
  $display("number of downcounters is %d", countval);
  up3 = null;
  down4 = null;
  countval = upcounter::number_of();
  $display("number of upcounters is %d", countval);
  countval = downcounter::number_of();
  $display("number of downcounters is %d", countval);

    
end

endmodule
