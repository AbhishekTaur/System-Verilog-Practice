///////////////////////////////////////////////////////////////////////
// (c) Copyright 2007 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : semaphore_m.sv
// Title       : Semaphore Testcase
// Project     : SystemVerilog Verify Training
// Created     : 2013-4-8
// Description : Demonstrates the use of a semaphore to control access
//               by two processes to a single resource.
// Notes       : 2008-04-23 mikep Terminate test upon failure.
//
///////////////////////////////////////////////////////////////////////

module semaphore_m ;

  timeunit 1ns;
  timeprecision 1ns;

  localparam  int unsigned num_users = 2 ; // Up to 10 concurrent processes
  // Random distributions for inter-arrival time and service time
  //When IUS supports unpacked array parameters uncomment "localparam"
/*localparam*/int unsigned arrival_time_min[num_users]='{default:1};
/*localparam*/int unsigned arrival_time_max[num_users]='{default:7};
/*localparam*/int unsigned service_time_min[num_users]='{default:1};
/*localparam*/int unsigned service_time_max[num_users]='{default:9};
  localparam  int unsigned simulation_time_max = 100 ; // How long to sim
  var bit running = 1 ; // Flag to disable concurrent processes at sim end

  /////////////////////////////////////////////////////////////////
  // TO DO - INSTANTIATE A SEMAPHORE AND INITIALIZE WITH ONE KEY //
  /////////////////////////////////////////////////////////////////



  // Model shared resource
  // Static task consumes simulation time and has a shared variable
  task limited_resource
  (
    input int unsigned service_time,
    inout int unsigned clobberable_var
  );
    #service_time;
  endtask


  // Model user process
  // Automatic task randomly uses resource for random amount of time
  task automatic user
  (
    input string name,
    input int unsigned arrival_time_min, arrival_time_max,
    input int unsigned service_time_min, service_time_max 
  ) ;
    while (running)
      begin
        bit blocking;
        int unsigned arrival_time, service_time;
        int unsigned clobberable_var, clobberable_var_orig;
        bit success;
        success = randomize(blocking, arrival_time, service_time, clobberable_var) with
        {
         arrival_time_min <= arrival_time && arrival_time <= arrival_time_max;
         service_time_min <= service_time && service_time <= service_time_max;
        };
        if (!success) begin $display("randomize failed"); $finish; end
        #arrival_time;
        $display("%t: %s get key %s", $time, name, blocking?"blocking":"nonblock");

        if (blocking)
          //////////////////////////////////////////////////
          // TO DO - GET SEMAPHORE KEY (USE BLOCKING GET) //
          //////////////////////////////////////////////////

        else
          //////////////////////////////////////////////////////////////////
          // TO DO - GET SEMAPHORE KEY (RETRY NON-BLOCKING GET EVERY 1NS) //
          //////////////////////////////////////////////////////////////////


        $display("%t: %s got key", $time, name);
        clobberable_var_orig = clobberable_var;
        limited_resource(service_time, clobberable_var);
        if (clobberable_var !== clobberable_var_orig) begin
            $display("%t: %s clobberable_var got clobbered!", $time, name);
            $display("TEST FAILED");
            $finish(0);
          end
        $display("%t: %s put key", $time, name);

        ////////////////////////////////////
        // TO DO - PUT SEMAPHORE KEY BACK //
        ////////////////////////////////////


       end
  endtask : user


  // Simulate
  initial
    begin
      $timeformat ( -9, 0, "ns", 5 ) ;

      //////////////////////////////////////////////////////////////////////
      // TO DO - TERMINATE SIMULATION IF SEMAPHORE OBJECT NOT CONSTRUCTED //
      //////////////////////////////////////////////////////////////////////





      for ( int unsigned i=0, string name="user0"; i<num_users; ++i, ++name[4] )
        begin
          fork user( name, arrival_time_min[i], arrival_time_max[i],
                           service_time_min[i], service_time_max[i] ) ;
          join_none
          #1ns ; // wait for process to start up
        end

      #simulation_time_max running <= 0 ; // After delay schedule shutdown
      wait fork ; // wait for shutdown

      $display("TEST COMPLETE");
      $finish(0);
    end

endmodule : semaphore_m
