# Set optimizer to SAA
set_optimizer(simple_model, SAA.Optimizer)
# Emerging stochastic programming instances solved by GLPK
set_optimizer_attribute(simple_model, InstanceOptimizer(), GLPK.Optimizer)
# Set attributes that value solution speed over accuracy
set_optimizer_attribute(simple_model, NumEvalSamples(), 300)
# Set target relative tolerance of the resulting confidence interval
set_optimizer_attribute(simple_model, RelativeTolerance(), 5e-2)
# Approximate optimization using sample average approximation
optimize!(simple_model, SimpleSampler(μ, Σ))
# Check termination status
@show termination_status(simple_model);
# Query optimal value
@show objective_value(simple_model)
# Disable logging
set_optimizer_attribute(simple_model, MOI.Silent(), true)
# Calculate approximate EVPI
@show EVPI(simple_model, SimpleSampler(μ, Σ))
# Calculate approximate VSS
@show VSS(simple_model, SimpleSampler(μ, Σ))
