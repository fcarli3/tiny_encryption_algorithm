//Tiny Encryption Algorithm module with input and output ports
module tiny_encryption_algorithm (
   input              clk        // clock
  ,input              rst_n      // asynchronous reset active low 
  ,input              key_valid  // 1 = input data stable and valid, 0 = o.w.
  ,input	      ptxt_valid // 1 = input data stable and valid, 0 = o.w.
  ,input      [63:0]  ptxt_blk   // plaintext
  ,input      [127:0] key        // key
  
  ,output reg [63:0]  ctxt_blk   // ciphertext
  ,output reg	      ctxt_ready // 1 = output data stable and valid, 0 o.w.
);

// ---------------------------------------------------------------------------
// Variables
// ---------------------------------------------------------------------------
localparam DELTA    = 32'h9e3779b9; // key schedule constant 
localparam NUL_CHAR = 8'h00; 

//Registers for left shift
reg [31:0] in_l;
reg [31:0] out_l;

//Registers for right shift
reg [31:0] in_r;
reg [31:0] out_r;

//Registers for sum
reg [32:0] s0;
reg [32:0] s1;
reg [32:0] s2;
reg [32:0] s3;
reg [32:0] s;

reg [31:0] xor_res;

// Registers for processing
reg [31:0] ptxt_a, ptxt_b;
reg [63:0] ctxt;
reg [31:0] key0, key1, key2, key3;
reg [31:0] v0, v1, sum; 
reg        tmp_ctxt_ready;

integer i;

// ---------------------------------------------------------------------------
// Logic Design
// ---------------------------------------------------------------------------

// Encryption algorithm 
always @ (*) begin
	//Encryption is executed only if ptxt_blk and key are available and consistent
	if(ptxt_valid && key_valid) begin
		ptxt_a = ptxt_blk[63:32];
		ptxt_b = ptxt_blk[31:0];

		// Key scheduling
		key3 = key[31:0];
		key2 = key[63:32];
		key1 = key[95:64];
		key0 = key[127:96];
		
		v0 = ptxt_a;	
		v1 = ptxt_b;
		sum = 32'd0;
		
		// Loop to simulate 32 encryption rounds 
		for(i = 0; i < 32; i++) begin
		
			s  = 33'd0;
			s0 = 33'd0;
			s1 = 33'd0;
			s2 = 33'd0;
			s3 = 33'd0;
			
			// Delta increments
			s = sum + DELTA; 
			sum = s[31:0];
			
			// Left shift
			in_l = v1;
			in_r = v1;
			out_l = {in_l[27:0], 4'd0};
			out_r = {5'd0, in_r[31:5]};
			
			// Partial sums, their results will be combined with a xor operator
			s1 = out_l + key0;
			s2 = v1 + sum;
			s3 = out_r + key1;
			
			xor_res = (s1[31:0]) ^ (s2[31:0]) ^ (s3[31:0]);
			
			// Update v0
			s0 = v0 + xor_res;
			v0 = s0[31:0];
			
			// *****************************************************
			
			// Right shift
			in_l = v0;
			in_r = v0;
			out_l = {in_l[27:0], 4'd0};
			out_r = {5'd0, in_r[31:5]};
			
			// Partial sums, their results will be combined with a xor operator
			s1 = out_l + key2;
			s2 = v0 + sum;
			s3 = out_r + key3;
			
			xor_res = (s1[31:0]) ^ (s2[31:0]) ^ (s3[31:0]);
			
			// Update v1
			s0 = v1 + xor_res;
			v1 = s0[31:0];
			
		end
		
		// Temporary registers that store the computed ct and its validity flag
		ctxt [63:32] = v0;
		ctxt [31:0]  = v1;
		tmp_ctxt_ready = 1'b1;
	end
	else begin
	
		// Branch in which key and/or ptxt_blk are not available and consistent
		ptxt_a = NUL_CHAR;
		ptxt_b = NUL_CHAR;
		
		key0   = NUL_CHAR;
		key1   = NUL_CHAR;
		key2   = NUL_CHAR;
		key3   = NUL_CHAR;
		
		v0     = NUL_CHAR;
		v1     = NUL_CHAR;
		sum    = 32'd0;
		
		i      = 0;
		
		s      = 33'd0;
		s0     = 33'd0;
		s1     = 33'd0;
		s2     = 33'd0;
		s3     = 33'd0;
		
		in_l   = NUL_CHAR;
		out_l  = NUL_CHAR;
		in_r   = NUL_CHAR;
		out_r  = NUL_CHAR;
		
		xor_res = NUL_CHAR;
		
		ctxt   = NUL_CHAR;
		tmp_ctxt_ready = 1'b0;
	end
end
	
	
always @(posedge clk or negedge rst_n) begin
	// Handling the rst_n signal
	if(!rst_n) begin
		ctxt_ready <= 1'b0;
		ctxt_blk   <= NUL_CHAR;
	end
    else begin
		// Handling outputs of the module
		if(tmp_ctxt_ready) begin
			// Branch in which the ct has been computed properly
			ctxt_ready <= 1'b1;
			ctxt_blk   <= ctxt;
		end
		else begin
			// Branch in which the ct hasn't been computed properly 
			ctxt_ready <= 1'b0;
			ctxt_blk   <= NUL_CHAR;
		end
	end
end

endmodule
