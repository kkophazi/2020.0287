# Instantiate with L-shaped optimizer
sp = instantiate(simple_model, [ξ₁, ξ₂], optimizer = LShaped.Optimizer)
# Print to compare structure of generated problem
print(sp)
# Set GLPK optimizer for the solving master problem and subproblems
set_optimizer_attribute(sp, MasterOptimizer(), GLPK.Optimizer)
set_optimizer_attribute(sp, SubproblemOptimizer(), GLPK.Optimizer)
# Optimize (vertical structure)
optimize!(sp)
# Check termination status and query optimal value
@show termination_status(sp);
@show objective_value(sp);
