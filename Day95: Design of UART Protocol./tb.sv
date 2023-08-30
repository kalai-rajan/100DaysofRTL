 module uarttx_tb;
reg clk,rst;
reg send;
reg [7:0]data_in;
wire tx,tx_done;
reg [7:0]data_verif;
int i;
wire rx_done;
wire [7:0]rx_out;

uarttx dut(clk,rst,data_in,send,tx_done,tx);
uartrx dut2(clk,rst,tx,rx_done,rx_out);

initial begin
    rst=1; clk=0;i=0;
    data_in<=8'b1001_1001;

    @(posedge clk);
    rst=0; 
    repeat (5) begin
        @(posedge dut.uclk);
        send=1;
        @(posedge dut.uclk);
        send=0;
        @(posedge dut.uclk);

        repeat(8) begin
            @(posedge dut.uclk);
            data_verif[i]=tx;
            i++;
        end
        @(posedge dut.uclk);
        @(posedge dut.uclk);

        if(data_verif==data_in) begin
        $display("TRANSMITTER DATA SENDED=%b\tTRANSMITERDATA RECEIVED=%b",data_in,data_verif);
        $display("DATA MATCHED IN TRANSMITTER");
        end
        else begin
        $display("TRANSMITTER DATA SENDED=%b\tTRANSMITERDATA RECEIVED=%b",data_in,data_verif);
        $display("DATA MISSMATCHED IN TRANSMITTER");
        end

        if(rx_out==data_in) begin
        $display("TRANSMITTER DATA SENDED=%b\tRECEIVER DATA=%b",data_in,rx_out);
        $display("DATA MATCHED IN RECEIVER\n");
        end
        else begin
        $display("TRANSMITTER DATA SENDED=%b\tRECEIVER DATA=%b",data_in,rx_out);
        $display("DATA MISSMATCHED IN RECEIVER\n");
        end
    end
    $finish();
end
   
   
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end
 
   
always #5 clk=~clk;
endmodule
  
