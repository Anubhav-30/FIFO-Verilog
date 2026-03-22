module fifo #(parameter DEPTH = 8, WIDTH = 8) (
    input clk, rst,
    input wr_en, rd_en,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output full, empty
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr;
    reg [$clog2(DEPTH):0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) wr_ptr <= 0;
        else if (wr_en && !full) begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) rd_ptr <= 0;
        else if (rd_en && !empty) begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) count <= 0;
        else if (wr_en && !full && !(rd_en && !empty)) count <= count + 1;
        else if (rd_en && !empty && !(wr_en && !full)) count <= count - 1;
    end

    assign full  = (count == DEPTH);
    assign empty = (count == 0);

endmodule