using Distributed
# machine = [("remote_machine", X)] # X is number of cores used
# addprocs(machine, dir = "/user/dir", exename="/path/to/julia")
using DelimitedFiles
using Random
Random.seed!(0)
@everywhere using StochasticPrograms
@everywhere using Dates
@everywhere using BenchmarkTools
@everywhere using Distributions
@everywhere using Gurobi

# SSN implemented purely in StochasticPrograms.jl
include("ssn/ssn.jl")
# Alternatively load SSN from SMPS files
#ssn = read("ssn_smps/ssn.smps", StochasticModel)
#ssn_sampler = read("ssn_smps/ssn.smps", SMPSSampler)

const gurobi = Gurobi.Optimizer
const ssn_instance = instantiate(ssn, ssn_sampler, 1)
const x₀ = rand(num_decisions(ssn_instance))

function lshaped()
    opt = LShaped.Optimizer()
    MOI.set(opt, MasterOptimizer(), Gurobi.Optimizer)
    MOI.set(opt, RawMasterOptimizerParameter("OutputFlag"), 0)
    MOI.set(opt, RawMasterOptimizerParameter("Threads"), 4)
    MOI.set(opt, RawMasterOptimizerParameter("BarConvTol"), 1e-2)
    MOI.set(opt, RawSubproblemOptimizerParameter("BarConvTol"), 1e-2)
    MOI.set(opt, SubproblemOptimizer(), () -> Gurobi.Optimizer(OutputFlag = 0))
    MOI.set(opt, RelativeTolerance(), 1e-2)
    MOI.set(opt, MOI.Silent(), true)
    return opt
end

function tr_with_partial_aggregation()
    opt = LShaped.Optimizer()
    MOI.set(opt, MasterOptimizer(), Gurobi.Optimizer)
    MOI.set(opt, RawMasterOptimizerParameter("OutputFlag"), 0)
    MOI.set(opt, RawMasterOptimizerParameter("Threads"), 4)
    MOI.set(opt, RawMasterOptimizerParameter("BarConvTol"), 1e-2)
    MOI.set(opt, RawSubproblemOptimizerParameter("BarConvTol"), 1e-2)
    MOI.set(opt, SubproblemOptimizer(), () -> Gurobi.Optimizer(OutputFlag = 0))
    MOI.set(opt, RelativeTolerance(), 1e-2)
    MOI.set(opt, Regularizer(), TR())
    MOI.set(opt, Aggregator(), PartialAggregate(36))
    MOI.set(opt, MOI.Silent(), true)
    return opt
end

function lv_with_kmedoids_aggregation()
    opt = LShaped.Optimizer()
    MOI.set(opt, MasterOptimizer(), Gurobi.Optimizer)
    MOI.set(opt, RawMasterOptimizerParameter("OutputFlag"), 0)
    MOI.set(opt, RawMasterOptimizerParameter("Threads"), 4)
    MOI.set(opt, RawMasterOptimizerParameter("BarConvTol"), 1e-2)
    MOI.set(opt, RawSubproblemOptimizerParameter("BarConvTol"), 1e-2)
    MOI.set(opt, SubproblemOptimizer(), () -> Gurobi.Optimizer(OutputFlag = 0))
    MOI.set(opt, RelativeTolerance(), 1e-2)
    MOI.set(opt, Regularizer(), LV())
    MOI.set(opt, Aggregator(), ClusterAggregate(Kmedoids(20, distance = angular_distance), lock_after = (τ,n) -> n > 5))
    MOI.set(opt, MOI.Silent(), true)
    return opt
end

function adaptive_progressive_hedging()
    opt = ProgressiveHedging.Optimizer()
    MOI.set(opt, SubproblemOptimizer(), () -> Gurobi.Optimizer(OutputFlag = 0))
    MOI.set(opt, RawSubproblemOptimizerParameter("BarConvTol"), 1e-2)
    MOI.set(opt, Penalizer(), Adaptive())
    MOI.set(opt, PrimalTolerance(), 1e-3)
    MOI.set(opt, DualTolerance(), 1e-2)
    MOI.set(opt, MOI.Silent(), true)
    return opt
end

function prepare(model::StochasticModel,
                 sampler::AbstractSampler,
                 x₀::AbstractVector;
                 num_scenarios::Integer = 10,
                 num_samples::Integer = 5,
                 solvers::Vector = [],
                 timeout::Int = 6000)
    length(solvers) > 0 || error("No solvers provided")
    benchmarks = BenchmarkGroup()
    for optimizer in solvers
        sp = instantiate(model, sampler, 1, optimizer = optimizer)
        name = optimizer_name(sp)
        solve_time = @elapsed begin
            sp = instantiate(model,
                             sampler,
                             num_scenarios;
                             optimizer = optimizer)
            set_optimizer_attribute(sp, MOI.Silent(), false)
            optimize!(sp, crash = Crash.Custom(x₀))
        end
        max_time = min((num_samples + 1) * solve_time, timeout)
        benchmarks[name] = @benchmarkable(optimize!(sp, crash = Crash.Custom($x₀));
                                          seconds = max_time,
                                          samples = num_samples,
                                          setup = (sp = instantiate($model,
                                                                    $sampler,
                                                                    $num_scenarios;
                                                                    optimizer = $optimizer)))
    end
    return benchmarks
end

function benchmark(bm::BenchmarkGroup, filename = "benchmark-$(now()).json")
    result = run(bm, verbose = true)
    BenchmarkTools.save(filename, result)
    return result
end

# Sample code to generate and run benchmarks
#bm = prepare(ssn, ssn_sampler, x₀, solvers = [lshaped, tr_with_partial_aggregation, lv_with_kmedoids_aggregation], num_scenarios = 6000)
#res = benchmark(bm, "ls_X.json") # X is number of cores used
