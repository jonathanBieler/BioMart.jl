# BioMart

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jonathanBieler.github.io/BioMart.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jonathanBieler.github.io/BioMart.jl/dev)

[![Build Status](https://github.com/jonathanBieler/BioMart.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/jonathanBieler/BioMart.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/jonathanBieler/BioMart.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/jonathanBieler/BioMart.jl)
[![Project Status: Inactive – The project has reached a stable, usable state but is no longer being actively developed; support/maintenance will be provided as time allows.](https://www.repostatus.org/badges/latest/inactive.svg)](https://www.repostatus.org/#inactive)

Make simple requests to Ensembl [BioMart](https://www.ensembl.org/info/data/biomart/index.html) database.

## Example

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
