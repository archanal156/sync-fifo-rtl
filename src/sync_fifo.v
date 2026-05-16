// ============================================================
//  Module    : sync_fifo
//  Project   : Synchronous FIFO Controller
//  Author    : Archana L.
//  Width     : 8-bit data
//  Depth     : 8 locations (3-bit pointer)
//  Features  : Full / Empty flags, Read/Write pointers,
//              Synthesisable RTL, No latches
// ============================================================

module sync_fifo (clk, rst, r_en, wr_en, data_in, empty, full, data_out);

    input        clk, rst, r_en, wr_en;
    input  [7:0] data_in;
    output       empty, full;
    output reg [7:0] data_out;

    reg [7:0] fifo [7:0];
    reg [2:0] wr_ptr, rd_ptr;
    reg [3:0] count;  

    // FIX 3: reset all pointers and counter
    always @(posedge clk) begin
        if (rst == 1) begin
            wr_ptr   <= 3'd0;
            rd_ptr   <= 3'd0;
            count    <= 4'd0;
            data_out <= 8'd0;
        end
        else begin
            // Write
            if (wr_en == 1 && full == 0) begin
                fifo[wr_ptr] <= data_in;
                wr_ptr       <= wr_ptr + 1;  
                count        <= count + 1;
            end
            // Read
            if (r_en == 1 && empty == 0) begin
                data_out <= fifo[rd_ptr];
                rd_ptr   <= rd_ptr + 1;
                count    <= count - 1;
            end
            // Simultaneous read + write (count stays same)
            if (wr_en == 1 && r_en == 1 && !full && !empty)
                count <= count;
        end
    end

    // FIX 4: correct full/empty using count
    assign empty = (count == 0);
    assign full  = (count == 8);

endmodule 
