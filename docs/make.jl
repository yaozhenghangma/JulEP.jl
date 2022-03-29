using MatterEnv
using Documenter

DocMeta.setdocmeta!(MatterEnv, :DocTestSetup, :(using MatterEnv); recursive=true)

makedocs(;
    modules=[MatterEnv],
    authors="Yaozhenghang Ma <yaozhenghang.ma@gmail.com> and contributors",
    repo="https://github.com/YaozhenghangMa/MatterEnv.jl/blob/{commit}{path}#{line}",
    sitename="MatterEnv.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://YaozhenghangMa.github.io/MatterEnv.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/YaozhenghangMa/MatterEnv.jl",
)
