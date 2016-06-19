vlog -f file.f
vsim -novopt work.test

add wave sim:/test/th99chls_inst/*
add wave sim:/test/th99chls_inst/filter_inst/*
add wave sim:/test/th99chls_inst/timer_inst/*

run 2000ns
