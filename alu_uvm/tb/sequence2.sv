/* ==========================================================================
   Author:      Nikita Agrawal (NIT Bhopal | ex-Intel)
   Copyright:   (c) 2026 Nikita Agrawal
   License:     MIT License (see LICENSE file in root)
   ========================================================================== */

class alu_directed_seq extends uvm_sequence#(alu_item);
    `uvm_object_utils(alu_directed_seq)

    alu_item tr;

    function new(string name = "alu_directed_seq");
        super.new(name);
    endfunction

    task body();
        `uvm_info(get_type_name(), "Starting directed Stimulus for all ports...", UVM_LOW)
      
      //Forcing an Overflow
      `uvm_do_with(tr,{tr.a==7;tr.b==1;tr.op==3'b000;}) 
      
      //forcing a carry
      `uvm_do_with(tr,{tr.a == 15;tr.b==1;tr.op==3'b000;})
      
      //forcing a zero through subtraction
      `uvm_do_with(tr,{tr.a ==10; tr.b==10;tr.op==3'b001;})
      
      
      `uvm_do_with(tr,{tr.a==8;tr.b==8; tr.op==3'b000;})
      
      `uvm_do_with(tr,{tr.a==0; tr.b==1; tr.op==3'b000;})
      
      //walking ones 
      `uvm_do_with (tr,{tr.a==1; tr.b==0; tr.op==3'b011;})
      `uvm_do_with (tr,{tr.a==2; tr.b==0; tr.op==3'b011;})
      `uvm_do_with (tr,{tr.a==4; tr.b==0; tr.op==3'b011;})
      `uvm_do_with (tr,{tr.a==8; tr.b==0; tr.op==3'b011;})
      
      //shift boundary
      `uvm_do_with(tr,{tr.a==8;tr.b==0;tr.op==3'b110;})
      `uvm_do_with(tr,{tr.a==1;tr.b==0;tr.op==3'b111;})
      
      //Bitwise integrity
      
      `uvm_do_with(tr,{tr.a==1010;tr.b==0101;tr.op==3'b011;})
      
    endtask

endclass
/* ==========================================================================
   End of File - Developed by Nikita Agrawal (NIT Bhopal | ex-Intel)
   ========================================================================== */