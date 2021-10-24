@stochastic_model sp begin
    @stage 1 begin
        @decision(sp, x)
    end
    @stage 2 begin
        @parameters d
        @known(sp, x)
        @uncertain ξ
        @variable(sp, y <= d)
        @constraint(sp, x + y <= ξ)
    end
end
