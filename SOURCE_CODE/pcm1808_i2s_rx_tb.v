`timescale 1ns/1ps

module pcm1808_i2s_rx_tb;

    reg bck;
    reg lrck;
    reg dout;

    wire [23:0] left_data;
    wire [23:0] right_data;
    wire left_valid;
    wire right_valid;

    reg [23:0] LEFT_TEST_DATA;
    reg [23:0] RIGHT_TEST_DATA;

    pcm1808_i2s_rx uut (
        .bck         (bck),
        .lrck        (lrck),
        .dout        (dout),
        .left_data   (left_data),
        .right_data  (right_data),
        .left_valid  (left_valid),
        .right_valid (right_valid)
    );

    // BCK clock
    initial begin
        bck = 1'b0;

        forever begin
            #166 bck = ~bck;
        end
    end

    // Send one 24-bit audio channel
    task send_channel;
        input [23:0] sample;
        input        channel;
        integer i;

        begin

            lrck = channel;
            dout = 1'b0;

            @(posedge bck);

            // Send 24-bit MSB-first data
            for (i = 23; i >= 0; i = i - 1) begin

                @(negedge bck);
                dout = sample[i];

                @(posedge bck);

            end

            // Remaining 8 clock cycles
            for (i = 0; i < 8; i = i + 1) begin

                @(negedge bck);
                dout = 1'b0;

                @(posedge bck);

            end

        end
    endtask

    // Test
    initial begin

        lrck = 1'b1;
        dout = 1'b0;

        LEFT_TEST_DATA  = 24'h123456;
        RIGHT_TEST_DATA = 24'hABCDEF;

        #1000;

        $display("------------------------------------------");
        $display("Sending LEFT sample = %h", LEFT_TEST_DATA);
        $display("------------------------------------------");

        send_channel(LEFT_TEST_DATA, 1'b0);

        $display("------------------------------------------");
        $display("Sending RIGHT sample = %h", RIGHT_TEST_DATA);
        $display("------------------------------------------");

        send_channel(RIGHT_TEST_DATA, 1'b1);

        #2000;

        if (left_data == LEFT_TEST_DATA)
            $display("PASS: LEFT DATA = %h", left_data);
        else
            $display("FAIL: LEFT DATA = %h, EXPECTED = %h",
                     left_data, LEFT_TEST_DATA);

        if (right_data == RIGHT_TEST_DATA)
            $display("PASS: RIGHT DATA = %h", right_data);
        else
            $display("FAIL: RIGHT DATA = %h, EXPECTED = %h",
                     right_data, RIGHT_TEST_DATA);

        $display("------------------------------------------");
        $display("I2S RECEIVER TEST COMPLETE");
        $display("------------------------------------------");

        #1000;

        $finish;

    end

endmodule
