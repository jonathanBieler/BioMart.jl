using BioMart
using Test, LightXML, GenomicFeatures

@testset "Database & Dataset" begin

    xdoc = LightXML.parse_string("""<MartURLLocation database="ensembl_mart_98" default="1" 
    displayName="Ensembl Genes 98" host="www.ensembl.org" includeDatasets="" martUser="" name="ENSEMBL_MART_ENSEMBL" 
    path="/biomart/martservice" port="80" serverVirtualSchema="default" visible="1" />""")

    db = BioMart.Database(root(xdoc))

    @test db.name == "ENSEMBL_MART_ENSEMBL"

    dbs = BioMart.databases()

    datasets = BioMart.datasets(db)

    @test any(d.dataset == "loculatus_gene_ensembl" for d in datasets)

end

@testset "Low level API" begin
    
    q = BioMart.Query("hsapiens_gene_ensembl")
    f = BioMart.Filter("ensembl_gene_id", "ENSG00000146648")
    BioMart.push!(q,f)
    
    a = BioMart.Attribute("external_gene_name")
    BioMart.push!(q,a)

    d = BioMart.execute(q)
    @test d[1,1] == "EGFR"

end

@testset "Higher level API" begin
    
    q = BioMart.Query(
        BioMart.Dataset("hsapiens_gene_ensembl"),
        BioMart.Filter(ensembl_gene_id = "ENSG00000146648"),
        BioMart.Attribute("external_gene_name"),
    )
    d = BioMart.execute(q)
    @test d[1,1] == "EGFR"

    q = BioMart.Query(
        BioMart.Dataset("hsapiens_gene_ensembl"),
        BioMart.Filter(ensembl_gene_id = "ENSG00000146648"),
        BioMart.Attribute("external_gene_name"),
    )
    d = BioMart.execute(q)
    @test d[1,1] == "EGFR"

    q = BioMart.Query(
        BioMart.Dataset("hsapiens_gene_ensembl"),
        BioMart.Filters(
            ensembl_gene_id = "ENSG00000146648", 
            chromosome_name = "7"
        ),
        BioMart.Attributes(
            "external_gene_name",
            "strand"
        ),
    )
    d = q()
    @test d[1,1] == "EGFR"
    @test d.Strand[1] == 1

    # try another dataset
    d = BioMart.query(
        BioMart.Dataset("maj_gene_ensembl"),
        BioMart.Filter(chromosomal_region = "1:1:200000:1"),
        BioMart.Attribute("external_gene_name"),
        BioMart.Attribute("ensembl_gene_id"),
        BioMart.Attribute("ensembl_transcript_id"),
    )
    @test any(d[:,1] .== "Gm26206")

end


@testset "Intervals" begin
    
    q = BioMart.Query(
        BioMart.Dataset("maj_gene_ensembl"),
        Interval("1",1,200000),
        BioMart.Attribute("external_gene_name"),
        BioMart.Attribute("ensembl_gene_id"),
        BioMart.Attribute("ensembl_transcript_id"),
    )
    d = q()
    @test any(d[:,1] .== "Gm26206")

end

#url = string(BioMart.BIOMART_URL, "?type=datasets&requestid=biomaRt&mart=ENSEMBL_MART_ENSEMBL")
#url = string(BioMart.BIOMART_URL, "?type=registry&requestid=biomaRt")
