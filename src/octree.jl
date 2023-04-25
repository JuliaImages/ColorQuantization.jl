
struct OctreeQuantization <: AbstractColorQuantizer
    numcolors::Int
    function OctreeQuantization(
        numcolors::Int=256;
        kwargs...
    )
        return new(numcolors)
    end
end

function (alg::OctreeQuantization)(img::AbstractArray)
    return octreequantisation!(img; numcolors=alg.numcolors)
end

function octreequantisation!(img; numcolors = 256, precheck::Bool = false)
    # ensure the img is in RGB colorspace
    if (eltype(img) != RGB{N0f8})
        error("Octree Algorithm requires img to be in RGB colorspace")
    end

    # checks if image has more colors than in numcolors
    if precheck == true
        unumcolors = length(unique(img))
        # @show unumcolors
        if unumcolors <= numcolors
            @debug "Image has $unumcolors unique colors"
            return unique(img)
        end
    end

    # step 1: creating the octree
    root = Cell(SVector(0.0, 0.0, 0.0), SVector(1.0, 1.0, 1.0), [0, [], RGB{N0f8}.(0.0, 0.0, 0.0), 0])
    cases = map(p -> [0, Vector{Int}([]), RGB{N0f8}.(0.0, 0.0, 0.0), 1], 1:8)
    split!(root, cases)
    inds = collect(1:length(img))

    function putin(c::Cell, i::Int, level::Int)
        if (level == 8)
            push!(c.data[2], i)
            c.data[3] = img[i]
            return
        else
            if (isleaf(c) == true && level <= 8)
                cadata = map(p -> [0, Vector{Int}([]), RGB{N0f8}.(0.0, 0.0, 0.0), level + 1], 1:8)
                split!(c, cadata)
            end
            r, g, b = map(p -> bitstring(UInt8(p * 255)), channelview([img[i]]))
            rgb = r[level] * g[level] * b[level]
            rgb = parse(Int, rgb, base=2) + 1
            c.children[rgb].data[1] += 1
            putin(c.children[rgb], i, level + 1)
        end
    end

    level = 1
    root.data[1] = length(inds)

    # build the tree
    for i in inds
        r, g, b = map(p -> bitstring(UInt8(p * 255)), channelview([img[i]]))
        rgb = r[level] * g[level] * b[level]
        rgb = parse(Int, rgb, base=2) + 1
        root.children[rgb].data[1] += 1
        putin(root.children[rgb], i, level)
    end

    # step 2: reducing tree to a certain number of colors
    # there is scope for improvements in allleaves as it's found again n again
    leafs = [p for p in allleaves(root)]
    filter!(p -> !iszero(p.data[1]), leafs)
    tobe_reduced = leafs[1]

    while (length(leafs) > numcolors)
        parents = unique([parent(p) for p in leafs])
        parents = sort(parents; by = c -> c.data[1])
        tobe_reduced = parents[1]

        for i = 1:8
            append!(tobe_reduced.data[2], tobe_reduced.children[i].data[2])
            tobe_reduced.data[3] +=
                tobe_reduced.children[i].data[3] * tobe_reduced.children[i].data[1]
        end

        tobe_reduced.data[3] /= tobe_reduced.data[1]
        filter!(!in(tobe_reduced.children),leafs)
        push!(leafs, tobe_reduced)
        tobe_reduced.children = nothing
    end

    # step 3: palette formation  and quantisation now
    da = [p.data for p in leafs]
    for i in da
        for j in i[2]
            img[j] = i[3]
        end
    end

    colors = [p[3] for p in da]
    return colors
end

function octreequantisation(img; kwargs...)
    img_copy = deepcopy(img)
    palette = octreequantisation!(img_copy; kwargs...)
    return img_copy, palette
end

