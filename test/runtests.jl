using ColorQuantization
using Test, Aqua
using TestImages, ReferenceTests
using Random, StableRNGs
using Colors: RGB, HSV
using FixedPointNumbers: N0f8

# Run package tests
rng = StableRNG(123)
Random.seed!(rng, 34568)

img = testimage("peppers")
img_N0f8 = convert.(RGB{N0f8}, img)

algs_deterministic = Dict(
    "UniformQuantization4" => UniformQuantization(4),
    "KMeansQuantization8" => KMeansQuantization(8; rng=rng),
    "KMeansQuantization8_N0f8" => KMeansQuantization(RGB{N0f8}, 8; rng=rng),
)

@testset "ColorQuantization.jl" begin
    @testset "Aqua.jl quality assurance tests" begin
        Aqua.test_all(ColorQuantization; ambiguities=false)
        Aqua.test_ambiguities([ColorQuantization, Core])
    end
    # Reference tests on deterministic methods
    @testset "Reference tests" begin
        for (name, alg) in algs_deterministic
            @testset "$name" begin
                cs = @inferred quantize(img, alg)
                @test eltype(cs) == eltype(img)
                @test_reference "references/$(name).txt" cs

                cs = @inferred quantize(HSV{Float16}, img, alg)
                @test eltype(cs) == HSV{Float16}
                @test_reference "references/$(name)_HSV.txt" cs
            end
        end
    end
    @testset "UniformQuantization" begin
        c1 = RGB(0.0, 0.3, 1.0)
        c2 = RGB(0.49, 0.5, 0.51)
        c3 = RGB(0.11, 0.52, 0.73)
        cs = [c1, c2, c3]

        cs1 = @inferred quantize(cs, UniformQuantization(2))
        # Centers of cubes at: 0.25, 0.75
        # c1 and c2 get quantized to the same color
        @test length(cs1) == 2
        @test cs1[1] == RGB(0.25, 0.25, 0.75)
        @test cs1[2] == RGB(0.25, 0.75, 0.75)

        cs2 = @inferred quantize(cs, UniformQuantization(4))
        # Centers of cubes at: 0.125, 0.375, 0.625, 0.875

        # Remember that `round` defaults to `RoundNearest`,
        # which rounds to the nearest _even_ integer.
        # So here, `c2.g = 0.5` gets rounded up to 0.625 instead of down.
        @test cs2[1] == RGB(0.125, 0.375, 0.875)
        @test cs2[2] == RGB(0.375, 0.625, 0.625)
        @test cs2[3] == RGB(0.125, 0.625, 0.625)
    end
    @testset "Type stability" begin
        # @inferred UniformQuantization(4) # runtime inferrence due to {N} = 4
        @inferred KMeansQuantization(8)
    end
    @testset "Error messages" begin
        @test_throws ArgumentError UniformQuantization(0)
        @test_throws ArgumentError KMeansQuantization(0)
    end
end
