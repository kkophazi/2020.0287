# Load SPjl framework
using StochasticPrograms
# Create simple stochastic model
simple_model = @stochastic_model begin
  @stage 1 begin
      @decision(model, x₁ >= 40)
      @decision(model, x₂ >= 20)
      @objective(model, Min, 100*x₁ + 150*x₂)
      @constraint(model, x₁+x₂ <= 120)
  end
  @stage 2 begin
      @uncertain q₁ q₂ d₁ d₂
      @variable(model, 0 <= y₁ <= d₁)
      @variable(model, 0 <= y₂ <= d₂)
      @objective(model, Max, q₁*y₁ + q₂*y₂)
      @constraint(model, 6*y₁ + 10*y₂ <= 60*x₁)
      @constraint(model, 8*y₁ + 5*y₂ <= 80*x₂)
  end
end
