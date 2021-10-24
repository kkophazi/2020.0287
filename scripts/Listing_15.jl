# Prepare distributed environment
using Distributed
# Add workers
addprocs(2)
# Load SPjl framework
@everywhere using StochasticPrograms
# Load GLPK optimizer
using GLPK
# Create simple stochastic model
@stochastic_model simple begin
  @stage 1 begin
      @decision(simple, x₁ >= 40)
      @decision(simple, x₂ >= 20)
      @objective(simple, Min, 100*x₁ + 150*x₂)
      @constraint(simple, x₁+x₂ <= 120)
  end
  @stage 2 begin
      @uncertain q₁ q₂ d₁ d₂
      @recourse(simple, 0 <= y₁ <= d₁)
      @recourse(simple, 0 <= y₂ <= d₂)
      @objective(simple, Max, q₁*y₁ + q₂*y₂)
      @constraint(simple, 6*y₁ + 10*y₂ <= 60*x₁)
      @constraint(simple, 8*y₁ + 5*y₂ <= 80*x₂)
  end
end
# Create two scenarios
ξ₁ = @scenario q₁ = 24.0 q₂ = 28.0 d₁ = 500.0 d₂ = 100.0 probability = 0.4
ξ₂ = @scenario q₁ = 28.0 q₂ = 32.0 d₁ = 300.0 d₂ = 300.0 probability = 0.6
# Instantiate with an L-shaped optimizer, the
# resulting stochastic program is automatically
# distributed on the worker cores
sp = instantiate(simple, [ξ₁, ξ₂], optimizer = LShaped.Optimizer)
# Set GLPK optimizer for the solving master problem and subproblems
set_optimizer_attribute(sp, MasterOptimizer(), GLPK.Optimizer)
set_optimizer_attribute(sp, SubProblemOptimizer(), GLPK.Optimizer)
# Optimize (in parallel)
optimize!(sp)
# Check termination status and query optimal value
@show termination_status(sp)
@show objective_value(sp)
