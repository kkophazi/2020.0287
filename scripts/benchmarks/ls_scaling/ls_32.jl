using Distributed
addprocs(32)

include("../benchmark.jl")

bm = prepare(ssn, ssn_sampler, x₀, solvers = [lshaped, lv_with_kmedoids_aggregation], num_scenarios = 6000)
res = benchmark(bm, "ls_32.json")
