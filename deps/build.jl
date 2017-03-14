#cd(@__DIR__)
cd(dirname(@__FILE__))
run(`git submodule init`)
run(`git submodule update`)

