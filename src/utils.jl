# Reduce the size of img until there are at most n elements left
function _restrict_to(img, n)
    length(img) <= n && return img
    out = restrict(img)
    while length(out) > n
        out = restrict(out)
    end
    return out
end
