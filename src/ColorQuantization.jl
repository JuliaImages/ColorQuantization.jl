module ColorQuantization

using Colors
using ImageBase: channelview, colorview, floattype, restrict
using Random: AbstractRNG, GLOBAL_RNG
using LazyModules: @lazy
#! format: off
@lazy import Clustering = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
#! format: on

abstract type AbstractColorQuantizer end

include("api.jl")
include("utils.jl")
include("uniform.jl")
include("clustering.jl") # lazily loaded

export AbstractColorQuantizer, quantize
export UniformQuantization, KMeansQuantization

end
