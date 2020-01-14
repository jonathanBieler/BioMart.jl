struct Dataset
    dataset::String
    description::String
    version::String
end

Dataset(dataset::String) = Dataset(dataset,"","")

function datasets(database::String)

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

datasets(database::Database) = datasets(database.name)