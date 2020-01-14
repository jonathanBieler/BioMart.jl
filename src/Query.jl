struct Query
    xdoc::XMLDocument
    query::XMLElement
    dataset::XMLElement

end

function Query(dataset::String)

    # create an empty XML document
    xdoc = XMLDocument()

    # create & attach a root node
    query = create_root(xdoc, "Query")
    set_attribute(query, "virtualSchemaName", "default")
    set_attribute(query, "formatter", "TSV")
    set_attribute(query, "header", "1")
    set_attribute(query, "uniqueRows", "1")
    set_attribute(query, "count", "")
    set_attribute(query, "datasetConfigVersion", "0.6")

    # create the first child
    ds = new_child(query, "Dataset")
    set_attributes(ds, name = dataset, interface = "default")

    Query(xdoc, query, ds)
end

Query(dataset::Dataset) = Query(dataset.dataset)

function Query(dataset::Union{String,Dataset}, args...)
    q = Query(dataset)
    for el in args
        push!(q, el)
    end
    q
end

Base.show(io::IO, q::Query) = show(q.xdoc)

function execute(q::Query) 

    query = HTTP.URIs.escapeuri(string(q.xdoc))
    r = HTTP.get(string(BIOMART_URL, "?query=", query))
    CSV.read(r.body, delim = '\t')
end

(q::Query)() = execute(q)