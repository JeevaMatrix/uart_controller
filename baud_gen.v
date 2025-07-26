module baud_gen(
    input clk,reset,
    output reg tick
);

    parameter COUNT = 5208;
    reg [12:0] count;


    always @(posedge clk) begin
        if(reset) begin
            count <= 0;
            tick <= 0;
        end
        else begin
            if(count == COUNT - 1) begin
                count <= 0;
                tick <= 1;
            end
            else begin
                tick <= 0;
                count <= count + 1;
            end
        end
    end
endmodule