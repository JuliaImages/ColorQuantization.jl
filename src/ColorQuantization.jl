module ColorQuantization

using Colors
using ImageBase: FixedPoint, floattype, FixedPointNumbers.rawtype
using ImageBase: channelview, colorview, restrict
using Random: AbstractRNG, GLOBAL_RNG
using Clustering: kmeans, _kmeans_default_init, _kmeans_default_maxiter, _kmeans_default_tol

abstract type AbstractColorQuantizer end

include("api.jl")
include("utils.jl")
include("uniform.jl")
include("clustering.jl")

export AbstractColorQuantizer, quantize
export UniformQuantization, KMeansQuantization

end
