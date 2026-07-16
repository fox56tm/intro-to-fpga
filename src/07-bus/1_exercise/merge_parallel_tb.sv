`timescale 1ns / 1ps
module merge_parallel_tb;

    localparam int IN_WIDTH_1 = 3;
    localparam int IN_WIDTH_2 = 8;
    localparam int OUT_WIDTH  = 11;

    logic clk;
    logic aresetn;

    // Input from master 1
    logic s_valid_1;
    logic s_ready_1;
    logic [IN_WIDTH_1-1:0] s_data_1;

    // Input from master 2
    logic s_valid_2;
    logic s_ready_2;
    logic [IN_WIDTH_2-1:0] s_data_2;

    // Output to slave
    logic m_valid;
    logic m_ready;
    logic [OUT_WIDTH-1:0] m_data;

    merge_parallel #(
      .IN_WIDTH_1(IN_WIDTH_1),
      .IN_WIDTH_2(IN_WIDTH_2),
      .OUT_WIDTH(OUT_WIDTH)
    ) dut (
      .clk(clk),
      .aresetn(aresetn),
      .s_valid_1(s_valid_1),
      .s_ready_1(s_ready_1),
      .s_data_1(s_data_1),
      .s_valid_2(s_valid_2),
      .s_ready_2(s_ready_2),
      .s_data_2(s_data_2),
      .m_valid(m_valid),
      .m_ready(m_ready),
      .m_data(m_data)
    );

    localparam int ClkPeriod = 10;

    initial begin
      clk <= '0;
      forever
        #(ClkPeriod/2) clk <= ~clk;
    end

    initial begin
      aresetn <= '0;
      #(ClkPeriod);
      aresetn <= '1;
    end

    localparam int NOfIterations = 1000;

    initial begin
      wait(~aresetn);
      s_valid_1 <= '0;
      s_valid_2 <= '0;
      s_data_1 <= '0;
      s_data_2 <= '0;
      wait(aresetn);

      repeat(NOfIterations) begin
        @(posedge clk);
        s_valid_1 <= '1;
        s_valid_2 <= '1;
        s_data_1 <= $urandom();
        s_data_2 <= $urandom();
        do begin
          @(posedge clk);
        end while(!(s_ready_1 && s_ready_2));
        s_valid_1 <= '0;
        s_valid_2 <= '0;
        end
        $finish;
    end

    initial begin  
      wait (~aresetn);
      m_ready <= $urandom();
      wait (aresetn);

      forever begin
        @(posedge clk);
        m_ready <= $urandom();
    end
  end

  logic [OUT_WIDTH-1:0] data_ff;
  logic valid_1_ff, valid_2_ff;

  initial begin 
    wait(aresetn);
    forever begin
      @(posedge clk);
      if(s_valid_1 && s_ready_1)
      data_ff[IN_WIDTH_1-1:0] <= s_data_1;
      if(s_valid_2 && s_ready_2)
      data_ff[OUT_WIDTH-1:IN_WIDTH_1] <=  s_data_2;
    end
  end

  initial begin 
    wait(~aresetn);
    valid_1_ff <= '0;
    valid_2_ff <= '0;
    wait(aresetn);
    forever begin
      @(posedge clk);
      if(s_valid_1 && s_ready_1)
        valid_1_ff <= '1;
      if(s_valid_2 && s_ready_2)
        valid_2_ff <= '1;
      if((valid_1_ff && valid_2_ff) && m_ready) begin
        valid_1_ff <= '0;
        valid_2_ff <= '0;
      end
    end
  end

  initial begin 
    wait(aresetn);
    forever begin
      @(posedge clk);
      if(m_valid !== (valid_1_ff && valid_2_ff)) 
        $error("%0t Incorrect m_valid. Expected: 1, actual: %d", $time(), m_valid);
      if(m_valid && m_ready) begin
        if(data_ff !== m_data) 
          $error("%0t Incorrect m_data. Expected: %d, actual: %d", $time(), data_ff, m_data);
      end
    end
  end

  initial begin  
    repeat (100000) @(posedge clk);
    $stop();
  end

  `ifdef __ICARUS__  
    initial begin
      $dumpfile("merge_parallel_tb.vcd");
      $dumpvars(0, merge_parallel_tb);
    end
  `endif

endmodule
