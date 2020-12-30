# Create two scenarios
ξ₁ = Scenario(q₁ = 24.0, q₂ = 28.0, d₁ = 500.0, d₂ = 100.0, probability = 0.4)
ξ₂ = Scenario(q₁ = 28.0, q₂ = 32.0, d₁ = 300.0, d₂ = 300.0, probability = 0.6)
# Instantiate without optimizer
sp = instantiate(simple_model, [ξ₁, ξ₂])
# Print to show structure of generated problem
print(sp)
