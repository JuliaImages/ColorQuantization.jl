"""
    UniformQuantization(n::Int)

Quantize colors in RGB color space by dividing each dimension of the ``[0, 1]³``
RGB color cube into `n` equidistant steps. This results in a grid with ``(n+1)³`` points.
Each color in `cs` is then quantized to the closest point on the grid. Only unique colors
are returned. The amount of output colors is therefore bounded by ``(n+1)³``.
"""
struct UniformQuantization <: AbstractColorQuantizer
    n::Int

    function UniformQuantization(n)
        return n < 1 ? throw(ArgumentError("n has to be ≥ 1, got $(n).")) : new(n)
    end
end

(alg::UniformQuantization)(cs::AbstractArray{<:Colorant}) = alg(convert.(RGB{Float32}, cs))
function (alg::UniformQuantization)(cs::AbstractArray{T}) where {T<:RGB{<:AbstractFloat}}
    return colorview(T, unique(round.(channelview(cs[:]) * alg.n); dims=2) / alg.n)
end
