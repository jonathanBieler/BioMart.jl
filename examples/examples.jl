using BioMart, GenomicFeatures

# affyids=c("202763_at","209310_s_at","207500_at")
# getBM(attributes=c('affy_hg_u133_plus_2', 'entrezgene_id'), 
#       filters = 'affy_hg_u133_plus_2', 
#       values = affyids, 
#       mart = ensembl)

affyids = ["202763_at", "209310_s_at", "207500_at"]
q = BioMart.Query(
    BioMart.Dataset("hsapiens_gene_ensembl"),
    BioMart.Attributes("affy_hg_u133_plus_2", "entrezgene_id"),
    BioMart.Filter(affy_hg_u133_plus_2 = affyids),
)
q()

# entrez=c("673","837")
# goids = getBM(attributes = c('entrezgene_id', 'go_id'), 
#     filters = 'entrezgene_id', 
#     values = entrez, 
#     mart = ensembl)

entrez = ["673", "837"]
q = BioMart.Query(
    BioMart.Dataset("hsapiens_gene_ensembl"),
    BioMart.Attributes("entrezgene_id", "go_id"),
    BioMart.Filter(entrezgene_id = entrez),
)
q()

# getBM(attributes = c('affy_hg_u133_plus_2','ensembl_gene_id'), 
#       filters = c('chromosome_name','start','end'),
#       values = list(16,1100000,1250000), 
#       mart = ensembl)

q = BioMart.Query(
    BioMart.Dataset("hsapiens_gene_ensembl"),
    Interval("16", 1100000, 1250000),
    BioMart.Attributes("affy_hg_u133_plus_2", "ensembl_gene_id"),
)
q()