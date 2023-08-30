module uarttx #(parameter freq=100_000_000, parameter baud_rate=9600) (clk,rst,tx_in,send,tx_done,tx);

localparam count=freq/baud_rate;  //for creating clock as per baudrate

input clk,rst,send;
input [7:0]tx_in;
output reg tx,tx_done;


reg uclk;            //slowed down clock matching the baud rate
reg [13:0]count1;   // localparam width=$clog2(count); [width-1:0]
reg[3:0] data_count; 
enum bit[1:0] {idle=2'd0, start=2'd1, transfer=2'd2,stop=2'd3}state;

always @(posedge clk or posedge rst) begin
    
    if(rst) begin
        count1<=0;
        uclk<=1'b0;
    end
    else if(count1==count/2) begin
        uclk<=1'b1;
        count1<=count1+1'b1;
    end
    else if(count1==count) begin
        uclk<=1'b0;
        count1<=0;
    end
    else 
     count1<=count1+1'b1;

end

always @(posedge uclk or posedge rst ) begin
    if(rst) begin
        tx<=1'b1;
        tx_done<=1'b0;
        data_count<=0;
        state<=idle;
    end

    else begin
        case (state)
            idle: begin
     			tx_done<=0;
                if(send) begin
                    state<=transfer;
                    tx<=1'b0;
                end
                else begin
                    state<=idle;
                end

            end 

            transfer: begin

                if(data_count==4'd8) begin
                    data_count<=3'd0;
                    state<=stop;
                end

                else begin

                    data_count<=data_count+1'b1;
                    case (data_count) 
                        4'd0: tx<=tx_in[0];
                        4'd1: tx<=tx_in[1];
                        4'd2: tx<=tx_in[2];
                        4'd3: tx<=tx_in[3];
                        4'd4: tx<=tx_in[4]; 
                        4'd5: tx<=tx_in[5];
                        4'd6: tx<=tx_in[6];
                        4'd7: tx<=tx_in[7];    
                    endcase
                      
                    state<=transfer;
                end
            end

            stop: begin
                tx<=1'b1;
                tx_done<=1'b1;
                state<=idle;                        
            end
            
        endcase
    end
end

endmodule


module uartrx #(parameter freq=100_000_000, parameter baud_rate=9600, parameter sample=16) (clk,rst,rx,rx_done,data_reg);

input clk;
input rst;
input rx;
output reg rx_done;
output reg[7:0] data_reg;

localparam count = freq/(baud_rate*sample);


enum bit[1:0] { idle=2'd0,start=2'd1,data=2'd2, stop=2'd3}state; 


reg [3:0]data_count;
reg [4:0]sampler;
reg[9:0]baud_count;
reg baud_clock;



always @(posedge clk or posedge rst) begin
    if (rst) begin
        baud_count<=10'd0;
        state<=idle;
        data_count<=4'd0;
        data_reg<=8'b0;
        baud_clock<=1'b0;
        sampler<=5'd0;
        rx_done<=0;
     end

    else if (baud_count==count) begin
         baud_count<=10'd0;
         baud_clock<=1'b1;
     end

    else if (baud_count==count/2) begin
         baud_count<=baud_count+1'b1;
         baud_clock<=1'b0;
     end

     else begin
        baud_count<=baud_count+1'b1;
     end
end

always @(posedge baud_clock) begin
        case (state)

            idle: begin
                rx_done<=0;
                if(rx==1'b0) begin
                 state<=start;
                 sampler<=sampler+1'b1;
                end
                 else 
                    state <=idle;
            end
            
            start: begin
                if (sampler==sample/2 && rx==1'b0) begin
                    state<=data;
                    sampler<=5'd0;
                end
                else begin
                    sampler<=sampler+1'b1;
                    state<=start;
                end
                     
            end

            data: begin
                if(data_count==4'd8) begin
                    
                    sampler<=5'd1;
                    state<=stop;
                end
                else begin
                    if(sampler==sample-1) begin
                        sampler<=5'd0;
                        case (data_count)
                           4'd0 : data_reg[0]<=rx;
                           4'd1 : data_reg[1]<=rx;
                           4'd2 : data_reg[2]<=rx;
                           4'd3 : data_reg[3]<=rx;
                           4'd4 : data_reg[4]<=rx;
                           4'd5 : data_reg[5]<=rx;
                           4'd6 : data_reg[6]<=rx; 
                           4'd7 : data_reg[7]<=rx;
                        endcase
                        data_count<=data_count+1'b1;
                    end
                    else begin
                         sampler<=sampler+1;
                    end
                    state<=data;
                end 
            end

             stop:  begin 

                if (sampler==sample-1 && rx==1'b1) begin
                    state<=idle;
                    data_count<=4'd0;
                    rx_done<=1'b1;
                    sampler<=5'd0;
                end
                else begin
                    sampler<=sampler+1'b1;
                    state<=stop;
                end
                     
            end
                     
        endcase
    end

endmodule
