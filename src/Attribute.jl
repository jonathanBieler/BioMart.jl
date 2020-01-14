struct Attribute
    name::String
end

function Base.push!(query::Query, f::Attribute) 
    xa = new_child(query.dataset, "Attribute")
    set_attributes(xa, name = f.name)
end

struct Attributes
    attributes::Vector{Attribute}
end

function Attributes(args...) 
    Attributes([Attribute(arg) for arg in args])
end

Base.push!(query::Query, f::Attributes) = push!.(Ref(query), f.attributes)