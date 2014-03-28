library verilog;
use verilog.vl_types.all;
entity pxconv is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        axi_to_pxconv_data: in     vl_logic_vector(15 downto 0);
        axi_to_pxconv_valid: in     vl_logic;
        pixel_ack       : in     vl_logic;
        pxconv_to_axi_ready_to_rd: out    vl_logic;
        pxconv_to_axi_mst_length: out    vl_logic_vector(11 downto 0);
        pxconv_to_bram_we: out    vl_logic_vector(3 downto 0);
        pxconv_to_bram_data: out    vl_logic_vector(31 downto 0);
        pxconv_to_bram_wr_en: out    vl_logic;
        pxconv_to_bram_addr: out    vl_logic_vector(31 downto 0);
        busy            : out    vl_logic;
        wnd_in_bram     : out    vl_logic
    );
end pxconv;