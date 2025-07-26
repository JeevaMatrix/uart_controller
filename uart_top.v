`include "tx.v"
`include "rx.v"
`include "baud_gen.v"

module uart_top(
    input clk, reset,
    input tx_start,
    input [7:0] tx_data,
    output tx_done,
    output tx_line,
    input rx_line,
    output [7:0] rx_data,
    output rx_done
);
    wire tick;

    // Baud generator
    baud_gen baud_inst (
        .clk(clk),
        .reset(reset),
        .tick(tick)
    );

    // UART Transmitter
    tx tx_inst (
        .clk(clk),
        .reset(reset),
        .tick(tick),
        .data(tx_data),
        .tx_ready(tx_start),
        .tx_done(tx_done),
        .tx(tx_line)
    );

    // UART Receiver
    rx rx_inst (
        .clk(clk),
        .reset(reset),
        .tick(tick),
        .rx(tx_line),     // loopback internally
        .data(rx_data),
        .rx_done(rx_done)
    );
endmodule
