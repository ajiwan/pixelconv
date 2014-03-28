`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:44:06 03/23/2014
// Design Name:   load_bram
// Module Name:   C:/fpga/ISE/pxconv/tb.v
// Project Name:  pxconv
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: load_bram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] axi_to_pxconv_data;
	reg axi_to_pxconv_valid;
	reg pixel_ack;

	// Outputs
	wire pxconv_to_axi_ready_to_rd;
	wire [11:0] pxconv_to_axi_mst_length;
	wire [3:0] pxconv_to_bram_low_we;
	wire [31:0] pxconv_to_bram_low_data;
	wire pxconv_to_bram_low_wr_en;
	wire [31:0] pxconv_to_bram_low_addr;
	wire [3:0] pxconv_to_bram_hi_we;
	wire [31:0] pxconv_to_bram_hi_data;
	wire pxconv_to_bram_hi_wr_en;
	wire [31:0] pxconv_to_bram_hi_addr;
	wire wnd_in_bram;

	// Instantiate the Unit Under Test (UUT)
	load_bram uut (
		.clk(clk), 
		.rst(rst), 
		.axi_to_pxconv_data(axi_to_pxconv_data), 
		.axi_to_pxconv_valid(axi_to_pxconv_valid), 
		.pixel_ack(pixel_ack), 
		.pxconv_to_axi_ready_to_rd(pxconv_to_axi_ready_to_rd), 
		.pxconv_to_axi_mst_length(pxconv_to_axi_mst_length), 
		.pxconv_to_bram_low_we(pxconv_to_bram_low_we), 
		.pxconv_to_bram_low_data(pxconv_to_bram_low_data), 
		.pxconv_to_bram_low_wr_en(pxconv_to_bram_low_wr_en), 
		.pxconv_to_bram_low_addr(pxconv_to_bram_low_addr),
		.pxconv_to_bram_hi_we(pxconv_to_bram_hi_we), 
		.pxconv_to_bram_hi_data(pxconv_to_bram_hi_data), 
		.pxconv_to_bram_hi_wr_en(pxconv_to_bram_hi_wr_en), 
		.pxconv_to_bram_hi_addr(pxconv_to_bram_hi_addr), 		
		.wnd_in_bram(wnd_in_bram)
	);
	
PXBRAM my_bram_0 (
  .clka(clk), // input clka
  .wea(pxconv_to_bram_low_we), // input [3 : 0] wea
  .ena(pxconv_to_bram_low_wr_en),
  .addra(pxconv_to_bram_low_addr), // input [31 : 0] addra
  .dina(pxconv_to_bram_low_data), // input [31 : 0] dina
  .douta(), // output [31 : 0] douta
  .clkb(clk), // input clkb
  .enb(pxconv_to_bram_hi_wr_en),
  .web(pxconv_to_bram_hi_we), // input [3 : 0] web
  .addrb(pxconv_to_bram_hi_addr), // input [31 : 0] addrb
  .dinb(pxconv_to_bram_hi_data), // input [31 : 0] dinb
  .doutb() // output [31 : 0] doutb
);
	
	always @(posedge clk) begin
		if(rst) begin
			axi_to_pxconv_data <= 32'h0000;
			axi_to_pxconv_valid <= 1'b0;
		end
		else begin
			if(pxconv_to_axi_ready_to_rd) begin
				axi_to_pxconv_data <=  axi_to_pxconv_data+ 1;
				axi_to_pxconv_valid <= 1'b1;
			end
			else begin
				axi_to_pxconv_valid <= 1'b0;
			end
		end
	end
	
	always@(posedge clk) begin
		if(rst) begin
			pixel_ack <= 1'b0;
		end
		if(wnd_in_bram) begin
			pixel_ack = ~pixel_ack;
		end
	end
	
	always
		#5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		axi_to_pxconv_data = 0;
		axi_to_pxconv_valid = 0;
		pixel_ack = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
        
		// Add stimulus here
		#22665;

		#1000;
	end
      
endmodule

