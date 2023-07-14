# ColorQuantization.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliaimages.github.io/ColorQuantization.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliaimages.github.io/ColorQuantization.jl/dev/)
[![Build Status](https://github.com/JuliaImages/ColorQuantization.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaImages/ColorQuantization.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![Coverage](https://codecov.io/gh/JuliaImages/ColorQuantization.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaImages/ColorQuantization.jl)

A Julia package to generate color palettes from images.

## Installation 
To install this package and its dependencies, open the Julia REPL and run 
```julia-repl
julia> ]add ColorQuantization
```

## Examples
To extract a color palette from an image, call `quantize` with a [quantization method][docs-methods] of your choice.
```julia
using ColorQuantization
using TestImages

img = testimage("peppers")

quantize(img, KMeansQuantization(256))  # quantize to 256 colors
quantize(img, UniformQuantization(8))   # quantize to an 8x8x8 grid
```

The generated color schemes can be [viewed in the documentation][docs-getting-started].

## Related packages
[ColorSchemeTools.jl](https://github.com/JuliaGraphics/ColorSchemeTools.jl) provides `extract` to generate weighted colorschemes from images using K-means clustering.

[docs-getting-started]: https://juliaimages.org/ColorQuantization.jl/dev/generated/getting_started/
[docs-methods]: https://juliaimages.org/ColorQuantization.jl/dev/api/#methods_api
