`timescale 1ns/10ps
 // Generated by Cadence Genus(TM) Synthesis Solution 18.14-s037_1 // Generated on: Jan 27 2021 23:01:35 CST (Jan 28 2021 05:01:35 UTC) // Verification Directory fv/dff module dff(clk, d, q); input clk, d; output q; wire clk, d; wire q; wire UNCONNECTED, n_0, n_3; DFF_X1 q_reg(.CK (n_0), .D (d), .Q (q), .QN (UNCONNECTED)); INV_X1 g4(.A (n_3), .ZN (n_0)); CLKBUF_X1 drc_buf_sp(.A (clk), .Z (n_3)); endmodule
