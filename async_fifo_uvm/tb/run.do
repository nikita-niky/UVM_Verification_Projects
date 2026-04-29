# 2. RUN TEST 1

asim +access+r -acdb work.tb_top +UVM_TESTNAME=fifo_directed_test
run -all
acdb save -o directed.acdb
endsim

# 3. RUN TEST 2
asim +access+r -acdb work.tb_top +UVM_TESTNAME=fifo_random_test
run -all
acdb save -o random.acdb
endsim

# 4. RUN TEST 3
asim +access+r -acdb work.tb_top +UVM_TESTNAME=fifo_ovfl_test
run -all
acdb save -o ovfl.acdb
endsim

# 4. RUN TEST 4
asim +access+r -acdb work.tb_top +UVM_TESTNAME=fifo_udfl_test
run -all
acdb save -o udfl.acdb
endsim

# RUN TEST 5

asim +access+r -acdb work.tb_top +UVM_TESTNAME=fifo_stress_test
run -all
acdb save -o stress.acdb
endsim

# RUN TEST 6
asim +access+r -acdb work.tb_top +UVM_TESTNAME=fifo_reset_op_test
run -all
acdb save -o reset.acdb
endsim


# 5. MERGE AND REPORT
# On EDA Playground, we'll output a text report so you can see it in the log
puts "Merging coverage..."
acdb merge -o final.acdb -i directed.acdb -i random.acdb -i ovfl.acdb -i udfl.acdb -i stress.acdb -i reset.acdb
acdb report -db final.acdb -txt -o coverage_summary.txt

# This command prints the report to your EDA Playground console
exec cat coverage_summary.txt
