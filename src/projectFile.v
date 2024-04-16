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
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uo_out,   // Dedicated outputs
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    reg [7:0] seg;
    reg [1:0] PS, NS; 
    reg z;
    reg [7:0] ena_replicated; // Replicated version of ena to match width

    reg [7:0] seg_test = uio_in[7:0];
      reg [6:0] condition = ui_in[7:1]; // Adjusted width to match ui_in range

    always @(*) begin
        if (condition == 7'b1111111) begin
            case (seg_test)
                8'b00000000 : seg = 8'b11111101;   // 0
                8'b00000001 : seg = 8'b11000001;   // 1
                8'b00000010 : seg = 8'b01101111;   // 2
                8'b00000011 : seg = 8'b11100111;   // 3
                8'b00000100 : seg = 8'b11010011;   // 4
                8'b00000101 : seg = 8'b10110111;   // 5
                8'b00000110 : seg = 8'b10111111;   // 6
                8'b00000111 : seg = 8'b11100001;   // 7
                8'b00001000 : seg = 8'b11111111;   // 8
                8'b00001001 : seg = 8'b11110111;   // 9
                  
                8'b11110000 : seg = 8'b10000000;
                8'b11110001 : seg = 8'b01000000;
                8'b11110010 : seg = 8'b00100000;
                8'b11110011 : seg = 8'b00010000;
                8'b11110100 : seg = 8'b00001000;
                8'b11110101 : seg = 8'b00000100;
                8'b11110110 : seg = 8'b00000010;
                8'b11110111 : seg = 8'b00000001;
                default     : seg = 8'b00000000;     // Default value if none of the above match
            endcase
        end
        else begin
            seg = 8'b00000000;  // Default value if condition is not met
        end
    end

    wire x = ui_in[0];

    assign uo_out = seg;
    assign uio_out = 8'b0;

    // Replicate ena to match the width of uio_oe
    assign ena_replicated = {8{ena}};
    assign uio_oe = ena_replicated; // Enable output only when ena is high

    always @(posedge clk or posedge rst_n) begin
        if (!rst_n) begin
            PS <= 2'b00; // S0
            NS <= 2'b00;
            z <= 1'b0;
        end else begin
            if (ena) begin // Check if module is enabled
                PS <= NS;
                z <= (PS == 2'b11); // S3
            end
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
