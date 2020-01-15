"""
    struct Filter
        name::String
        value::String
    end

Specify a filter to be applied to the query.

Examples :

    BioMart.Filter(ensembl_gene_id = "ENSG00000146648")
    BioMart.Filter("ensembl_gene_id", "ENSG00000146648")
"""
struct Filter
    name::String
    value::String
end

Filter(name::Symbol, value) = Filter(string(name), value)
Filter(name::String, value::Int) = Filter(name, string(value))
Filter(name::String, values::Vector) =  Filter(name, join(values,','))

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
"""
    BioMart.Filters(;args...)

Specify a list of filters to be applied to the query. 

Example :

    BioMart.Filters(
        ensembl_gene_id = "ENSG00000146648", 
        chromosome_name = "7"
    )
"""
function Filters(;args...) 
    Filters([Filter(pair.first, pair.second) for pair in args])
end

Base.push!(query::Query, f::Filters)  = push!.(Ref(query), f.filters)

Base.push!(query::Query, i::Interval) = push!(query, convert(Filters, i))

Base.convert(::Type{Filters}, i::T)  where T <: Interval = Filters([
    Filter("start", i.first),
    Filter("end", i.last),
    Filter("chromosome_name", i.seqname),
])