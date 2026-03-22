module fifo_tb;

    parameter DEPTH = 8;
    parameter WIDTH = 8;

    reg clk, rst;
    reg wr_en, rd_en;
    reg [WIDTH-1:0] data_in;
    wire [WIDTH-1:0] data_out;
    wire full, empty;

    fifo #(DEPTH, WIDTH) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        #10 rst = 0;

        #10 wr_en = 1; data_in = 8'hA1;
        #10 data_in = 8'hB2;
        #10 data_in = 8'hC3;
        #10 data_in = 8'hD4;

        #10 wr_en = 0;

        #10 rd_en = 1;
        #40 rd_en = 0;

        #10 wr_en = 1; rd_en = 1; data_in = 8'hE5;
        #20 wr_en = 0; rd_en = 0;

        #20 $finish;
    end

    initial begin
        $dumpfile("fifo.vcd");
        $dumpvars(0, fifo_tb);
    end

endmodule