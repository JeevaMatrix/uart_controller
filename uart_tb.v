`timescale 1ns/1ns
`include "uart_top.v"

module uart_tb();
    reg clk = 0, reset = 0;
    reg tx_start = 0;
    reg [7:0] tx_data = 8'h54;  // example data to send
    wire tx_done, tx_line, rx_done;
    wire [7:0] rx_data;
    integer timeout;

    // Generate 50 MHz clock => 20ns period
    always #10 clk = ~clk;

    // Instantiate top module
    uart_top uut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_done(tx_done),
        .tx_line(tx_line),
        .rx_line(tx_line),   // Loopback
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    initial begin
    $monitor("Time=%0t | tx_line=%b | rx_data=%h | rx_done=%b | state=%d | bit=%d",
             $time, tx_line, rx_data, uut.rx_inst.rx_done, uut.rx_inst.state, uut.rx_inst.bit_index);
    end


    initial begin
        $dumpfile("uart_tb.vcd");
        $dumpvars(0, uart_tb);

        // Reset
        reset = 1;
        #100;
        reset = 0;

        // Start transmission after reset
        #100;
        $display("Sending byte: 0x%h", tx_data);
        tx_start = 1;

        // Wait until transmission done
        //wait(tx_done);
        //$display("TX Done");

        timeout = 0;
        while (!tx_done && timeout < 500000) begin
            #10;
            timeout = timeout + 1;
        end

        if (tx_done)
            $display("TX Done");
        else
            $display("TX TIMEOUT ❌");

        // Wait until reception done
        wait(rx_done);
        $display("RX Done. Received byte: 0x%h", rx_data);

        // Check match
        if (tx_data == rx_data)
            $display("✅ SUCCESS: TX and RX data matched.");
        else
            $display("❌ ERROR: TX and RX data did NOT match.");

        #1000;
        $finish;
    end
endmodule
