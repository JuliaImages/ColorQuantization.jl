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

const UQ_COLORSPACE = RGB{Float32}

(alg::UniformQuantization)(cs) = alg(convert.(UQ_COLORSPACE, cs))
function (alg::UniformQuantization)(cs::AbstractArray{UQ_COLORSPACE})
    return unique(map(c -> _uniform_quantization(c, alg.n), cs))
end

function _uniform_quantization(c::UQ_COLORSPACE, n)
  return mapc(x -> round(x * n) / n , c)
end
