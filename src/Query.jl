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

"""
    Query(dataset::Dataset, args...)

Build a `Query` for the given `Dataset` and combination
of `Filters` and `Attributes`. An `Interval` from `GenomicFeatures` can also
be provided to filter by genomic position.

A `Query` build the request in `XML` format but does not execute it. To do so you can
call `BioMart.execute` or directly call the `Query` object.

To build and execute a `Query` at once use `BioMart.query`.

Example:

    q = BioMart.Query(
        BioMart.Dataset("maj_gene_ensembl"),
        Interval("1", 1, 200000),
        BioMart.Attribute("external_gene_name"),
        BioMart.Attributes("ensembl_gene_id", "ensembl_transcript_id", "strand"),
        BioMart.Filter(strand = "1")
    )
    q() #BioMart.execute(q)
"""
function Query(dataset::Dataset, args...)
    q = Query(dataset)
    for el in args
        push!(q, el)
    end
    q
end

Base.show(io::IO, q::Query) = show(q.xdoc)

"""
    execute(q::Query) 

Exectute a `Query` and returns a `DataFrame` with the results.
"""
function execute(q::Query) 
    query = HTTP.URIs.escapeuri(string(q.xdoc))
    r = HTTP.get(string(BIOMART_URL, "?query=", query))
    CSV.read(r.body, DataFrame; delim = '\t')
end

(q::Query)() = execute(q)

"""
    query(args...)

Build a `Query` using `args`, exectute it immediately and returns the results.

"""
query(args...) = Query(args...)()