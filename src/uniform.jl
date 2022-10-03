"""
    UniformQuantization(n::Int)

Quantize colors in RGB color space by dividing each dimension of the ``[0, 1]³``
RGB color cube into `n` equidistant steps for a total of `n³` cubes of equal size.
Each color in `cs` is then quantized to the center of the cube it is in.
Only unique colors are returned. The amount of output colors is therefore bounded by `n³`.
"""
struct UniformQuantization{N} <: AbstractColorQuantizer
    function UniformQuantization(n::Integer)
        return n < 1 ? throw(ArgumentError("n has to be ≥ 1, got $(n).")) : new{n}()
    end
end

@inline (alg::UniformQuantization)(cs::AbstractArray) = alg(convert.(RGB, cs))
@inline (alg::UniformQuantization)(cs::AbstractArray{<:RGB}) = unique(alg.(cs))

@inline (alg::UniformQuantization)(c::Colorant) = alg(convert(RGB, c))
@inline (alg::UniformQuantization)(c::RGB{T}) where {T} = mapc(alg, c)

@inline (alg::UniformQuantization)(x::Real) = _uq_round(alg, x)
@inline (alg::UniformQuantization)(x::FixedPoint) = _uq_lookup(alg, x)

# For general real numbers, use round
@inline @generated function _uq_round(::UniformQuantization{N}, x::T) where {N,T<:Real}
    return quote
        x < $(T(1 / N)) && return $(T(1 / (2 * N)))
        x ≥ $(T((N - 1) / N)) && return $(T((2 * N - 1) / (2 * N)))
        return (round(x * $N - $(T(0.5))) + $(T(0.5))) / $N
    end
end

# For fixed-point numbers, use the internal integer to index onto a lookup table
@inline function _uq_lookup(alg::UniformQuantization{N}, x::T) where {N,T<:FixedPoint}
    @inbounds _uq_lookup_table(alg, T)[x.i + 1]
end

# the lookup table is generated at compile time
@generated function _uq_lookup_table(
    ::UniformQuantization{N}, ::Type{T}
) where {N,T<:FixedPoint}
    RT = rawtype(T)
    tmax = typemax(RT)
    table = Vector{T}(undef, tmax + 1)
    for raw_x in zero(RT):tmax
        x = reinterpret(T, raw_x)
        table[raw_x + 1] = _uq_round(UniformQuantization(N), x)
    end
    return table
end
