module tfpga_top(
    input  wire clk,
    output wire led
);

    wire clk_54m;

    // PLL: 27 MHz -> 54 MHz
    Gowin_PLLVR pll_inst (
        .clkin  (clk),
        .clkout (clk_54m)
    );

    reg [22:0] gate_counter;
    reg [21:0] freq_counter;
    reg [25:0] blink_counter;
    reg        frequency_ok;

    always @(posedge clk_54m) begin

        // 100 ms measurement window
        if (gate_counter < 23'd5_399_999) begin

            gate_counter <= gate_counter + 1'b1;

            // Count the 27 MHz input
            if (clk)
                freq_counter <= freq_counter + 1'b1;

        end
        else begin

            gate_counter <= 0;

            // Expected frequency ≈ 27 MHz
            // Expected count in 100 ms ≈ 2.7 million
            if ((freq_counter >= 22'd2_600_000) &&
                (freq_counter <= 22'd2_800_000))
                frequency_ok <= 1'b1;
            else
                frequency_ok <= 1'b0;

            freq_counter <= 0;
        end

        // Slow LED indication
        if (frequency_ok)
            blink_counter <= blink_counter + 1'b1;
        else
            blink_counter <= 0;

    end

    assign led = blink_counter[25];

endmodule