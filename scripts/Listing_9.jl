farmer_model = @stochastic_model begin
    @stage 1 begin
        @parameters begin
            Crops = [:wheat, :corn, :beets]
            Cost = Dict(:wheat => 150, :corn => 230, :beets => 260)
            Budget = 500
        end
        @decision(model, x[c in Crops] >= 0) # allocated land for each crop
        @objective(model, Min, sum(Cost[c]*x[c] for c in Crops))
        @constraint(model, sum(x[c] for c in Crops) <= Budget)
    end
    @stage 2 begin
        @parameters begin
            Crops = [:wheat, :corn, :beets]
            Required = Dict(:wheat => 200, :corn => 240, :beets => 0)
            PurchasePrice = Dict(:wheat=>238, :corn=>210)
            SellPrice = Dict(:wheat => 170, :corn => 150, :beets => 36, :extra_beets => 10)
        end
        @uncertain ξ[c in Crops]
        @variable(model, y[p in setdiff(Crops, [:beets])] >= 0)
        @variable(model, w[s in Crops ∪ [:extra_beets]] >= 0)
        @objective(model, Min, sum(PurchasePrice[p] * y[p] for p in setdiff(Crops, [:beets]))
                             - sum(SellPrice[s] * w[s] for s in Crops ∪ [:extra_beets]))
        @constraint(model, minimum_requirement[p in setdiff(Crops, [:beets])],
            ξ[p] * x[p] + y[p] - w[p] >= Required[p])
        @constraint(model, minimum_requirement_beets,
            ξ[:beets] * x[:beets] - w[:beets] - w[:extra_beets] >= Required[:beets])
        @constraint(model, beets_quota, w[:beets] <= 6000)
    end
end
