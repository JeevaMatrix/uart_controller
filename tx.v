module tx(
    input clk, reset,
    input tick,
    input [7:0]data,
    input tx_ready,
    output reg tx_done, tx
);

    reg [2:0] state;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;


    parameter IDLE = 3'b000,
              START = 3'b001,
              DATA = 3'b010,
              STOP = 3'b011,
              DONE = 3'b100;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= IDLE;
            bit_index <= 0;
            shift_reg <= 0;
            tx <= 1'b1;
            tx_done <= 0;
        end
        else if(tick) begin 
            case(state)
                IDLE: begin
                    tx_done <= 0;
                    tx <= 1'b1;
                    if(tx_ready) begin
                        shift_reg <= data;
                        state <= START;
                    end
                end
                START: begin
                    tx <= 0;
                    bit_index <= 0;
                    state <= DATA;
                end
                DATA: begin
                    tx <= shift_reg[bit_index];
                    bit_index <= bit_index + 1;
                    if(bit_index == 7) begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    tx <= 1;
                    tx_done <= 1;
                    state <= DONE;
                end
                DONE: begin
                    tx_done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule