///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : 08_polymorph.sv
// Title       : Polymorphism
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Method access in subclass instancces copied to base class handles
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module counterclass8;
    
 virtual class counter;
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

  virtual function void next();
    $display("counter class");
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

  // extra method added for debug
  function string getval();
    return ($sformatf("%2d",count));
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

class timer;

  upcounter hours,minutes,seconds;

  function new(input int unsigned hr=0, min=0, sec=0);
    hours   = new(hr,23,0);
    minutes = new(min,59,0);
    seconds = new(sec,59,0);
  endfunction

  function void load(input int unsigned hr, min, sec);
    hours.load(hr);
    minutes.load(min);
    seconds.load(sec);
  endfunction

  function void showval();
    $display("Timer display is %2d:%2d:%2d", hours.count, minutes.count, seconds.count);
  endfunction

  function void next();
    seconds.next();
    if (seconds.carry == 1) begin
      minutes.next();
      if (minutes.carry == 1)
        hours.next();
    end
    showval();
  endfunction
  

  // extra method added for debug
  function string gettime();
    return ({hours.getval(),":",minutes.getval(),":",seconds.getval()});
  endfunction

endclass

counter c1;
upcounter u1, u2;

  initial
    begin
      // upcounter instance
      u1 = new(0,5,0);

     // copy upconter instance to counter handle
     c1 = u1;
 
     $display("call next from counter handle");
     c1.next();

     $display("cast fom counter handle to upcounter handle");
     if (! $cast(u2, c1)) $display("$cast failed");
     u2.next();

    end

endmodule
