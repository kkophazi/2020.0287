include("../benchmark.jl")

bm = prepare(ssn, ssn_sampler, x₀, solvers = [lshaped, tr_with_partial_aggregation, lv_with_kmedoids_aggregation], num_scenarios = 6000, num_samples = 1)
res = benchmark(bm, "ls_1.json")
