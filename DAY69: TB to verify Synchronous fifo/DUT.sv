module synch_fifo_sv(rst,clk,rd_en,wr_en,w_data_in,full,empty,wr_error,rd_error,r_data_out);
    parameter WIDTH =4,
              DEPTH=8;
    localparam PTR_WIDTH = 3 ; //$clog2(DEPTH)
    input clk,rst,rd_en,wr_en;
    input [WIDTH-1:0]w_data_in;
    output reg full,empty,rd_error,wr_error;
    output  reg [WIDTH-1:0]r_data_out;

    reg[PTR_WIDTH-1:0]rd_ptr,wr_ptr;
    reg wr_pt_f,rd_pt_f;
    reg[WIDTH-1:0]mem[DEPTH-1:0];
    integer i;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            wr_ptr<=0; //*
            rd_ptr<=0;
            full<=0;
            empty<=1;
            rd_error<=0;
            wr_error<=0;
            r_data_out<=0;
            wr_pt_f<=0;
            rd_pt_f<=0;
            for (i =0 ;i<DEPTH ;i=i+1 ) begin //*
                mem[i]<=0;
            end
        end

        if (wr_en) begin
            if(!full) begin
            wr_error<=0;
            mem[wr_ptr]<=w_data_in;
            if (wr_ptr==DEPTH-1) begin
                wr_ptr<=0;
                wr_pt_f<=~wr_pt_f;
            end
            else 
             wr_ptr<=wr_ptr+1'b1;
        end
        end

        else 
           wr_error<=1'b1; //*
        
        if (rd_en) begin
            if(!empty) begin
            rd_error<=0;
            r_data_out<=mem[rd_ptr] ;
            if (rd_ptr==DEPTH-1) begin
                rd_ptr<=0;
                rd_pt_f<=~rd_pt_f;
            end
            else 
             rd_ptr<=rd_ptr+1'b1;
        end
        end
        else 
           rd_error<=1'b1;

    end

    always @(*) begin
             
        if( (rd_ptr==wr_ptr) && (rd_pt_f == wr_pt_f))
          empty<=1'b1;
        else 
         empty <=1'b0;
        if( (rd_ptr==wr_ptr) && (rd_pt_f != wr_pt_f))
          full<=1'b1;
        else 
         full <=1'b0;
        
    end

endmodule
//----------------------------------------------------------------------------------------------------
