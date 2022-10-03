"""
    quantize([T,] cs, alg)

Apply color quantization algorithm `alg` to an iterable collection of Colorants,
e.g. an image or any `AbstractArray`.
The return type `T` can be specified and defaults to the element type of `cs`.
"""
function quantize(cs::AbstractArray{T}, alg::AbstractColorQuantizer) where {T<:Colorant}
    return quantize(T, cs, alg)
end

function quantize(
    ::Type{T}, cs::AbstractArray{<:Colorant}, alg::AbstractColorQuantizer
) where {T}
    return convert.(T, alg(cs)[:])
end
