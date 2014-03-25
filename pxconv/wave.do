onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /load_bram/clk
add wave -noupdate /load_bram/rst
add wave -noupdate /load_bram/axi_to_pxconv_data
add wave -noupdate /load_bram/axi_to_pxconv_valid
add wave -noupdate /load_bram/pixel_ack
add wave -noupdate /load_bram/pxconv_to_axi_ready_to_rd
add wave -noupdate /load_bram/pxconv_to_axi_mst_length
add wave -noupdate /load_bram/pxconv_to_bram_we
add wave -noupdate /load_bram/pxconv_to_bram_data
add wave -noupdate /load_bram/pxconv_to_bram_wr_en
add wave -noupdate /load_bram/pxconv_to_bram_addr
add wave -noupdate /load_bram/wnd_in_bram
add wave -noupdate /load_bram/px_low_red
add wave -noupdate /load_bram/px_low_blue
add wave -noupdate /load_bram/px_low_green
add wave -noupdate /load_bram/px_hi_red
add wave -noupdate /load_bram/px_hi_blue
add wave -noupdate /load_bram/px_hi_green
add wave -noupdate /load_bram/px_low_grey
add wave -noupdate /load_bram/px_hi_grey
add wave -noupdate /load_bram/px_cnt
add wave -noupdate /load_bram/ack_cnt
add wave -noupdate /load_bram/axi_to_pxconv_data_d
add wave -noupdate /load_bram/axi_to_pxconv_data_dd
add wave -noupdate /load_bram/axi_to_pxconv_valid_d
add wave -noupdate /load_bram/axi_to_pxconv_valid_dd
add wave -noupdate /load_bram/pxconv_write_data_sel
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst
add wave -noupdate /tb/axi_to_pxconv_data
add wave -noupdate /tb/axi_to_pxconv_valid
add wave -noupdate /tb/pixel_ack
add wave -noupdate /tb/pxconv_to_axi_ready_to_rd
add wave -noupdate /tb/pxconv_to_axi_mst_length
add wave -noupdate /tb/pxconv_to_bram_low_we
add wave -noupdate /tb/pxconv_to_bram_low_data
add wave -noupdate /tb/pxconv_to_bram_low_wr_en
add wave -noupdate /tb/pxconv_to_bram_low_addr
add wave -noupdate /tb/pxconv_to_bram_hi_we
add wave -noupdate /tb/pxconv_to_bram_hi_data
add wave -noupdate /tb/pxconv_to_bram_hi_wr_en
add wave -noupdate /tb/pxconv_to_bram_hi_addr
add wave -noupdate /tb/wnd_in_bram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {23110 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 226
configure wave -valuecolwidth 81
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {23119 ns} {23279 ns}
