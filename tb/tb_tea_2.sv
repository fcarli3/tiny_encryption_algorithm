// -----------------------------------------------------------------------------
// Testbench of Tiny Encryption Algorithm's module for debug 
// -----------------------------------------------------------------------------

module tb_tea_2; 

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

  reg		    key_valid   = 1'b0;     // 1 = input data stable and valid, 0 = o.w.
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
  
  // File descriptor 
  integer  key_file;
  integer  pt_file;
  integer  ct_file;
  integer  scan_file = 0;
 
  // Temporary registers that store a value read from a specific file
  reg [127:0] tmp_key = NUL_CHAR;
  reg [63:0]  tmp_pt  = NUL_CHAR;
  reg [63:0]  tmp_ct  = NUL_CHAR;
 
  `define NULL 0    

  // Block where the files of the test vector will be open in read mode
  initial begin
	key_file = $fopen("tv/tv_keys.txt", "r");
	pt_file = $fopen("tv/tv_pt.txt", "r");
	ct_file = $fopen("tv/tv_ct.txt", "r");
	if (key_file == `NULL) begin
		$display("key_file handle was NULL");
		$stop;
	end
	 if (pt_file == `NULL) begin
		$display("pt_file handle was NULL");
		$stop;
	end
	if (ct_file == `NULL) begin
		$display("ct_file handle was NULL");
		$stop;
	end
	$display("    PLAINTEXT   |   CIPHERTEXT   | EXPECTED CIPHERTEXT");
  end


  always @(posedge clk) begin
	// Reading pt, key and expected ct from specific files
	scan_file = $fscanf(key_file, "%h\n", tmp_key); 
	scan_file = $fscanf(pt_file, "%h\n", tmp_pt);
	scan_file = $fscanf(ct_file, "%h\n", tmp_ct);
	
	// Check if EOF is not reached yet for all the files of the test vector
	if (!$feof(key_file) && !$feof(pt_file) && !$feof(ct_file)) begin
	
		// Set the input ports of the module 
		@(posedge clk); 
		ptxt_blk    = tmp_pt;
		key         = tmp_key;
		ptxt_valid  = 1'b1;
		key_valid   = 1'b1;
		
		expected_ct = tmp_ct;

		@(posedge clk); 
		// Reset the validity flags for the next test
		ptxt_valid = 1'b0;
		key_valid  = 1'b0;
		// Waiting until the computed ciphertext is available 
		wait (ctxt_ready === 1'b1);
		
		@(posedge clk); 
		$display("%h %h %h %-5s", ptxt_blk, ctxt_blk, expected_ct, expected_ct === ctxt_blk ? "OK" : "ERROR");
	end
	else begin
		$display("End of files");
		$stop;
	end
  end  

endmodule
