using ColorQuantization
using Documenter

DocMeta.setdocmeta!(ColorQuantization, :DocTestSetup, :(using ColorQuantization); recursive=true)

makedocs(;
    modules=[ColorQuantization],
    authors="Adrian Hill <adrian.hill@mailbox.org>",
    repo="https://github.com/adrhill/ColorQuantization.jl/blob/{commit}{path}#{line}",
    sitename="ColorQuantization.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://adrhill.github.io/ColorQuantization.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/adrhill/ColorQuantization.jl",
    devbranch="main",
)
