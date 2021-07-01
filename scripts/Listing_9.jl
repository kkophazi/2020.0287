using Distributions
# Define sampler object
@sampler SimpleSampler = begin
    N::MvNormal # Normal distribution

    SimpleSampler(μ, Σ) = new(MvNormal(μ, Σ))

    @sample Scenario begin
        # Sample from normal distribution
        x = rand(sampler.N)
        # Create scenario matching @uncertain annotation
        return @scenario q₁ = x[1] q₂ = x[2] d₁ = x[3] d₂ = x[4]
    end
end
# Create mean
μ = [24, 32, 400, 200]
# Create variance
Σ = [2 0.5 0 0
     0.5 1 0 0
     0 0 50 20
     0 0 20 30]
# Instantiate sampled stochastic program with 100 scenarios
sp = instantiate(simple_model, SimpleSampler(μ, Σ), 100)
