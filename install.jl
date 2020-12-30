# Installs necessary packages. Note that Gurobi requires a License. Otherwise, Gurobi
# can be replaced with any other LP/QP capable JuMP solver: https://jump.dev/JuMP.jl/dev/installation/#Getting-Solvers-1
using Pkg
Pkg.add("StochasticPrograms")
Pkg.add("Distributions")
Pkg.add("BenchmarkTools")
Pkg.add("Gurobi")
Pkg.add("GLPK")
