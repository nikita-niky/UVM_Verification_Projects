# 1. Start logging the console output to a file
transcript file simulation.log

# 2. Run the simulation
vsim +access+r;
run -all;

# 3. Handle coverage as you already were
acdb save;
acdb report -db fcover.acdb -txt -o cov.txt -verbose;

# 4. Display both in the console so you can see them immediately
exec cat cov.txt;
exec cat simulation.log;

# 5. Close the log and exit
transcript off;
exit