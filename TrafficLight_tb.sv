`timescale 1ns/1ps

module TrafficLight_tb();

//internal signals to connect to the module
logic clk;
logic reset;
logic TAORB;
logic [1:0] StreetA;
logic [1:0] StreetB;

//DUT
TrafficLight dut(
.clk(clk),
.reset(reset),
.TAORB(TAORB),
.StreetA(StreetA),
.StreetB(StreetB)
);

//Clock Generation
//Generates a 100MHz clock (10ns period)
always begin
	clk=1; #5;
	clk=0; #5;
end

//Test Stimulus and Self-Checking Logic
initial begin
// Initialize inputs
        $display("Starting Simulation...");
        reset = 1; 
        TAORB = 1; // Traffic is on Street A initially
        
        // Apply Reset 
        #22;  //slide example uses ~22ns for reset, that's why I chose it.
        reset = 0;
        $display("Reset released at 22ns.");

        // Check Initial State (S0)
        #10;
        if (StreetA !== 2'b10) 
            $display("Error: Street A should be Green (2'b10) in S0. Found: %b", StreetA);
        else 
            $display("Success: State S0 (Green A) verified.");

        // Transition to S1 (Yellow A)
        // Change TAORB to 0 to trigger state change
        TAORB = 0; 
        #10; // Wait for next clock edge
        if (StreetA !== 2'b01) 
            $display("Error: Street A should be Yellow (2'b01) in S1. Found: %b", StreetA);
        else 
            $display("Success: State S1 (Yellow A) verified.");

        // Timer Verification (5 cycles in S1)
        $display("Waiting for 5-cycle timer in S1...");
        #70; 
        
        // Transition to S2 (Green B)
        if (StreetB !== 2'b10) 
            $display("Error: Street B should be Green (2'b10) after timer. Found: %b", StreetB);
        else 
            $display("Success: State S2 (Green B) verified after timeout.");

        $display("Simulation finished. Please check errors above.");
        $stop; // Terminate simulation
    end

endmodule