using ColorQuantization
using Documenter
using Literate

LITERATE_DIR = joinpath(@__DIR__, "src/literate")
OUT_DIR = joinpath(@__DIR__, "src/generated")

# Use Literate.jl to generate docs and notebooks of examples
for file in readdir(LITERATE_DIR)
    path = joinpath(LITERATE_DIR, file)

    Literate.markdown(path, OUT_DIR; documenter=true) # markdown for Documenter.jl
    Literate.notebook(path, OUT_DIR) # .ipynb notebook
    Literate.script(path, OUT_DIR) # .jl script
end

DocMeta.setdocmeta!(
    ColorQuantization, :DocTestSetup, :(using ColorQuantization); recursive=true
)

makedocs(;
    modules=[ColorQuantization],
    authors="Adrian Hill <adrian.hill@mailbox.org>",
    repo="https://github.com/JuliaImages/ColorQuantization.jl/blob/{commit}{path}#{line}",
    sitename="ColorQuantization.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://juliaimages.github.io/ColorQuantization.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Getting started" => "generated/getting_started.md",
        "API Reference" => "api.md",
    ],
)

deploydocs(; repo="github.com/JuliaImages/ColorQuantization.jl", devbranch="main")
