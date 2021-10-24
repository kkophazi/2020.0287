# Instantiate with progressive-hedging optimizer
sp = instantiate(simple_model, [ξ₁, ξ₂],
                 optimizer = ProgressiveHedging.Optimizer)
# Print to compare structure of generated problem
print(sp)
using Ipopt
# Set Ipopt optimizer for soving emerging subproblems
set_optimizer_attribute(sp, SubProblemOptimizer(), Ipopt.Optimizer)
# Silence Ipopt
set_optimizer_attribute(sp, RawSubProblemOptimizerParameter("print_level"), 0)
# Optimize (horizontal structure)
optimize!(sp)
# Check termination status and query optimal value
@show termination_status(sp);
@show objective_value(sp);
