# # Getting started
# ColorQuantization.jl can be applied to any iterable collection of Colorants `img`,
# e.g. an image or any `AbstractArray`.
# We will demonstrate ColorQuantization.jl on the common peppers test image:
using ColorQuantization
using ColorTypes
using TestImages

img = testimage("peppers")

# To extract a color palette from an image, we call [`quantize`](@ref)
# with a [Quantization method](@ref methods_api) of our choice.

# ## Clustering
# Clustering methods such as `KMeansQuantization` are convenient since they allow us
# to specify the exact number of output colors:
quantize(img, KMeansQuantization(16))

#
quantize(img, KMeansQuantization(64))

#
quantize(img, KMeansQuantization(256))

# ## Uniform quantization
# If perfomance is crucial, `UniformQuantization` can be used to quantize colors
# to the closest points on a equidistant 3D grid.
#
#md # !!! note
#md #     In constrast to clustering, here the argument `n` specifies
#md #     the number of subdivisions of the ``[0, 1]³`` RGB color cube.
#md #     The amount of output colors is therefore bounded by `n³`.
quantize(img, UniformQuantization(4))

#
quantize(img, UniformQuantization(6))

#
quantize(img, UniformQuantization(8))

# # Output color type
# When quantizing, it is also possible to specify the output color type
colors = quantize(HSV, img, UniformQuantization(4))

#
typeof(colors)
