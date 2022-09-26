# The following code is lazily loaded from Clustering.jl using LazyModules.jl
# Code adapted from @cormullion's ColorSchemeTools (https://github.com/JuliaGraphics/ColorSchemeTools.jl)

# The following type definition is taken from from Clustering.jl for the kwarg `init`:
const ClusteringInitType = Union{
    Symbol,Clustering.SeedingAlgorithm,AbstractVector{<:Integer}
}

const KMEANS_DEFAULT_COLORSPACE = RGB{Float32}

"""
    KMeansQuantization([T=RGB,] ncolors)

Quantize colors by applying the K-means method, where `ncolors` corresponds to
the amount of clusters and output colors.

The colorspace `T` in which K-means are computed defaults to `RGB`.

## Optional arguments
The following keyword arguments from Clustering.jl can be specified:
- `init`: specifies how cluster seeds are initialized
- `maxiter`: maximum number of iterations
- `tol`:  minimal allowed change of the objective during convergence.
    The algorithm is considered to be converged when the change of objective value between
    consecutive iterations drops below `tol`.

The default values are carried over from are imported from Clustering.jl.
For more details, refer to the [documentation](https://juliastats.org/Clustering.jl/stable/)
of Clustering.jl.
"""
struct KMeansQuantization{T<:Colorant,I<:ClusteringInitType,R<:AbstractRNG} <:
       AbstractColorQuantizer
    ncolors::Int
    maxiter::Int
    tol::Float64
    init::I
    rng::R

    function KMeansQuantization(
        T::Type{<:Colorant},
        ncolors::Integer;
        init=Clustering._kmeans_default_init,
        maxiter=Clustering._kmeans_default_maxiter,
        tol=Clustering._kmeans_default_tol,
        rng=GLOBAL_RNG,
    )
        ncolors ≥ 2 ||
            throw(ArgumentError("K-means clustering requires ncolors ≥ 2, got $(ncolors)."))
        return new{T,typeof(init),typeof(rng)}(ncolors, maxiter, tol, init, rng)
    end
end
function KMeansQuantization(ncolors::Integer; kwargs...)
    return KMeansQuantization(KMEANS_DEFAULT_COLORSPACE, ncolors; kwargs...)
end

function (alg::KMeansQuantization{T})(cs::AbstractArray{<:Colorant}) where {T}
    # Clustering on the downsampled image already generates good enough colormap estimation.
    # This significantly reduces the algorithmic complexity.
    cs = _restrict_to(cs, alg.ncolors * 100)
    return _kmeans(alg, convert.(T, cs))
end

function _kmeans(alg::KMeansQuantization, cs::AbstractArray{<:Colorant{T,N}}) where {T,N}
    data = reshape(channelview(cs), N, :)
    R = Clustering.kmeans(
        data, alg.ncolors; maxiter=alg.maxiter, tol=alg.tol, init=alg.init, rng=alg.rng
    )
    return colorview(eltype(cs), R.centers)
end
