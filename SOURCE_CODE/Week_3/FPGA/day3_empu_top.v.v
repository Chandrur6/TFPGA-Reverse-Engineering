module day3_empu_top (
    input  wire clk,
    output wire led,

    // ESP32-S3 <-> FPGA communication
    output wire mcu_d0,
    output wire mcu_d2,
    output wire mcu_d3
);

    //========================================================
    // AHB2 Master signals from Cortex-M3 EMPU
    //========================================================

    wire        master_hclk;
    wire        master_hrst;
    wire        master_hsel;
    wire [31:0] master_haddr;
    wire [1:0]  master_htrans;
    wire        master_hwrite;
    wire [2:0]  master_hsize;
    wire [2:0]  master_hburst;
    wire [3:0]  master_hprot;
    wire [1:0]  master_hmemattr;
    wire        master_hexreq;
    wire [3:0]  master_hmaster;
    wire [31:0] master_hwdata;
    wire        master_hmastlock;

    wire [3:0] master_hauser;
    wire [3:0] master_hwuser;

    //========================================================
    // AHB2 Response signals
    //========================================================

    wire [31:0] master_hrdata;
    wire        master_hreadyout;
    wire        master_hresp;
    wire        master_hexresp;
    wire [2:0]  master_hruser;

    //========================================================
    // FPGA Register
    //========================================================

    reg [31:0] fpga_data;

    //========================================================
    // ESP32-S3 / FPGA communication
    //
    // FPGA pin 14 -> ESP32 GPIO3  = D0
    // FPGA pin 15 -> ESP32 GPIO5  = D1 / LED
    // FPGA pin 16 -> ESP32 GPIO6  = D2
    // FPGA pin 17 -> ESP32 GPIO4  = D3
    //========================================================

    assign mcu_d0 = fpga_data[0];

    // D1 shares the onboard LED pin
    assign led    = fpga_data[1];

    assign mcu_d2 = fpga_data[2];
    assign mcu_d3 = fpga_data[3];

    //========================================================
    // AHB2 Response
    //========================================================

    assign master_hrdata    = fpga_data;
    assign master_hreadyout = 1'b1;
    assign master_hresp     = 1'b0;
    assign master_hexresp   = 1'b0;
    assign master_hruser    = 3'b000;

    //========================================================
    // Gowin EMPU - Cortex-M3
    //========================================================

    Gowin_EMPU_Top u_empu (

        .sys_clk          (clk),

        .master_hclk      (master_hclk),
        .master_hrst      (master_hrst),
        .master_hsel      (master_hsel),
        .master_haddr     (master_haddr),
        .master_htrans    (master_htrans),
        .master_hwrite    (master_hwrite),
        .master_hsize     (master_hsize),
        .master_hburst    (master_hburst),
        .master_hprot     (master_hprot),
        .master_hmemattr  (master_hmemattr),
        .master_hexreq    (master_hexreq),
        .master_hmaster   (master_hmaster),
        .master_hwdata    (master_hwdata),
        .master_hmastlock (master_hmastlock),

        .master_hauser    (master_hauser),
        .master_hwuser    (master_hwuser),

        .master_hrdata    (master_hrdata),
        .master_hreadyout (master_hreadyout),
        .master_hresp     (master_hresp),
        .master_hexresp   (master_hexresp),
        .master_hruser    (master_hruser),

        .reset_n          (1'b1)
    );

    //========================================================
    // Capture Cortex-M3 AHB2 Writes
    //========================================================

    reg        write_q;
    reg        sel_q;
    reg [1:0]  trans_q;

    always @(posedge master_hclk) begin

        if (master_hrst) begin

            fpga_data <= 32'h00000000;
            write_q   <= 1'b0;
            sel_q     <= 1'b0;
            trans_q   <= 2'b00;

        end

        else begin

            // Capture AHB address/control phase
            sel_q   <= master_hsel;
            write_q <= master_hwrite;
            trans_q <= master_htrans;

            // Execute write during AHB data phase
            if (sel_q && write_q && trans_q[1]) begin
                fpga_data <= master_hwdata;
            end

        end
    end

endmodule