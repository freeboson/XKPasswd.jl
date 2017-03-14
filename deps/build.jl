#cd(@__DIR__)
using Git

cd(dirname(@__FILE__))
Git.run(`submodule init`)
Git.run(`submodule update`)

