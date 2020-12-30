#!/bin/sh
wget https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-1.5.3-linux-x86_64.tar.gz
tar -xvf julia-1.5.3-linux-x86_64.tar.gz
ln -s julia-1.5.3/bin/julia
./julia install.jl
