"""
    struct Attribute
        name::String
    end

Specify an attribute to be returned by the query.

Example :

    BioMart.Attribute("external_gene_name")
"""
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

"""
    Attributes(args...) 

Specify a list of attributes to be returned by the query.

Example :

    BioMart.Attributes(
        "external_gene_name",
        "strand"
    )
"""
function Attributes(args...) 
    Attributes([Attribute(arg) for arg in args])
end

Base.push!(query::Query, f::Attributes) = push!.(Ref(query), f.attributes)