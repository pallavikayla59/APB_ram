// Code your design here
Module dut_test(
  Input presetn,
  Input pclk,
  Input psel,
  Input penable,
  Input pwrite,
  Input [31:0] paddr, pwdata,
  Output reg [31:0] prdata,
  Output reg pready, pslverr
);
  
  Reg [31:0] mem [32];
  
  Typedef enum {idle = 0, setup = 1, access = 2, transfer = 3} state_type;

  State_type state = idle; 
  
  always@(posedge pclk)
    begin
      if(presetn == 1’b0) //active low 
        begin
        state <= idle;
        prdata <= 32’h00000000;
        pready <= 1’b0;
        pslverr <= 1’b0;
        
        for(int I = 0; I < 32; i++) 
        begin
          mem[i] <= 0;
        end
        
       end 
      else 
        begin
    
      case(state)
      idle : 
      begin
        prdata <= 32’h00000000;
        pready <= 1’b0;
        pslverr <= 1’b0;
        
        if((psel == 1’b0) && (penable == 1’b0)) 
            begin
            state <= setup;
            end
      end
      
      setup: ///start of transaction
      begin
           if((psel == 1’b1) && (penable == 1’b0)) begin
            if(paddr < 32) begin 
            state <= access;
            pready <= 1’b1;
            end
            else
            begin
            state <= access;
            pready <= 1’b0;
            end
           end
            else
            state <= setup;
      end
        
      access: 
      begin 
        if(psel && pwrite && penable) 
          begin
            if(paddr < 32) 
            begin
            mem[paddr] <= pwdata;
            state <= transfer;
            pslverr <= 1’b0;
            end
            else 
            begin
            state <= transfer;
            pready <= 1’b1;
            pslverr <= 1’b1;
            end
          end
        else if ( psel && !pwrite && penable)
            begin
            if(paddr < 32) 
            begin
            prdata <= mem[paddr];
            state <= transfer;
            pready <= 1’b1;
            pslverr <= 1’b0;
            end
            else 
            begin
            state <= transfer;
            pready <= 1’b1;
            pslverr <= 1’b1;
            prdata <= 32’hxxxxxxxx;
            end
          end
       end      
        transfer: begin
          state <= setup;
          pready <= 1’b0;
          pslverr <= 1’b0;
        end
        
  
      
      default : state <= idle;
   
      endcase
      
    end
  end
dut cc(.Ipresetn(Ipresetn),
       .pclk(pclk),
       .psel(psel),
       .penable(penable),
       .pwrite(pwrite),
       .paddr(paddr), .pwdata(pwdata),
       .prdata(prdata),
       .pready(pready), 
       .pslverr(pslverr)
);
intial begin
  $dumpfile(dut.vcd);
  $dumpvars(0,dut_test);
  pclk=0
  forever begin
  #5 pclk=~pclk
  end
end
endmodule
