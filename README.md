# ColorQuantization

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliaimages.github.io/ColorQuantization.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliaimages.github.io/ColorQuantization.jl/dev/)
[![Build Status](https://github.com/JuliaImages/ColorQuantization.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaImages/ColorQuantization.jl/actions/workflows/CI.yml?query=branch%3Amain)
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

[docs-methods]: https://juliaimages.org/ColorQuantization.jl/dev/api/#methods_api
