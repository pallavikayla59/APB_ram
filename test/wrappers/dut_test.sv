module apb_ram_test;
  
  reg Ipresetn;
  reg pclk;
  reg psel;
  reg penable;
  reg pwrite;
  reg [31:0] paddr, pwdata;
  wire [31:0] prdata;
  wire pready, pslverr;

  // Instantiate the DUT (APB RAM)
  dut cc(
    .presetn(Ipresetn),
    .pclk(pclk),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .paddr(paddr), .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready), 
    .pslverr(pslverr)
  );

  initial begin
    $dumpfile("dut_test.vcd");
    $dumpvars(0, apb_ram_test);
    pclk = 0;
    forever #5 pclk = ~pclk;
  end

  // Your test stimuli here.

endmodule
