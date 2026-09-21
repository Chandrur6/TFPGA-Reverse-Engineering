module pcm1808_audio_top (
    input  wire clk,

    // PCM1808 interface
    output wire pcm_scki,
    output wire pcm_bck,
    output wire pcm_lrck,
    input  wire pcm_dout,

    // Captured audio samples
    output wire [23:0] left_data,
    output wire [23:0] right_data,
    output wire        left_valid,
    output wire        right_valid
);

    //========================================================
    // STARTUP RESET
    //========================================================

    reg [7:0] reset_counter = 8'd0;
    reg       reset_reg     = 1'b1;

    always @(posedge clk) begin

        if (reset_counter < 8'd255) begin

            reset_counter <= reset_counter + 1'b1;
            reset_reg     <= 1'b1;

        end

        else begin

            reset_reg <= 1'b0;

        end

    end


    //========================================================
    // PCM1808 CLOCK
    // 27 MHz -> 12 MHz
    //========================================================

    wire clk_12m;

    PCM1808_PLL u_pcm_pll (
        .clkin  (clk),
        .clkout (clk_12m)
    );

    // System clock to PCM1808
    assign pcm_scki = clk_12m;


    //========================================================
    // BCK GENERATION
    // 12 MHz / 4 = 3 MHz
    //========================================================

    reg [1:0] bck_div = 2'd0;

    always @(posedge clk_12m) begin

        if (reset_reg) begin

            bck_div <= 2'd0;

        end

        else begin

            bck_div <= bck_div + 1'b1;

        end

    end

    assign pcm_bck = bck_div[1];


    //========================================================
    // LRCK GENERATION
    // 64 BCK CLOCKS PER LRCK PERIOD
    //========================================================

    reg [5:0] bck_count = 6'd0;
    reg       lrck_reg  = 1'b0;

    always @(posedge clk_12m) begin

        if (reset_reg) begin

            bck_count <= 6'd0;
            lrck_reg  <= 1'b0;

        end

        else begin

            if (bck_div == 2'b11) begin

                if (bck_count == 6'd31) begin

                    bck_count <= 6'd0;
                    lrck_reg  <= ~lrck_reg;

                end

                else begin

                    bck_count <= bck_count + 1'b1;

                end

            end

        end

    end

    assign pcm_lrck = lrck_reg;


    //========================================================
    // PCM1808 I2S RECEIVER
    //========================================================

    pcm1808_i2s_rx u_i2s_rx (

        .bck        (pcm_bck),
        .lrck       (pcm_lrck),
        .dout       (pcm_dout),

        .left_data  (left_data),
        .right_data (right_data),

        .left_valid (left_valid),
        .right_valid(right_valid)

    );

endmodule
