using ColorQuantization
using Test
using TestImages, ReferenceTests
using Colors
using Random, StableRNGs

rng = StableRNG(123)
Random.seed!(rng, 34568)

img = testimage("peppers")

algs_deterministic = Dict(
    "UniformQuantization4" => UniformQuantization(4),
    "KMeansQuantization8" => KMeansQuantization(8; rng=rng),
)

@testset "ColorQuantization.jl" begin
    # Reference tests on deterministic methods
    @testset "Reference tests" begin
        for (name, alg) in algs_deterministic
            @testset "$name" begin
                cs = quantize(img, alg)
                @test eltype(cs) == eltype(img)
                @test_reference "references/$(name).txt" cs

                cs = quantize(HSV{Float16}, img, alg)
                @test eltype(cs) == HSV{Float16}
                @test_reference "references/$(name)_HSV.txt" cs
            end
        end
    end

    @testset "Error messages" begin
        @test_throws ArgumentError UniformQuantization(0)
        @test_throws ArgumentError KMeansQuantization(0)
    end
end
