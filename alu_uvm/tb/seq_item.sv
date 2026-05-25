/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

typedef enum logic [2:0] {
  ADD = 3'b000,
  SUB = 3'b001,
  AND = 3'b010,
  OR  = 3'b011,
  XOR = 3'b100,
  NOT = 3'b101,
  SHL = 3'b110,
  SHR = 3'b111
} alu_op_e;

class alu_item extends uvm_sequence_item;
 
  rand logic [3:0] a;
  rand logic [3:0] b;
  rand alu_op_e    op;
  
       logic       rst;
       logic [3:0] res;
       logic       carry;
       logic       zero;
       logic       neg;
       logic       ovfl;
       
  
  `uvm_object_utils(alu_item)

  constraint c_interesetin_values {
  
    a inside {[0:15]};
    b inside {[0:15]};
  
    a dist {0:/20, 15:/20,[1:14]:/60};
    b dist {0:/20, 15:/20,[1:14]:/60}; 
  }
  
  function new(string name = "alu_item");
    super.new(name);
  endfunction  

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */
