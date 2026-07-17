module tb;
  logic clk;
  logic reset;
  logic [3:0] timer;
  logic Traffic_Can_Flow_NS;
  logic Traffic_Can_Flow_EW;
  

  traffic_light dut(
    .clk(clk),
    .reset(reset),
    .timer(timer),
    .Traffic_Can_Flow_NS(Traffic_Can_Flow_NS),
    .Traffic_Can_Flow_EW(Traffic_Can_Flow_EW)
  );
  

  always #1 clk = ~clk;

  initial begin 
	reset = 0;
    clk = 0;
      $monitor("Time: %0d | reset: %b | timer: %d | clk: %b | NS: %p | EW: %p", 
                 $time, reset, timer, clk, dut.current_lightNS.name(), dut.current_lightEW.name());
    #1
    reset = 1;
    #100
    $finish;
  end
endmodule
