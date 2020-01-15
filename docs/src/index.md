# BioMart.jl

Make simple requests to Ensembl [BioMart](https://www.ensembl.org/info/data/biomart/index.html) database.

## Usage

```julia
using BioMart
import BioMart: Dataset, Filters, Attributes

BioMart.query(
    Dataset("hsapiens_gene_ensembl"),
    Filters(
        ensembl_gene_id = "ENSG00000146648", 
        chromosome_name = "7"
    ),
    Attributes(
        "external_gene_name",
        "strand"
    ),
)

1×2 DataFrames.DataFrame
│ Row │ Gene name │ Strand │
│     │ String    │ Int64  │
├─────┼───────────┼────────┤
│ 1   │ EGFR      │ 1      │
```

## Index

```@index
Pages = ["index.md"]
```

## Types and methods

```@autodocs
Modules = [BioMart]
Private = true
Pages   = ["Query.jl", "Attribute.jl", "Filter.jl", "Database.jl", "Dataset.jl"]
```

## Internals

Currently only calls to `databases` and `datasets` are cached in memory using `Memoization.jl`
since memoization seems rather slow on queries.

