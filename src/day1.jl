function readnums(filename)
    v = readlines(filename)
    sort(map(e -> parse(Int, e), v))
end

function search_pair(c)
    req_ranges = map(e -> searchsorted(c, 2020-e), c)
    r = findfirst(r -> length(r) == 1, req_ranges)
    c[r], 2020-c[r]
end

function search_triple(c)
    
