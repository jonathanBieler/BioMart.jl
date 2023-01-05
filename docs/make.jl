using Documenter
using BioMart

makedocs(;
    modules=[BioMart],
    authors="Jonathan Bieler <jonathan.bieler@alumni.epfl.ch> and contributors",
    repo="https://github.com/jonathanBieler/BioMart.jl/blob/{commit}{path}#{line}",
    sitename="BioMart.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jonathanBieler.github.io/BioMart.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jonathanBieler/BioMart.jl",
    devbranch="main",
)