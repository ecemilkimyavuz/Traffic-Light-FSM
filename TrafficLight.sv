module TrafficLight(input logic clk, reset, TAORB,
						  output logic [1:0] StreetA, StreetB); //2 bit outputs in order to have more than 2 options

//state definitions using enum for readability						  
typedef enum logic [1:0] {S0, S1, S2, S3} statetype;
statetype state, nextstate;

//3-bit timer to support up to 5 time units
logic [2:0] timer; 

//state register
always_ff @(posedge clk, posedge reset) begin
	if(reset)  begin
				state <= S0;
				timer <= 3'b0;
				  end
	else		  begin
				  state <= nextstate;
				  //timer counter logic(counter increments for yellow lights)
				   if( state == S1 || state == S3 ) begin
				     if(timer < 3'd5) timer <= timer+1;
				     else             timer <= 3'b0; //reseting when it reaches 5 time unit
				                                    end
					else begin
						timer <= 3'b0; //ensure timer is cleared for green lights
	                 end
	           end
          end

			 				
//next state logic
always_comb begin
nextstate = state; //prevents latches
case(state)
S0:  begin			// S0: Street A Green. Move to S1 if no traffic on A (~TAORB)
    		if(~TAORB) nextstate = S1; 
			else      nextstate = S0;
	  end
S1:  begin			// S1: Street A Yellow. Move to S2 after 5-cycle delay
    		if(timer == 3'd5) nextstate = S2; 
			else      nextstate = S1;
	  end
S2:  begin			// S2: Street B Green. Move to S3 if traffic returns to A (TAORB)			
    		if(TAORB) nextstate = S3; 
			else      nextstate = S2;
	  end
S3:  begin			// S3: Street B Yellow. Move back to S0 after 5-cycle delay
    		if(timer == 3'd5) nextstate = S0; 
			else      nextstate = S3;
	  end
	 
	 default: nextstate = S0;
    endcase
end

//output logic
always_comb begin
	case(state)
		S0 : begin //LA Green , LB Red 
		 StreetA = 2'b10 ;
		 StreetB = 2'b00 ;
		 end 
		S1 : begin //LA Yellow , LB Red
		 StreetA = 2'b01 ;
		 StreetB = 2'b00 ;
		 end 
		S2 : begin //LA Red , LB Green
		 StreetA = 2'b00 ;
		 StreetB = 2'b10 ;
		 end 
		S3 : begin //LA Red , LB Yellow
		 StreetA = 2'b00 ;
		 StreetB = 2'b01 ;
		 end 
		default : begin
		 StreetA = 2'b00;
		 StreetB = 2'b00;
		end
	endcase
  end
endmodule