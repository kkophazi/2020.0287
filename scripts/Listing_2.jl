@stochastic_model begin
    @stage 1 begin
        @decision(model, x)
    end
    @stage 2 begin
        @parameters d
        @known x
        @uncertain ξ
        @variable(model, y <= d)
        @constraint(model, x + y <= ξ)
    end
end
