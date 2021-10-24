@stochastic_model farmer begin
    @stage 1 begin
        @parameters begin
            Crops = [:wheat, :corn, :beets]
            Cost = Dict(:wheat=>150, :corn=>230, :beets=>260)
            Budget = 500
        end
        @decision(farmer, x[c in Crops] >= 0)
        @objective(farmer, Min, sum(Cost[c]*x[c] for c in Crops))
        @constraint(farmer, sum(x[c] for c in Crops) <= Budget)
    end
    @stage 2 begin
        @parameters begin
            Crops = [:wheat, :corn, :beets]
            Required = Dict(:wheat=>200, :corn=>240, :beets=>0)
            PurchasePrice = Dict(:wheat=>238, :corn=>210)
            SellPrice = Dict(:wheat=>170, :corn=>150, :beets=>36, :extra_beets=>10)
        end
        @uncertain ξ[c in Crops]
        @recourse(farmer, y[p in setdiff(Crops, [:beets])] >= 0)
        @recourse(farmer, w[s in Crops ∪ [:extra_beets]] >= 0)
        @objective(farmer, Min, sum(PurchasePrice[p] * y[p] for p in setdiff(Crops, [:beets]))
                   - sum(SellPrice[s] * w[s] for s in Crops ∪ [:extra_beets]))
        @constraint(farmer, minimum_requirement[p in setdiff(Crops, [:beets])],
            ξ[p] * x[p] + y[p] - w[p] >= Required[p])
        @constraint(farmer, minimum_requirement_beets,
            ξ[:beets] * x[:beets] - w[:beets] - w[:extra_beets] >= Required[:beets])
        @constraint(farmer, beets_quota, w[:beets] <= 6000)
    end
end
