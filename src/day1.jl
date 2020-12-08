function readnums(filename)
    v = readlines(filename)
    sort(map(e -> parse(Int, e), v))
end

function search_pair(c)
    req_ranges = map(e -> searchsorted(c, 2020-e), c)
    r = findfirst(r -> length(r) == 1, req_ranges)
    c[r], 2020-c[r]
end

function takewhile(f::Function, ls)
    idx = findfirst(e -> !f(e), ls)
    if idx === nothing
        return ls
    else
        return ls[range(1, stop=idx-1)]
    end
end

function search_triple(c)
    pairs = map(c) do e
        xs = takewhile(x -> (x <=e) && (e + x < 2020), c)
        map(x -> (e, x), xs)
    end
    pairs = reduce((a1, a2) -> cat(a1, a2, dims=1), pairs)

    pair_idx = findfirst(pairs) do (a1, a2)
        # findfirst(a3 -> 2020 == (a1+a2+a3), c) !== nothing
        # c is sorted, I can use binary search. O(n^2log(n)) rather that O(n^3)
        a3_idx = searchsortedfirst(c, 2020-(a1+a2))
        2020 == a1 + a2 + c[a3_idx]
    end
    n1, n2 = pairs[pair_idx]
    *(n1, n2, (2020-(n1+n2)))
end
    
 
