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

const UQ_FLOATTYPE = Float32
const UQ_COLORTYPE = RGB{UQ_FLOATTYPE}
const UQ_HALF = UQ_FLOATTYPE(0.5)

(alg::UniformQuantization)(cs) = alg(convert.(UQ_COLORTYPE, cs))
function (alg::UniformQuantization)(cs::AbstractArray{UQ_COLORTYPE})
    n = UQ_FLOATTYPE(alg.n)
    return unique(map(c -> _uniform_quantization(c, n), cs))
end

function _uniform_quantization(c::UQ_COLORTYPE, n::UQ_FLOATTYPE)
    return mapc(x -> _uniform_quantization(x, n), c)
end
function _uniform_quantization(x::UQ_FLOATTYPE, n::UQ_FLOATTYPE)
    x ≤ 0 && return 1 / (2 * n)
    x ≥ 1 && return (2 * n - 1) / (2 * n)
    return (round(x * n - UQ_HALF) + UQ_HALF) / n
end
