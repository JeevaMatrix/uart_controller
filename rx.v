module rx(
    input clk, reset,
    input tick,
    input rx,
    output reg [7:0] data,
    output reg rx_done
);

    reg [2:0] state;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    parameter IDLE  = 3'b000,
              START = 3'b001,
              DATA  = 3'b010,
              STOP  = 3'b011,
              DONE  = 3'b100;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= IDLE;
            bit_index <= 0;
            shift_reg <= 0;
            rx_done <= 0;
            data <= 0;
        end
        else if(tick) begin
            case(state)
                IDLE: begin
                    rx_done <= 0;
                    if(rx == 0)
                        state <= DATA;
                        bit_index <= 0;
                end
                //START: begin
                    //state <= DATA;
                    //bit_index <= 0;
                //end
                DATA: begin
                    shift_reg[bit_index] <= rx;
                    bit_index <= bit_index + 1;
                    if(bit_index == 7)
                        state <= STOP;
                end
                STOP: begin
                    if(rx == 1) begin
                        data <= shift_reg;
                        rx_done <= 1;
                        state <= DONE;
                    end
                    else 
                        state <= IDLE;
                end
                DONE: begin
                    rx_done <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule