using ColorQuantization
using ColorTypes
using TestImages

img = testimage("peppers")

quantize(img, KMeansQuantization(16))

quantize(img, KMeansQuantization(64))

quantize(img, KMeansQuantization(256))

quantize(img, UniformQuantization(4))

quantize(img, UniformQuantization(6))

quantize(img, UniformQuantization(8))

colors = quantize(HSV, img, UniformQuantization(4))

typeof(colors)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
