# Define the three yield scenarios
Crops = [:wheat, :corn, :beets]
ξ₁ = @scenario ξ[c in Crops] = [3.0, 3.6, 24.0] probability = 1/3
ξ₂ = @scenario ξ[c in Crops] = [2.5, 3.0, 20.0] probability = 1/3
ξ₃ = @scenario ξ[c in Crops] = [2.0, 2.4, 16.0] probability = 1/3
# Instantiate with GLPK optimizer
farmer_problem = instantiate(farmer, [ξ₁,ξ₂,ξ₃], optimizer = GLPK.Optimizer)
# Optimize stochastic program (through extensive form)
optimize!(farmer_problem)
# Inspect optimal decision
@show x̂ = optimal_decision(farmer_problem)
# Inspect optimal value
@show objective_value(farmer_problem)
# Calculate expected value of perfect information
@show EVPI(farmer_problem)
# Calculate value of the stochastic solution
@show VSS(farmer_problem)
# Initialize with vertical structure
farmer_ls = instantiate(farmer, [ξ₁,ξ₂,ξ₃], optimizer = LShaped.Optimizer)
# Set GLPK optimizer for the solving master problem
set_optimizer_attribute(farmer_ls, MasterOptimizer(), GLPK.Optimizer)
# Set GLPK optimizer for the solving subproblems
set_optimizer_attribute(farmer_ls, SubProblemOptimizer(), GLPK.Optimizer)
# Solve using L-shaped
optimize!(farmer_ls)
# Initialize with horizontal structure
farmer_ph = instantiate(farmer, [ξ₁,ξ₂,ξ₃],
                      optimizer = ProgressiveHedging.Optimizer)
# Set Ipopt optimizer for soving emerging subproblems
set_optimizer_attribute(farmer_ph, SubProblemOptimizer(), Ipopt.Optimizer)
# Silence Ipopt
set_optimizer_attribute(farmer_ph, RawSubProblemOptimizerParameter("print_level"), 0
# Solve using progressive-hedging
optimize!(farmer_ph)
