/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

/*
      -- 3 --
     |       |
     4       2
     |       |
      -- 7 --
     |       |
     5       1
     |       |
      -- 6 --    . 8
*/

`define default_netname none

module tt_um_3515_sequenceDetector (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    reg [7:0] seg;
    reg [1:0] PS, NS;
    reg z;
      
    wire x = ui_in[0];
      
    assign uo_out = seg;
    assign uio_out = 8'b0;
    assign uio_oe = 8'b0;

    always @(posedge clk or posedge rst_n) begin
        if (!rst_n) begin
            PS <= 2'b00; // S0
            z <= 1'b0;
        end else begin
            PS <= NS;
            z <= (PS == 2'b11); // S3
        end
    end

    always @(*) begin
        case (PS)
            2'b00: NS = x ? 2'b01 : 2'b00; // S0, Next state is S1 if x is 1, else remain in S0
            2'b01: NS = x ? 2'b01 : 2'b10; // S1, Next state is S1 if x is 1, else transition to S2
            2'b10: NS = x ? 2'b00 : 2'b11; // S2, Next state is S3 if x is 0, else return to S0
            2'b11: NS = x ? 2'b00 : 2'b00; // S3, Always return to S0
        endcase
    end

    always @(*) begin
        case (z)
            1'b0: seg = 8'b00000010; // Display '-' on 7-segment (sequence not detected)
            1'b1: seg = 8'b11111111; // Display '8.' on 7-segment (sequence detected)
        endcase;
    end

endmodule
