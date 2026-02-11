module Elevator_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [3:0] floor_req;
	reg emergency_stop;

	// Outputs
	wire move_up;
	wire move_down;
	wire motor_stop;
	wire [1:0] current_floor;

	// Instantiate the Unit Under Test (UUT)
	Elevator uut (
		.clk(clk), 
		.rst(rst), 
		.floor_req(floor_req), 
		.emergency_stop(emergency_stop), 
		.move_up(move_up), 
		.move_down(move_down), 
		.motor_stop(motor_stop), 
		.current_floor(current_floor)
	);

	initial
	 clk = 1'b0;
	always #5 clk = ~clk;
	
	initial 
	begin
	
		clk = 0;
		rst = 1;
		floor_req = 4'b0000;
		emergency_stop = 0;

		#20;
      
		rst = 0;
		
		// Floor 2
		#10;
		floor_req = 4'b0100;
		
		// Clear Request
		#40;
		floor_req = 4'b0000;
		
		
		// Floor 0 
		#20;
		floor_req = 4'b0001;
		
		// Multiple Requests
		#20;
		floor_req = 4'b1010;
		
		#10;
		floor_req = 4'b0000;
		
		#20;
		
		
		emergency_stop = 1;
		
		#30;
		emergency_stop = 0;
		
		#50;
		//$finish;
	end

	initial
		 $monitor($time,"clk=%0b,rst=%0b,floor_req=%0b,emergency_stop=%0b,move_up=%0b,move_down=%0b,motor_stop=%0b,current_floor=%0b", clk,rst,floor_req,emergency_stop,move_up,move_down,motor_stop,current_floor);
		 
	      
endmodule

