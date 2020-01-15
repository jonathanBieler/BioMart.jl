using Documenter
using BioMart

makedocs(
    sitename = "BioMart",
    format = Documenter.HTML(),
    modules = [BioMart]
)