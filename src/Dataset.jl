struct Dataset
    dataset::String
    description::String
    version::String
end

Dataset(dataset::String) = Dataset(dataset,"","")

@memoize function datasets(database::String)

    url = string(BioMart.BIOMART_URL, "?type=datasets&requestid=biomaRt&mart=$(database)")
    r = HTTP.get(url, cookies=true)
    
    out = Dataset[]

    for line in split(String(r.body), '\n')
        els = split(line, '\t')
        length(els) < 5 && continue

        push!(out, Dataset(
            els[2], els[3], els[5]
        ))
    end
    out
end

"""
    BioMart.datasets(database::Database)
    BioMart.datasets(database::String)

List the datasets available for a given database.

Examples : 

    BioMart.datasets("ENSEMBL_MART_ENSEMBL")
    
    dbs = BioMart.databases()
    BioMart.datasets(dbs[1])

""" 
datasets(database::Database) = datasets(database.name)

"""
    BioMart.list_attributes(dataset::Dataset)
    BioMart.list_attributes(dataset::String)

List the attributes available for a given dataset.

Examples : 

    BioMart.list_attributes("hsapiens_gene_ensembl")
""" 
@memoize function list_attributes(dataset::String)

    url = string(BioMart.BIOMART_URL, "?type=configuration&dataset=$(dataset)")
    r = HTTP.get(url, cookies=true)
    data = String(r.body)

    xdoc = parse_string(data)
    xroot = root(xdoc)

    out = collect_elems(xroot)
    DataFrame(out)
end

list_attributes(dataset::Dataset) = list_attributes(dataset.dataset)

"""go recursively over the XML and collect `AttributeDescription`s"""
function collect_elems(node, out) 

    if name(node) == "AttributeDescription"
        el = XMLElement(node)
        push!(out, (
                internalName = attribute(el, "internalName"),
                displayName  = attribute(el, "displayName"),
            )
        )
    else
        for c in child_nodes(node)
            collect_elems(c, out)
        end
    end
    out
end 
collect_elems(node) = collect_elems(node, [])