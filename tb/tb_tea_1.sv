// -----------------------------------------------------------------------------
// Testbench of Tiny Encryption Algorithm's module for corner cases check
// -----------------------------------------------------------------------------

module tb_tea_1; 

  // clock - 10 ns
  reg clk = 1'b0;
  always #5 clk = !clk; 
  
  // rst_n signal
  reg rst_n = 1'b0;
  
  // Triggering of rst_n signal
  initial begin 
    @(posedge clk) rst_n = 1'b1;
  end
  
  localparam NUL_CHAR = 8'h00; 

  reg	            key_valid   = 1'b0;     // 1 = input data stable and valid, 0 = o.w.
  reg		    ptxt_valid  = 1'b0;     // 1 = input data stable and valid, 0 = o.w.
  reg      [63:0]   ptxt_blk    = NUL_CHAR; // plaintext
  reg      [127:0]  key         = NUL_CHAR; // key
  reg      [63:0]   expected_ct = NUL_CHAR; // expected ciphertext (from tv)
  
  wire     [63:0]   ctxt_blk;               // ciphertext
  wire	            ctxt_ready;             // 1 = output data stable and valid, 0 o.w.
  
 
  // Module instantiation with input and output ports 
  tiny_encryption_algorithm INSTANCE_NAME (
     .clk                       (clk)
    ,.rst_n                     (rst_n)
    ,.key_valid                 (key_valid)
    ,.ptxt_valid                (ptxt_valid)
    ,.ptxt_blk                  (ptxt_blk)
    ,.key                       (key)
    ,.ctxt_blk                  (ctxt_blk)
    ,.ctxt_ready                (ctxt_ready)
  );
    

initial begin

	@(posedge clk); 
	// Set to ptxt_blk, key and expected_ct values that will be used to run the tests
	ptxt_blk    = 64'h0000000000000000;
	key         = 128'h80000000000000000000000000000000;		
	expected_ct = 64'h9327C49731B08BBE;

	// PTXT_VALID = 1 - KEY_VALID = 1
	@(posedge clk); 
	ptxt_valid = 1'b1;
	key_valid  = 1'b1;

	@(posedge clk); //at this moment the temporary register tmp_ctxt_ready is ready
	@(posedge clk);	//at this moment the output register ctxt_ready is ready	
	$display("PTXT_VALID: %b - KEY_VALID: %b - CTXT_READY: %b - %-5s", ptxt_valid, key_valid, ctxt_ready, ctxt_ready === 1'b1 ? "OK" : "ERROR");


	// PTXT_VALID = 0 - KEY_VALID = 0
	@(posedge clk);
	ptxt_valid = 1'b0;
	key_valid  = 1'b0;

	@(posedge clk); 
	@(posedge clk);
	$display("PTXT_VALID: %b - KEY_VALID: %b - CTXT_READY: %b - %-5s", ptxt_valid, key_valid, ctxt_ready, ctxt_ready === 1'b0 ? "OK" : "ERROR");


	// PTXT_VALID = 1 - KEY_VALID = 0
	@(posedge clk);
	ptxt_valid = 1'b1;
	key_valid  = 1'b0;

	@(posedge clk); 
	@(posedge clk);
	$display("PTXT_VALID: %b - KEY_VALID: %b - CTXT_READY: %b - %-5s", ptxt_valid, key_valid, ctxt_ready, ctxt_ready === 1'b0 ? "OK" : "ERROR");


	// PTXT_VALID = 0 - KEY_VALID = 1
	@(posedge clk);
	ptxt_valid = 1'b0;
	key_valid  = 1'b1;

	@(posedge clk); 
	@(posedge clk);
	$display("PTXT_VALID: %b - KEY_VALID: %b - CTXT_READY: %b - %-5s", ptxt_valid, key_valid, ctxt_ready, ctxt_ready === 1'b0 ? "OK" : "ERROR");

	$stop;
end

endmodule
