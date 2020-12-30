struct SSNData
    budget::Float64
    capacity::Vector{Float64}
    links::Int
    nodes::Int
    routes::Int
    routes_in::Vector{Vector{Int}}
    incidence::Matrix{Float64}

    function SSNData()
        budget = 1008.
        capacity = readdlm("ssn/capacity.csv", ',')[:]
        links = 89
        nodes = 86
        routes = 620
        routes_in = read_routes("ssn/routes_in.csv")
        incidence = readdlm("ssn/incidence.csv", ',')

        return new(budget, capacity, links, nodes, routes, routes_in, incidence)
    end
end

function read_routes(filename)
    f = open(filename)
    routes_in = Vector{Vector{Int}}(undef,86)
    for (i,line) in enumerate(readlines(filename))
        routes_in[i] = parse.(Int, split(line, ','))
    end
    close(f)
    return routes_in
end

function read_demands(filename)
    f = open(filename)
    demand_distributions = Vector{DiscreteNonParametric}(undef,86)
    lines = readlines(filename)
    for i = 1:86
        vals = parse.(Float64, split(lines[2*(i-1)+1], ','))
        probs = parse.(Float64, split(lines[2*(i-1)+2], ','))
        demand_distributions[i] = DiscreteNonParametric(vals, probs)
    end
    close(f)
    return demand_distributions
end

@sampler SSNSampler = begin
    demand_distributions::Vector{DiscreteNonParametric}

    SSNSampler() = new(read_demands("ssn/demand_distributions.csv"))

    @sample Scenario begin
        return Scenario([rand(d) for d in sampler.demand_distributions])
    end
end

function ssn_model(data::SSNData)
    return @stochastic_model begin
        @stage 1 begin
            @parameters begin
                links = collect(1:data.links)
                budget = data.budget
            end
            @decision(model, x[j = links] >= 0)
            @constraint(model, sum(x[j] for j in links) <= budget)
        end
        @stage 2 begin
            @parameters begin
                capacity = data.capacity
                links = collect(1:data.links)
                nodes = collect(1:data.nodes)
                routes = collect(1:data.routes)
                routes_in = data.routes_in
                incidence = data.incidence
            end
            @uncertain ω[i = nodes]
            @variable(model, f[r = routes] >= 0)
            @variable(model, s[i = nodes] >= 0)
            @objective(model, Min, sum(s[i] for i in nodes))
            @constraint(model, capacity[j = links],
                sum(sum(incidence[j,r]*f[r] for r in routes_in[i]) for i in nodes) <= x[j] + capacity[j])
            @constraint(model, unserved[i = nodes],
                sum(f[r] for r in routes_in[i]) + s[i] == ω[i])
        end
    end
end

const ssn_data = SSNData()
const ssn = ssn_model(ssn_data)
const ssn_sampler = SSNSampler()
