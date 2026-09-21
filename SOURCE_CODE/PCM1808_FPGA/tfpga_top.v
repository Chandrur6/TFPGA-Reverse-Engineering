module tfpga_top (
    input  wire        clk,
    input  wire        pcm_dout,

    output wire        led,

    output wire        pcm_scki,
    output wire        pcm_bck,
    output wire        pcm_lrck
);

    wire [23:0] left_data;
    wire [23:0] right_data;

    wire left_valid;
    wire right_valid;

    pcm1808_audio_top u_pcm_audio (
        .clk         (clk),
        .pcm_scki    (pcm_scki),
        .pcm_bck     (pcm_bck),
        .pcm_lrck    (pcm_lrck),
        .pcm_dout    (pcm_dout),
        .left_data   (left_data),
        .right_data  (right_data),
        .left_valid  (left_valid),
        .right_valid (right_valid)
    );

    reg [23:0] left_sample_reg  = 24'd0;
    reg [23:0] right_sample_reg = 24'd0;

    always @(posedge pcm_bck) begin
        if (left_valid)
            left_sample_reg <= left_data;

        if (right_valid)
            right_sample_reg <= right_data;
    end

    reg [23:0] audio_activity_counter = 24'd0;

    always @(posedge pcm_bck) begin
        if (left_valid)
            audio_activity_counter <=
                audio_activity_counter + 24'd1;
    end

    reg audio_data_received;

    always @(posedge pcm_bck) begin
        if (left_valid) begin
            if (left_data != 24'd0)
                audio_data_received <= 1'b1;
            else
                audio_data_received <= 1'b0;
        end
    end

    assign led = audio_data_received;

endmodule
