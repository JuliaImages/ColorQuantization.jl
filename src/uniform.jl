"""
    UniformQuantization(n::Int)

Quantize colors in RGB color space by dividing each dimension of the ``[0, 1]³``
RGB color cube into `n` equidistant steps for a total of `n³` cubes of equal size.
Each color in `cs` is then quantized to the center of the cube it is in.
Only unique colors are returned. The amount of output colors is therefore bounded by `n³`.
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
    n = Float32(alg.n)
    return unique(map(c -> _uniform_quantization(c, n), cs))
end

function _uniform_quantization(c::UQ_COLORSPACE, n)
    return mapc(x -> _uniform_quantization(x, n), c)
end
function _uniform_quantization(x::Float32, n::Float32)
    x ≤ 0 && return 1 / (2 * n)
    x ≥ 1 && return (2 * n - 1) / (2 * n)
    return (round(x * n - 0.5f0) + 0.5f0) / n
end
