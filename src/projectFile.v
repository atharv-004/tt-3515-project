/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_3515_sequenceDetector (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out    // Dedicated outputs
);

    reg [7:0] seg;
    reg [1:0] PS, NS;
    reg z;

    parameter S0=0, S1=1, S2=2, S3=3;

    always @(posedge ui_in[1] or posedge ui_in[2] or posedge ui_in[2]) begin
        if (ui_in[2]) begin
            PS <= S0;
            z <= 0;
        end else begin
            PS <= NS;
            z <= (PS == S3);
        end
    end

    always @* begin
        case (PS)
            S0: NS = ui_in[0] ? S0 : S1;
            S1: NS = ui_in[0] ? S2 : S1;
            S2: NS = ui_in[0] ? S3 : S1;
            S3: NS = ui_in[0] ? S0 : S1;
        endcase
    end

    always @(*) begin
        case (z)
            0: seg = 8'b00000010; // Display - on 7-segment (sequence not detected)
            1: seg = 8'b11111111; // Display 8. on 7-segment (sequence detected)
        endcase;
    end

    assign uo_out = seg;

endmodule
