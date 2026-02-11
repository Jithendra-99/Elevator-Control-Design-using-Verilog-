module Elevator(clk,rst,floor_req,emergency_stop,move_up,move_down,motor_stop,current_floor);
    input clk,rst;
	 input [3:0] floor_req;
	 input emergency_stop;
	 output reg move_up,move_down,motor_stop;
	 output reg [1:0] current_floor;
	 
	 parameter idle = 2'b00,
				  up_move = 2'b01,
				  down_move = 2'b10,
				  emergency = 2'b11;
				  
	 reg [1:0] current_state,next_state;
	 reg [1:0] target_floor;
	 
	 
	 always@(*)
	 begin
		target_floor = current_floor;
		
		if(floor_req[0])
			target_floor = 2'd0;
		else if(floor_req[1])
			target_floor = 2'd1;
		else if(floor_req[2])
			target_floor = 2'd2;
		else if(floor_req[3])
			target_floor = 2'd3;
	 end
	 
	 
	 
	 // Present State Logic
	 always@(posedge clk)
	 begin
		if(rst)
			current_state <= idle;
		else
			current_state <= next_state;
	 end
	 
	 
	 // Floor Tracking
	 always@(posedge clk or posedge rst)
	 begin
		if(rst)
			current_floor <= 2'd0;
		else if(current_state == up_move)
			current_floor <= current_floor + 1'b1;
		else if(current_state <= down_move)
			current_floor <= current_floor - 1'b1;
		else
			current_floor <= current_floor;
	end
	
	// Next State Logic
	always@(*)
	begin
		next_state = current_state;
		
		if(emergency_stop)
		 begin
			next_state = emergency;
		 end
		else
		 begin
			case(current_state)
				idle : begin
						  if(target_floor > current_floor)
							next_state = up_move;
						  else if(target_floor < current_floor)
						   next_state = down_move;
						 end
				up_move : begin
							  if(current_floor == target_floor)
							   next_state = idle;
							  else
							   next_state = up_move;
							 end
				down_move : begin
								 if(current_floor == target_floor)
								  next_state = idle;
								 else
								  next_state = down_move;
								end
				emergency : begin
								 if(!emergency_stop)
									next_state = idle;
								 else
									next_state = emergency;
								end
				default : next_state = idle;
			endcase
		end
	end
							 
	// Output Logic
	always@(*)
	begin
		move_up = 1'b0;
		move_down = 1'b0;
		motor_stop = 1'b0;
		
		case(current_state)
			up_move : move_up = 1'b1;
			down_move : move_down = 1'b1;
			emergency : motor_stop = 1'b1;
			idle : motor_stop = 1'b1;
		endcase
	end
				
endmodule
