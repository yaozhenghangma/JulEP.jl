using MatterEnv
using Documenter

DocMeta.setdocmeta!(MatterEnv, :DocTestSetup, :(using MatterEnv); recursive=true)

makedocs(;
    modules=[MatterEnv],
    authors="Yaozhenghang Ma <yaozhenghang.ma@gmail.com> and contributors",
    repo="https://github.com/yaozhenghangma/MatterEnv.jl/blob/{commit}{path}#{line}",
    sitename="MatterEnv.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://yaozhenghangma.github.io/MatterEnv.jl",
        assets=String[],
        collapselevel = 1,
        sidebar_sitename = false,
    ),
    pages=[
        "Home" => "index.md",
        "API Reference" => [
            "reference/MatterBase.md",
            "reference/Toolkit.md",
            "reference/Visualization.md",
            "reference/VASP.md",
        ],
    ],
)

deploydocs(;
    repo="github.com/yaozhenghangma/MatterEnv.jl",
)
