///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : counter.sv
// Title       : Simple class
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Simple counter class
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module counterclass;

	class counter;
		int count;
		int max;
		int min;

		function new(int count = 0, int min = 0, int max = 0);
			check_limit(min, max);
			check_set(count);
			$display("Count value set to: %d", this.count);
		endfunction: new
		
		function void load(int count);
			check_set(count);
		endfunction : load

		function int getcount();
			return count;
		endfunction: getcount

		function void check_limit(int num1, int num2);
			if(num1 >= num2) begin
				this.max = num1;
				this.min = num2;
			end
			else begin
				this.max = num2;
				this.min = num1;
			end
		endfunction: check_limit

		function void check_set(int set);

			if(set > max || set < min) begin
				this.count = min;
				$display("The value %d is not between min: %d and max: %d", set, min, max);
			end
			else begin
				this.count = set;
			end
		endfunction: check_set

	endclass : counter    

	class upcounter extends counter;

		bit carry;
		static int upinstance;

		function new(int count, int min, int max);
			super.new(count, min, max);
			carry = 0;
			upinstance++;
		endfunction: new

		function void next();
			if(count < max) begin
				count = count + 1;
			end
			else begin
				count = min;
				carry = 1;
			end
			$display("Upcounter value: %d", count);
		endfunction: next

		static function int getUpInstance();
			return upinstance;
		endfunction : getUpInstance

		function bit getCarry();
			return carry;
		endfunction : getCarry

	endclass: upcounter

	class downcounter extends counter;
		
		bit borrow;
		static int downinstance;

		function new(int count, int min, int max);
			super.new(count, min, max);
			borrow = 0;
			downinstance++;
		endfunction : new

		function void next();
			if(count > min) begin
				count = count - 1;
			end
			else begin
				count = max;
				borrow = 1;
			end
			$display("Downcounter value: %d", count);
		endfunction : next

		static function int getDownInstance();
			return downinstance;
		endfunction : getDownInstance

		function bit getBorrow();
			return borrow;
		endfunction : getBorrow

	endclass : downcounter

	class timer;

		upcounter hours;
		upcounter minutes;
		upcounter seconds;

		function new(int hours = 0, int minutes = 0, int seconds = 0);
			this.hours = new(hours, 0, 23);
			this.minutes = new(minutes, 0, 59);
			this.seconds = new(seconds, 0, 59);
		endfunction : new

		function void load(int hours, int minutes, int seconds);
			this.hours.load(hours);
			this.minutes.load(minutes);
			this.seconds.load(seconds);
		endfunction : load

		function void showval();
			$display("Hours: %d, Minutes: %d, Seconds: %d", hours.getcount(), minutes.getcount(), seconds.getcount());
		endfunction : showval

		function void next();
			seconds.next();
			if(seconds.getCarry()) begin
				minutes.next();
			end
			if(minutes.getCarry()) begin
				hours.next();	
			end

			showval();
		endfunction : next

	endclass : timer

	counter base = new(500, 400, 600);
	upcounter upcount = new(200, 400, 600);
	downcounter downcount = new(50, 100, 300);
	timer time_now= new(0,0,59);

	initial begin
		
		base.load(100);
		$display("count = %d", base.getcount());

		
		upcount.next();
		downcount.next();
		upcount.load(600);
		upcount.next();
		upcount.load(599);
		upcount.next();
		$display("upcounter instances: %d", upcounter::getUpInstance());
		$display("downcounter instances: %d", downcount.getDownInstance());
		time_now.next();
		time_now.load(0,59,59);
		time_now.next();

		$finish;
	end
endmodule
