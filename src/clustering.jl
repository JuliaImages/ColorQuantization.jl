# The following code is lazily loaded from Clustering.jl using LazyModules.jl
# Code adapted from @cormullion's ColorSchemeTools (https://github.com/JuliaGraphics/ColorSchemeTools.jl)
"""
    KMeansQuantization(ncolors; [colorspace=RGB])

Quantize colors by applying the K-means method, where `ncolors` corresponds to
the amount of clusters and output colors.

The `colorspace` in which K-means are computed defaults to `RGB`.

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
Base.@kwdef struct KMeansQuantization{
    I<:Union{Symbol,Clustering.SeedingAlgorithm,AbstractVector{<:Integer}}
} <: AbstractColorQuantizer
    ncolors::Int
    colorspace::Type{<:Colorant} = RGB
    init::I = Clustering._kmeans_default_init
    maxiter::Int = Clustering._kmeans_default_maxiter
    tol::Float64 = Clustering._kmeans_default_tol
end
KMeansQuantization(ncolors; kwargs...) = KMeansQuantization(; ncolors=ncolors, kwargs...)

function (alg::KMeansQuantization)(cs::AbstractArray{<:Colorant{T,N}}) where {T,N}
    # Clustering on the downsampled image already generates good enough colormap estimation.
    # This significantly reduces the algorithmic complexity.
    cs = _restrict_to(cs, alg.ncolors * 100)

    # Cluster in the colorspace specified by alg
    cs = convert.(alg.colorspace, cs)
    return _kmeans(alg, cs)
end

function _kmeans(alg::KMeansQuantization, cs::AbstractArray{<:Colorant{T,N}}) where {T,N}
    data = reshape(channelview(cs), N, :)
    R = Clustering.kmeans(data, alg.ncolors; maxiter=alg.maxiter, tol=alg.tol)
    return colorview(eltype(cs), R.centers)
end
