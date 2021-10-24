# Load SPjl framework
using StochasticPrograms
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
