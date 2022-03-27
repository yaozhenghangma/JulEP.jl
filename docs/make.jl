using JulEP
using Documenter

DocMeta.setdocmeta!(JulEP, :DocTestSetup, :(using JulEP); recursive=true)

makedocs(;
    modules=[JulEP],
    authors="Yaozhenghang Ma <yaozhenghang.ma@gmail.com> and contributors",
    repo="https://github.com/YaozhenghangMa/JulEP.jl/blob/{commit}{path}#{line}",
    sitename="JulEP.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://YaozhenghangMa.github.io/JulEP.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/YaozhenghangMa/JulEP.jl",
)
