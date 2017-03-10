#cd(@__DIR__)
cd(Pkg.dir("xkpasswd"))
run(`git submodule init`)
run(`git submodule update`)

