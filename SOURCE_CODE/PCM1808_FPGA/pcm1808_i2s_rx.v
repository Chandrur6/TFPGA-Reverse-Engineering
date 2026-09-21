module pcm1808_i2s_rx (
    input  wire        bck,
    input  wire        lrck,
    input  wire        dout,

    output reg [23:0] left_data,
    output reg [23:0] right_data,

    output reg        left_valid,
    output reg        right_valid
);

    reg [23:0] shift_reg;
    reg [5:0]  bit_count;
    reg        lrck_previous;

    always @(posedge bck) begin

        left_valid  <= 1'b0;
        right_valid <= 1'b0;

        // Detect LRCK channel change
        if (lrck != lrck_previous) begin
            bit_count <= 6'd0;
        end

        // Receive 24-bit audio data
        else if (bit_count < 6'd24) begin

            shift_reg <= {shift_reg[22:0], dout};
            bit_count <= bit_count + 1'b1;

            // 24th bit received
            if (bit_count == 6'd23) begin

                if (lrck == 1'b0) begin

                    left_data  <= {shift_reg[22:0], dout};
                    left_valid <= 1'b1;

                end

                else begin

                    right_data  <= {shift_reg[22:0], dout};
                    right_valid <= 1'b1;

                end

            end

        end

        lrck_previous <= lrck;

    end

endmodule
