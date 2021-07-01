using Distributed

include("benchmark.jl")

bm = prepare(ssn, ssn_sampler, x₀, solvers = [gurobi], num_scenarios = 6000)
res = benchmark(bm, "deterministic.json")
