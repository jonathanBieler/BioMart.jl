struct Database
    display_name::String
    name::String
    database::String
    host::String
    path::String
    port::Int
end

function Database(el::XMLElement)
    Database(
        attribute(el, "displayName"),
        attribute(el, "name"),
        attribute(el, "database"),
        attribute(el, "host"),
        attribute(el, "path"),
        parse(Int, attribute(el, "port"))
    )
end

"""
    BioMart.databases()

List the available databases.
""" 
@memoize function databases()

    url = string(BIOMART_URL, "?type=registry&requestid=biomaRt")
    r = HTTP.get(url)
    if r.status != 200
        error("Failed to connect to $(url)")
        println(r)
    end

    xdoc = LightXML.parse_string(String(r.body))
    elems = root(xdoc)["MartURLLocation"]

    Database.(elems)
end

baremodule Databases
    const ENSEMBL_MART_ENSEMBL = "ensembl_mart_98"
    const ENSEMBL_MART_MOUSE = "mouse_mart_98"
    const ENSEMBL_MART_SEQUENCE = "sequence_mart_98"
    const ENSEMBL_MART_ONTOLOGY = "ontology_mart_98"
    const ENSEMBL_MART_GENOMIC = "genomic_features_mart_98"
    const ENSEMBL_MART_SNP = "snp_mart_98"
    const ENSEMBL_MART_FUNCGEN = "regulation_mart_98"
end
