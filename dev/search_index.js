var documenterSearchIndex = {"docs":
[{"location":"api/#API-Reference","page":"API Reference","title":"API Reference","text":"","category":"section"},{"location":"api/#Basics","page":"API Reference","title":"Basics","text":"","category":"section"},{"location":"api/","page":"API Reference","title":"API Reference","text":"All methods in ColorQuantization.jl work by calling quantize on an input and a quantizer:","category":"page"},{"location":"api/","page":"API Reference","title":"API Reference","text":"quantize","category":"page"},{"location":"api/#ColorQuantization.quantize","page":"API Reference","title":"ColorQuantization.quantize","text":"quantize([T,] im, alg)\n\nApply color quantization algorithm alg to an iterable collection of Colorants im, e.g. an image or any AbstractArray. The return type T can be specified and defaults to the element type of cs.\n\n\n\n\n\n","category":"function"},{"location":"api/#methods_api","page":"API Reference","title":"Quantization methods","text":"","category":"section"},{"location":"api/","page":"API Reference","title":"API Reference","text":"UniformQuantization\nKMeansQuantization","category":"page"},{"location":"api/#ColorQuantization.UniformQuantization","page":"API Reference","title":"ColorQuantization.UniformQuantization","text":"UniformQuantization(n::Int)\n\nQuantize colors in RGB color space by dividing each dimension of the 0 1³ RGB color cube into n equidistant steps for a total of n³ cubes of equal size. Each color in cs is then quantized to the center of the cube it is in. Only unique colors are returned. The amount of output colors is therefore bounded by n³.\n\n\n\n\n\n","category":"type"},{"location":"api/#ColorQuantization.KMeansQuantization","page":"API Reference","title":"ColorQuantization.KMeansQuantization","text":"KMeansQuantization([T=RGB,] ncolors)\n\nQuantize colors by applying the K-means method, where ncolors corresponds to the amount of clusters and output colors.\n\nThe colorspace T in which K-means are computed defaults to RGB.\n\nOptional arguments\n\nThe following keyword arguments from Clustering.jl can be specified:\n\ninit: specifies how cluster seeds are initialized\nmaxiter: maximum number of iterations\ntol:  minimal allowed change of the objective during convergence.   The algorithm is considered to be converged when the change of objective value between   consecutive iterations drops below tol.\n\nThe default values are carried over from are imported from Clustering.jl. For more details, refer to the documentation of Clustering.jl.\n\n\n\n\n\n","category":"type"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"EditURL = \"https://github.com/JuliaImages/ColorQuantization.jl/blob/main/docs/src/literate/getting_started.jl\"","category":"page"},{"location":"generated/getting_started/#Getting-started","page":"Getting started","title":"Getting started","text":"","category":"section"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"ColorQuantization.jl can be applied to any iterable collection of Colorants img, e.g. an image or any AbstractArray. We demonstrate ColorQuantization.jl on the peppers test image:","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"using ColorQuantization\nusing ColorTypes\nusing TestImages\n\nimg = testimage(\"peppers\")","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"To extract a color palette from an image, call quantize with a quantization method of your choice.","category":"page"},{"location":"generated/getting_started/#Clustering","page":"Getting started","title":"Clustering","text":"","category":"section"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"Clustering methods such as KMeansQuantization are convenient since they allow us to specify the exact number of output colors:","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"quantize(img, KMeansQuantization(16))","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"quantize(img, KMeansQuantization(64))","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"quantize(img, KMeansQuantization(256))","category":"page"},{"location":"generated/getting_started/#Uniform-quantization","page":"Getting started","title":"Uniform quantization","text":"","category":"section"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"If perfomance is crucial, UniformQuantization can be used to quantize colors to the closest points on a equidistant 3D grid.","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"note: Note\nIn constrast to clustering, here the argument to UniformQuantization specifies the number of subdivisions of the 0 1³ RGB color cube. The amount of output colors is therefore bounded by n³.","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"quantize(img, UniformQuantization(4))","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"quantize(img, UniformQuantization(6))","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"quantize(img, UniformQuantization(8))","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"Using UniformQuantization, every single pixel in the input image is rounded and appears in the generated color palette, which explains the blues and purples from the shadows of the peppers.","category":"page"},{"location":"generated/getting_started/#Output-color-type","page":"Getting started","title":"Output color type","text":"","category":"section"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"It is also possible to specify the output color type:","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"colors = quantize(HSV, img, UniformQuantization(4))","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"typeof(colors)","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"","category":"page"},{"location":"generated/getting_started/","page":"Getting started","title":"Getting started","text":"This page was generated using Literate.jl.","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = ColorQuantization","category":"page"},{"location":"#ColorQuantization","page":"Home","title":"ColorQuantization","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for ColorQuantization.jl, a Julia package to generate color palettes from images.","category":"page"},{"location":"","page":"Home","title":"Home","text":"note: Note\nThis package is part of a wider Julia-based image processing ecosystem. If you are starting out, then you may benefit from reading about some fundamental conventions that the ecosystem utilizes that are markedly different from how images are typically represented in OpenCV, MATLAB, ImageJ or Python.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"To install this package and its dependencies, open the Julia REPL and run ","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> ]add ColorQuantization","category":"page"},{"location":"#Manual","page":"Home","title":"Manual","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Pages = [\n    \"generated/getting_started.md\",\n]\nDepth = 2","category":"page"},{"location":"#API-reference","page":"Home","title":"API reference","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"api.md\",]\nDepth = 2","category":"page"}]
}
