struct Dataset
    dataset::String
    description::String
    version::String
end

Dataset(dataset::String) = Dataset(dataset,"","")

@memoize function datasets(database::String)

    url = string(BioMart.BIOMART_URL, "?type=datasets&requestid=biomaRt&mart=$(database)")
    r = HTTP.get(url)
    
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