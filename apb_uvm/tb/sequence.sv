class apb_base_seq extends uvm_sequence #(apb_item);
  `uvm_object_utils(apb_base_seq)
  apb_item tr;

  function new(string name = "apb_base_seq");
    super.new(name);
  endfunction

  // Helper task to simplify sequences
  task do_write(logic [31:0] addr, logic [31:0] data);
    tr = apb_item::type_id::create("tr");
    start_item(tr);
    if (!tr.randomize() with { addr == local::addr; data == local::data; write_en == 1; }) begin
      `uvm_error("SEQ_WR", "Randomization failed")
    end
    finish_item(tr);
  endtask

  task do_read(logic [31:0] addr);
    tr = apb_item::type_id::create("tr");
    start_item(tr);
    if (!tr.randomize() with { addr == local::addr; write_en == 0; }) begin
      `uvm_error("SEQ_RD", "Randomization failed")
    end
    finish_item(tr);
  endtask
endclass