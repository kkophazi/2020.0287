using GLPK
# Set the optimizer to GLPK
set_optimizer(sp, GLPK.Optimizer)
# Optimize (deterministic structure)
optimize!(sp)
# Check termination status
@show termination_status(sp)
# Query optimal value
@show objective_value(sp)
# Calculate EVPI
@show EVPI(sp)
# Calculate VSS
@show VSS(simple_model)
