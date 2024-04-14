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
    output wire [7:0] uo_out    // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    wire x = ui_in[0];
    wire clk = ui_in[1];
    wire reset = ui_in[2];
    
    reg [7:0] seg;
    reg [1:0] PS, NS;
    reg z;

    assign uo_out [7:0] = seg;
    assign uio_out = 8'b0;
    assign uio_oe = 8'b0

    parameter S0=0, S1=1, S2=2, S3=3;

    always @(posedge clk or posedge reset) begin
          if (!reset) begin
            PS <= S0;
            z <= 0;
        end else begin
            PS <= NS;
            z <= (PS == S3);
        end
    end

    always @(*) begin
        case (PS)
            S0: NS = x ? S0 : S1;
            S1: NS = x ? S2 : S1;
            S2: NS = x ? S3 : S1;
            S3: NS = x ? S0 : S1;
        endcase
    end

    always @(*) begin
        case (z)
            0: seg = 8'b00000010; // Display - on 7-segment (sequence not detected)
            1: seg = 8'b11111111; // Display 8. on 7-segment (sequence detected)
        endcase;
    end

endmodule
