module traffic_light (
    input  logic clk,
    input  logic reset,
    output logic [3:0] timer,
    output logic Traffic_Can_Flow_NS,
    output logic Traffic_Can_Flow_EW
);


    typedef enum { Green, Yellow, Red } light; 
    light current_lightNS, next_lightNS;
    light current_lightEW, next_lightEW;

    always_comb begin 
        // Default assignments to prevent latches
        next_lightNS = current_lightNS;
        next_lightEW = current_lightEW;
        
        // Green for 2 clks, Yellow for 1 clk, and Red for 3 clks
        if (timer == 4'd2 && current_lightNS == Green) begin
            next_lightNS = current_lightNS.next();
        end
        if (timer == 4'd3 && current_lightNS == Yellow) begin
            next_lightNS = current_lightNS.next();
        end   
        if (timer == 4'd6 && current_lightNS == Red) begin
            next_lightNS = current_lightNS.next();
        end
        
        // EW State transitions
        if (timer == 4'd3 && current_lightEW == Red) begin
            next_lightEW = current_lightEW.next();
        end
        if (timer == 4'd5 && current_lightEW == Green) begin
            next_lightEW = current_lightEW.next();
        end   
        if (timer == 4'd6 && current_lightEW == Yellow) begin
            next_lightEW = current_lightEW.next();
        end
        
        // Output Logic
        if (current_lightNS == Green || current_lightNS == Yellow)
            Traffic_Can_Flow_NS = 1;
        else
            Traffic_Can_Flow_NS = 0;
        
        if (current_lightEW == Green || current_lightEW == Yellow)
            Traffic_Can_Flow_EW = 1;
        else
            Traffic_Can_Flow_EW = 0;
    end

    // Sequential block handles state updates and the timer directly
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            timer           <= 0;
            current_lightNS <= Green;
            current_lightEW <= Red;
        end else begin
            if (timer == 4'd6) begin
                timer <= 0;
            end else begin
                timer <= timer + 1;
            end
            current_lightNS <= next_lightNS;
            current_lightEW <= next_lightEW;
        end
    end

endmodule
