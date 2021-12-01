# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog polynomial.v

#load simulation using mux as the top level simulation module
vsim part2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# test case
#set input values using the force command, signal names need to be in {} brackets

force Clock 0 0ns, 1 {5ns} -r 10ns


#resetn
force Resetn 0
force Go 0
force DataIn 0
run 10ns


# load A = 5
force Resetn 1
force Go 1
force DataIn 8'd5
run 10ns
force Resetn 1
force Go 0
force DataIn 8'd4
run 10ns


# load B = 4
force Resetn 1
force Go 1
force DataIn 8'd4
run 10ns
force Resetn 1
force Go 0
force DataIn 8'd3
run 10ns


# load C = 3
force Resetn 1
force Go 1
force DataIn 8'd3
run 10ns
force Resetn 1
force Go 0
force DataIn 8'd2
run 10ns


# load x = 2
force Resetn 1
force Go 1
force DataIn 8'd2
run 10ns
force Resetn 1
force Go 0
force DataIn 8'd0
run 10ns

# compute
run 40ns
