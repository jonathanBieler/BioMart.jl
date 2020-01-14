struct Filter
    name::String
    value::String
end

Filter(name::Symbol, value::String) = Filter(string(name), value)

function Filter(;args...) 
    @assert length(args) == 1
    pair = first(args)
    Filter(pair.first, pair.second)
end

function Base.push!(query::Query, f::Filter) 
    xf = new_child(query.dataset, "Filter")
    set_attributes(xf, name = f.name, value = f.value)
end


struct Filters
    filters::Vector{Filter}
end

function Filters(;args...) 
    Filters([Filter(pair.first, pair.second) for pair in args])
end

Base.push!(query::Query, f::Filters) = push!.(Ref(query), f.filters)

