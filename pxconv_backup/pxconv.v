module load_bram(
    input clk,
    input rst,
	
	input [31:0] axi_to_pxconv_data,
	input axi_to_pxconv_valid,
	
	input pixel_ack,
	
	output reg pxconv_to_axi_ready_to_rd,
	output reg [11:0] pxconv_to_axi_mst_length,
	
	output [3:0] pxconv_to_bram_low_we,
	output reg [31:0] pxconv_to_bram_low_data,
	output reg pxconv_to_bram_low_wr_en,
	output reg [31:0] pxconv_to_bram_low_addr,
	
	output [3:0] pxconv_to_bram_hi_we,
	output reg [31:0] pxconv_to_bram_hi_data,
	output reg pxconv_to_bram_hi_wr_en,
	output reg [31:0] pxconv_to_bram_hi_addr,
	
	output reg wnd_in_bram
    );
	
	wire [15:0] px_low_red, px_low_blue, px_low_green;
	wire [15:0] px_hi_red, px_hi_blue, px_hi_green;
	
	wire [17:0] px_low_grey;
	wire [17:0] px_hi_grey;
	
	reg [23:0] px_cnt;
	reg [23:0] ack_cnt;
	reg [23:0] wnd_cnt;
	
	reg [31:0] axi_to_pxconv_data_d;
	reg axi_to_pxconv_valid_d;
	
	assign px_low_red = (((axi_to_pxconv_data_d[15:0] & 16'hf800) >> 11) << 3);
	assign px_low_blue = (((axi_to_pxconv_data_d[15:0] & 16'h07e0) >> 5) << 2);
	assign px_low_green = ((axi_to_pxconv_data_d[15:0] & 16'h001f) << 3);
	
	assign px_low_grey = (px_low_red + px_low_blue + px_low_green) / 3;
	
	assign px_hi_red = (((axi_to_pxconv_data_d[31:16] & 16'hf800) >> 11) << 3);
	assign px_hi_blue = (((axi_to_pxconv_data_d[31:16] & 16'h07e0) >> 5) << 2);
	assign px_hi_green = ((axi_to_pxconv_data_d[31:16] & 16'h001f) << 3);

	assign px_hi_grey = (px_hi_red + px_hi_blue + px_hi_green) / 3;

	assign pxconv_to_bram_low_we = 4'hf;
	assign pxconv_to_bram_hi_we = 4'hf;
	
	always@(posedge clk) begin
		if(rst) begin
			pxconv_to_bram_low_data <= 32'h0;
			pxconv_to_bram_low_addr <= 32'h1180;
			pxconv_to_bram_low_wr_en <= 1'b0;
			pxconv_to_bram_hi_data <= 32'h0;
			pxconv_to_bram_hi_addr <= 32'h0000;
			pxconv_to_bram_hi_wr_en <= 1'b0;
			px_cnt <= 24'b0;
			wnd_cnt <= 24'b0;
		end
		else begin
			axi_to_pxconv_data_d <= axi_to_pxconv_data;
			axi_to_pxconv_valid_d <= axi_to_pxconv_valid;
			
			pxconv_to_bram_low_data <= {16'b0, px_low_grey[15:0]};
			pxconv_to_bram_hi_data <= {16'b0, px_hi_grey[15:0]};
			
			if(axi_to_pxconv_valid) begin
				if(px_cnt == 24'h25800) begin  //640*480/2 in hex -> accounts for 2 pixels coming in at a time
					px_cnt <= 24'h0;
				end
				else begin
					px_cnt <= px_cnt + 1;
				end
			end
			if(axi_to_pxconv_valid_d) begin
				pxconv_to_bram_low_wr_en <= 1'b1;
				pxconv_to_bram_hi_wr_en <= 1'b1;
				if(wnd_cnt == 32'h25800) begin
					wnd_cnt <= 24'b0;
				end
				else begin
					wnd_cnt <= wnd_cnt + 1;
				end
				if(pxconv_to_bram_hi_addr == 32'h117f || pxconv_to_bram_low_addr == 32'h1180) begin //7*640/2 -> only check the hi addr since the high addr will match
					pxconv_to_bram_low_addr <= 32'h0;
					pxconv_to_bram_hi_addr <= 32'h1;
				end 
				else begin
					pxconv_to_bram_low_addr <= pxconv_to_bram_low_addr + 2;
					pxconv_to_bram_hi_addr <= pxconv_to_bram_hi_addr + 2;
				end
			end
			else begin
				pxconv_to_bram_low_wr_en <= 1'b0;
				pxconv_to_bram_hi_wr_en <= 1'b0;
			end
		end
	end
	
	always@(posedge clk) begin
		if(rst) begin
			pxconv_to_axi_mst_length <= 11'h80; //256 burst is max
		end
		else begin
			if(px_cnt < 12'h8C0) begin
				pxconv_to_axi_mst_length <= 32'h80; //256 burst is max
			end
			else begin
				pxconv_to_axi_mst_length <= 32'h10; //16 burst read for regular reads
			end
		end
	end
	
	always@(posedge clk) begin
		if(rst) begin
			pxconv_to_axi_ready_to_rd <= 1'b0;
			ack_cnt <= 24'h0;
		end
		else begin
			if(px_cnt < 12'h8BE) begin //8c0 -1 = 8bf, need to stop ready_to_rd 1 cycle early.
				pxconv_to_axi_ready_to_rd <= 1'b1;
			end
			else begin

				if(pixel_ack) begin
					ack_cnt <= ack_cnt + 1;
				end
				
				if(ack_cnt == 8'h10) begin
					pxconv_to_axi_ready_to_rd <= 1'b1;
					ack_cnt <= 24'h0;
				end
				else begin
					pxconv_to_axi_ready_to_rd <= 1'b0;
				end
			end
		end
	end
	
	always@(posedge clk) begin
		if(rst) begin
			wnd_in_bram <= 1'b0;
		end
		else begin
			if(wnd_cnt >= 32'h8C0) wnd_in_bram <= 1'b1;
			else wnd_in_bram <= 1'b0;
		end
	end
	
endmodule