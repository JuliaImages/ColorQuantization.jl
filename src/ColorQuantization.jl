module ColorQuantization

using Colors
using ImageBase: FixedPoint, floattype, FixedPointNumbers.rawtype, FixedPointNumbers.N0f8
using ImageBase: channelview, colorview, restrict
using Random: AbstractRNG, GLOBAL_RNG
using LazyModules: @lazy
using RegionTrees
using StaticArrays

#! format: off
@lazy import Clustering = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
#! format: on

abstract type AbstractColorQuantizer end

include("api.jl")
include("utils.jl")
include("uniform.jl")
include("clustering.jl") # lazily loaded
include("octree.jl")

export AbstractColorQuantizer, quantize
export UniformQuantization, KMeansQuantization, OctreeQuantization

end
