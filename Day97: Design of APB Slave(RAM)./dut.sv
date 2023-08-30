module apb_slave(pclk,presetn,transfer,psel,penable,paddr,pwrite,pready,pwrdata,pslverr,prdata);

input pclk,presetn,pwrite;
input penable,psel,transfer;
input [31:0] paddr,pwrdata;
output reg pready,pslverr;
output reg [31:0]prdata;
int i;
  typedef enum {idle=0, setup=1, acess=2,end_of_transfer=3}state_type;

reg [7:0]mem[8];
state_type state;

always @(posedge pclk or posedge presetn ) begin
    if(presetn) begin
        pready<=1'b0;
        state<=idle;
        pslverr<=1'b0;
        prdata<=0;
        
        for (i=0;i<8;i=i+1) 
          mem[i]<=0;
    end

    else begin
        case(state)
        
        idle:begin
          if(psel==1'b0 && penable==1'b0)  
                    state<=setup;
          else 
              state<=idle;    
              
            end
        
        setup: begin
          if(psel==1'b1 && penable==1'b0) begin
                    if(paddr<8) begin
                      pready<=1'b1;
                      pslverr<=1'b0;
                      state<=acess; 
                    end

                    else begin
                      pready<=1'b0;
                      pslverr<=1'b0;
                      state<=acess; 
                    end

                    end
                else 
                state<=setup;
               end

        acess: begin
                 if(psel && pwrite && penable) begin
                    if(paddr<8) begin
                        mem[paddr]<=pwrdata;

                        if(transfer==1'b1) begin
                          state <=setup;
                          pready<=1'b0;
                        end
                        else 
                          state<=end_of_transfer;
                    end

                    else begin
                         pready<=1'b1;
                         pslverr<=1'b1;
                         if(transfer) 
                          state <=setup;
                        else 
                          state<=end_of_transfer;
                    end
                 end

               else  if(psel && !pwrite && penable) begin
                    if(paddr<8) begin
                        prdata<=mem[paddr];
                        if(transfer==1'b1) begin
                          state <=setup;
                          pready<=1'b0;
                        end
                        else 
                          state<=end_of_transfer;
                    end
                    else begin
                         pready<=1'b1;
                         pslverr<=1'b1;
                         if(transfer) 
                          state <=setup;
                        else 
                          state<=end_of_transfer;
                    end
                 end
                
                 else 
                   state<=acess;
            
               end

        end_of_transfer: begin
            pready<=1'b0;
            pslverr<=1'b0;
            state<=idle;
        end

        endcase
    end
end
endmodule
