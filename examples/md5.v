module md5(clk,reset,load_i,ready_o,newtext_i,data_i,data_o);
input clk;
input reset;
input load_i;
output ready_o;
input newtext_i;
input [127:0] data_i;
output [127:0] data_o;

reg ready_o;
reg [127:0] data_o;

reg [31:0] ar;
reg [31:0] br;
reg [31:0] cr;
reg [31:0] dr;
reg [31:0] next_ar;
reg [31:0] next_br;
reg [31:0] next_cr;
reg [31:0] next_dr;
reg [31:0] A;
reg [31:0] B;
reg [31:0] C;
reg [31:0] D;
reg [31:0] next_A;
reg [31:0] next_B;
reg [31:0] next_C;
reg [31:0] next_D;
reg next_ready_o;
reg [127:0] next_data_o;
reg [511:0] message;
reg [511:0] next_message;
reg generate_hash;
reg hash_generated;
reg next_generate_hash;
reg [2:0] getdata_state;
reg [2:0] next_getdata_state;
reg [1:0] round;
reg [1:0] next_round;
reg [5:0] round64;
reg [5:0] next_round64;
reg [43:0] t;
reg [31:0] func_out;


//reg_signal:
always @(posedge clk or negedge reset)

   begin

   if (!reset )

      begin

      ready_o  = (0);
      data_o  = (0);
      message  = (0);

      ar  = ('h67452301);
      br  = ('hEFCDAB89 );
      cr  = ('h98BADCFE );
      dr  = ('h10325476);

      getdata_state  = (0);
      generate_hash  = (0);

      round  = (0);
      round64  = (0);

      A  = ('h67452301);
      B  = ('hEFCDAB89 );
      C  = ('h98BADCFE );
      D  = ('h10325476);


      end

   else 

      begin

      ready_o  = (next_ready_o );
      data_o  = (next_data_o );
      message  = (next_message );

      ar  = (next_ar );
      br  = (next_br );
      cr  = (next_cr );
      dr  = (next_dr );

      A  = (next_A );
      B  = (next_B );
      C  = (next_C );
      D  = (next_D );

      generate_hash  = (next_generate_hash );
      getdata_state  = (next_getdata_state );

      round  = (next_round );
      round64  = (next_round64 );


      end



   end
//md5_getdata:
reg[127:0] data_o_varmd5_getdata;
reg[511:0] auxmd5_getdata;
reg[31:0] A_tmd5_getdata,B_tmd5_getdata,C_tmd5_getdata,D_tmd5_getdata;
always @(  newtext_i or   data_i or   load_i or   getdata_state or   hash_generated or   message or   func_out or   A or   B or   C or   D or   ar or   br or   cr or   dr or   generate_hash)

   begin







   next_A  = (A );
   next_B  = (B );
   next_C  = (C );
   next_D  = (D );

   next_generate_hash  = (0);
   next_ready_o  = (0);
   next_data_o  = (0);

   auxmd5_getdata =message ;
   next_message  = (message );
   next_getdata_state  = (getdata_state );

   if (newtext_i )

      begin

      next_A  = ('h67452301);
      next_B  = ('hEFCDAB89 );
      next_C  = ('h98BADCFE );
      next_D  = ('h10325476);
      next_getdata_state  = (0);

      end



   case(   getdata_state )


      0 :
      begin
      if (load_i )

         begin

         auxmd5_getdata [511:384]=data_i ;
         next_message  = (auxmd5_getdata );
         next_getdata_state  = (1);

         end

      end
      1 :
      begin
      if (load_i )

         begin

         auxmd5_getdata [383:256]=data_i ;
         next_message  = (auxmd5_getdata );
         next_getdata_state  = (2);

         end

      end
      2 :
      begin
      if (load_i )

         begin

         auxmd5_getdata [255:128]=data_i ;
         next_message  = (auxmd5_getdata );
         next_getdata_state  = (3);

         end

      end
      3 :
      begin
      if (load_i )

         begin

         auxmd5_getdata [127:0]=data_i ;
         next_message  = (auxmd5_getdata );
         next_getdata_state  = (4);
         next_generate_hash  = (1);

         end

      end
      4 :
      begin
      next_generate_hash  = (1);

      A_tmd5_getdata =dr +A ;
      B_tmd5_getdata =func_out +B ;
      C_tmd5_getdata =br +C ;
      D_tmd5_getdata =cr +D ;

      data_o_varmd5_getdata [127:96]=A_tmd5_getdata ;
      data_o_varmd5_getdata [95:64]=B_tmd5_getdata ;
      data_o_varmd5_getdata [63:32]=C_tmd5_getdata ;
      data_o_varmd5_getdata [31:0]=D_tmd5_getdata ;
      next_data_o  = (data_o_varmd5_getdata );


      if (hash_generated )

         begin

         next_A  = (A_tmd5_getdata );
         next_B  = (B_tmd5_getdata );
         next_C  = (C_tmd5_getdata );
         next_D  = (D_tmd5_getdata );
         next_getdata_state  = (0);
         next_ready_o  = (1);
         next_generate_hash  = (0);

         end

      end

      endcase



   end
//round64FSM:
always @(  newtext_i or   round or   round64 or   ar or   br or   cr or   dr or   generate_hash or   func_out or   getdata_state or   A or   B or   C or   D)

   begin


   next_ar  = (ar );
   next_br  = (br );
   next_cr  = (cr );
   next_dr  = (dr );
   next_round64  = (round64 );
   next_round  = (round );
   hash_generated  = (0);

   if (generate_hash !=0)

      begin

      next_ar  = (dr );
      next_br  = (func_out );
      next_cr  = (br );
      next_dr  = (cr );

      end



   case(   round64 )


      0 :
      begin
      next_round  = (0);
      if (generate_hash )

         begin

         next_round64  = (1);

         end

      end
      15      , 31      , 47 :
      begin
      next_round  = (round +1);
      next_round64  = (round64 +1);
      end
      63 :
      begin
      next_round  = (0);
      next_round64  = (0);
      hash_generated  = (1);
      end
      default:
      begin

      next_round64  = (round64 +1);
      end

      endcase


   if (newtext_i )

      begin

      next_ar  = ('h67452301);
      next_br  = ('hEFCDAB89 );
      next_cr  = ('h98BADCFE );
      next_dr  = ('h10325476);
      next_round  = (0);
      next_round64  = (0);

      end


   if (getdata_state ==0)

      begin

      next_ar  = (A );
      next_br  = (B );
      next_cr  = (C );
      next_dr  = (D );

      end


   end
//md5_rom:
always @(  round64)

   begin


   case(   round64 )

      0 :
      begin
      t  = ('hD76AA478070 );
      end
      1 :
      begin
      t  = ('hE8C7B7560C1 );
      end
      2 :
      begin
      t  = ('h242070DB112 );
      end
      3 :
      begin
      t  = ('hC1BDCEEE163 );
      end
      4 :
      begin
      t  = ('hF57C0FAF074 );
      end
      5 :
      begin
      t  = ('h4787C62A0C5 );
      end
      6 :
      begin
      t  = ('hA8304613116 );
      end
      7 :
      begin
      t  = ('hFD469501167 );
      end
      8 :
      begin
      t  = ('h698098D8078 );
      end
      9 :
      begin
      t  = ('h8B44F7AF0C9 );
      end
      10 :
      begin
      t  = ('hFFFF5BB111A );
      end
      11 :
      begin
      t  = ('h895CD7BE16B );
      end
      12 :
      begin
      t  = ('h6B90112207C );
      end
      13 :
      begin
      t  = ('hFD9871930CD );
      end
      14 :
      begin
      t  = ('hA679438E11E );
      end
      15 :
      begin
      t  = ('h49B4082116F );
      end

      16 :
      begin
      t  = ('hf61e2562051 );
      end
      17 :
      begin
      t  = ('hc040b340096 );
      end
      18 :
      begin
      t  = ('h265e5a510EB );
      end
      19 :
      begin
      t  = ('he9b6c7aa140 );
      end
      20 :
      begin
      t  = ('hd62f105d055 );
      end
      21 :
      begin
      t  = ('h244145309A );
      end
      22 :
      begin
      t  = ('hd8a1e6810EF );
      end
      23 :
      begin
      t  = ('he7d3fbc8144 );
      end
      24 :
      begin
      t  = ('h21e1cde6059 );
      end
      25 :
      begin
      t  = ('hc33707d609E );
      end
      26 :
      begin
      t  = ('hf4d50d870E3 );
      end
      27 :
      begin
      t  = ('h455a14ed148 );
      end
      28 :
      begin
      t  = ('ha9e3e90505D );
      end
      29 :
      begin
      t  = ('hfcefa3f8092 );
      end
      30 :
      begin
      t  = ('h676f02d90E7 );
      end
      31 :
      begin
      t  = ('h8d2a4c8a14C );
      end

      32 :
      begin
      t  = ('hfffa3942045 );
      end
      33 :
      begin
      t  = ('h8771f6810B8 );
      end
      34 :
      begin
      t  = ('h6d9d612210B );
      end
      35 :
      begin
      t  = ('hfde5380c17E );
      end
      36 :
      begin
      t  = ('ha4beea44041 );
      end
      37 :
      begin
      t  = ('h4bdecfa90B4 );
      end
      38 :
      begin
      t  = ('hf6bb4b60107 );
      end
      39 :
      begin
      t  = ('hbebfbc7017A );
      end
      40 :
      begin
      t  = ('h289b7ec604D );
      end
      41 :
      begin
      t  = ('heaa127fa0B0 );
      end
      42 :
      begin
      t  = ('hd4ef3085103 );
      end
      43 :
      begin
      t  = ('h4881d05176 );
      end
      44 :
      begin
      t  = ('hd9d4d039049 );
      end
      45 :
      begin
      t  = ('he6db99e50BC );
      end
      46 :
      begin
      t  = ('h1fa27cf810F );
      end
      47 :
      begin
      t  = ('hc4ac5665172 );
      end

      48 :
      begin
      t  = ('hf4292244060 );
      end
      49 :
      begin
      t  = ('h432aff970A7 );
      end
      50 :
      begin
      t  = ('hab9423a70FE );
      end
      51 :
      begin
      t  = ('hfc93a039155 );
      end
      52 :
      begin
      t  = ('h655b59c306C );
      end
      53 :
      begin
      t  = ('h8f0ccc920A3 );
      end
      54 :
      begin
      t  = ('hffeff47d0FA );
      end
      55 :
      begin
      t  = ('h85845dd1151 );
      end
      56 :
      begin
      t  = ('h6fa87e4f068 );
      end
      57 :
      begin
      t  = ('hfe2ce6e00AF );
      end
      58 :
      begin
      t  = ('ha30143140F6 );
      end
      59 :
      begin
      t  = ('h4e0811a115D );
      end
      60 :
      begin
      t  = ('hf7537e82064 );
      end
      61 :
      begin
      t  = ('hbd3af2350AB );
      end
      62 :
      begin
      t  = ('h2ad7d2bb0F2 );
      end
      63 :
      begin
      t  = ('heb86d391159 );
      end


      endcase


   end
//funcs:
reg[31:0] auxfuncs,fr_varfuncs,tr_varfuncs,rotate1funcs,rotate2funcs;
reg[7:0] s_varfuncs;
reg[3:0] nblockfuncs;
reg[31:0] message_varfuncs[15:0];
always @(  t or   ar or   br or   cr or   dr or   round or   message or   func_out)

   begin






   message_varfuncs [0]=message [511:480];
   message_varfuncs [1]=message [479:448];
   message_varfuncs [2]=message [447:416];
   message_varfuncs [3]=message [415:384];
   message_varfuncs [4]=message [383:352];
   message_varfuncs [5]=message [351:320];
   message_varfuncs [6]=message [319:288];
   message_varfuncs [7]=message [287:256];
   message_varfuncs [8]=message [255:224];
   message_varfuncs [9]=message [223:192];
   message_varfuncs [10]=message [191:160];
   message_varfuncs [11]=message [159:128];
   message_varfuncs [12]=message [127:96];
   message_varfuncs [13]=message [95:64];
   message_varfuncs [14]=message [63:32];
   message_varfuncs [15]=message [31:0];

   fr_varfuncs =0;


   case(   round )

      0 :
      begin
      fr_varfuncs =((br &cr )|(~br &dr ));
      end
      1 :
      begin
      fr_varfuncs =((br &dr )|(cr &(~dr )));
      end
      2 :
      begin
      fr_varfuncs =(br ^cr ^dr );
      end
      3 :
      begin
      fr_varfuncs =(cr ^(br |~dr ));
      end
      default:
      begin

      end

      endcase


   tr_varfuncs =t [43:12];
   s_varfuncs =t [11:4];
   nblockfuncs =t [3:0];

   auxfuncs =(ar +fr_varfuncs +message_varfuncs [nblockfuncs ]+tr_varfuncs );

//   cout <<round64 <<<<fr_varfuncs <<<<auxfuncs <<<<nblockfuncs <<<<message_varfuncs [nblockfuncs ]<<endl ;

   rotate1funcs =auxfuncs <<s_varfuncs ;
   rotate2funcs =auxfuncs >>(32-s_varfuncs );
   func_out  = (br +(rotate1funcs |rotate2funcs ));


   end

endmodule
