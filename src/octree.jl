
struct OctreeQuantization <: AbstractColorQuantizer
    numcolors::Int
    function OctreeQuantization(
        colorspace::Type{<:Colorant},
        numcolors::Int = 256;
        kwargs...,
    )
        colorspace == RGB{N0f8} || error("Octree Algorithm only supports RGB colorspace")
        return new(numcolors)
    end
end

const OCTREE_DEFAULT_COLORSPACE = RGB{N0f8}
# Color to RGB
# constructor for struct
function OctreeQuantization(numcolors::Int = 256; kwargs...)
    return OctreeQuantization(OCTREE_DEFAULT_COLORSPACE, numcolors; kwargs...)
end

function (alg::OctreeQuantization)(img::AbstractArray)
    return octreequantisation!(img; numcolors = alg.numcolors)
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
    root = Cell(
        SVector(0.0, 0.0, 0.0),
        SVector(1.0, 1.0, 1.0),
        ["root", 0, [], RGB{N0f8}.(0.0, 0.0, 0.0), 0],
    )
    cases = map(
        p -> [bitstring(UInt8(p))[6:end], 0, Vector{Int}([]), RGB{N0f8}.(0.0, 0.0, 0.0), 1],
        1:8,
    )
    split!(root, cases)
    inds = collect(1:length(img))

    function putin(root, in)
        r, g, b = map(p -> bitstring(UInt8(p * 255)), channelview([img[in]]))
        rgb = r[1] * g[1] * b[1]
        # finding the entry to the tree
        ind = 0
        for i = 1:8
            if (root.children[i].data[1] == rgb)
                root.children[i].data[2] += 1
                ind = i
                break
            end
        end
        curr = root.children[ind]

        for i = 2:8
            cases = map(
                p -> [
                    bitstring(UInt8(p))[6:end],
                    0,
                    Vector{Int}([]),
                    RGB{N0f8}.(0.0, 0.0, 0.0),
                    i,
                ],
                1:8,
            )
            rgb = r[i] * g[i] * b[i]
            if (isleaf(curr) == true && i <= 8)
                split!(curr, cases)
            end
            if (i == 8)
                for j = 1:8
                    if (curr.children[j].data[1] == rgb)
                        curr = curr.children[j]
                        curr.data[2] += 1
                        push!(curr.data[3], in)
                        curr.data[4] = img[in]
                        return
                    end
                end
            end

            # handle 1:7 cases for rgb to handle first seven bits
            for j = 1:8
                if (curr.children[j].data[1] == rgb)
                    curr.children[j].data[2] += 1
                    curr = curr.children[j]
                    break
                end
            end
        end
    end

    # build the tree
    for i in inds
        root.data[2] += 1
        putin(root, i)
    end

    # step 2: reducing tree to a certain number of colors
    # there is scope for improvements in allleaves as it's found again n again
    leafs = [p for p in allleaves(root)]
    filter!(p -> !iszero(p.data[2]), leafs)
    tobe_reduced = leafs[1]

    while (length(leafs) > numcolors)
        parents = unique([parent(p) for p in leafs])
        parents = sort(parents; by = c -> c.data[2])
        tobe_reduced = parents[1]
        # @show tobe_reduced.data

        for i = 1:8
            append!(tobe_reduced.data[3], tobe_reduced.children[i].data[3])
            tobe_reduced.data[4] +=
                tobe_reduced.children[i].data[4] * tobe_reduced.children[i].data[2]
        end
        tobe_reduced.data[4] /= tobe_reduced.data[2]
        tobe_reduced.children = nothing

        # we don't want to do this again n again
        leafs = [p for p in allleaves(root)]
        filter!(p -> !iszero(p.data[2]), leafs)
    end

    # step 3: palette formation  and quantisation now
    da = [p.data for p in leafs]
    for i in da
        for j in i[3]
            img[j] = i[4]
        end
    end

    colors = [p[4] for p in da]
    return colors
end

function octreequantisation(img; kwargs...)
    img_copy = deepcopy(img)
    palette = octreequantisation!(img_copy; kwargs...)
    return img_copy, palette
end

