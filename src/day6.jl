function parse_group_answers(filename)
    ls = readlines(filename)
    empty_lines = findall(l -> l == "", ls)
        start_r = cat([1], empty_lines .+ 1, dims=1)
    end_r = cat(empty_lines .- 1, [length(ls)], dims=1)
    a = []
    for (s, e) in collect(zip(start_r, end_r))
        push!(a, ls[range(s, stop=e)])
    end
    a
end

function bvec(str, all)
    map(c -> nothing !== findfirst(c, str), all)
end

function chars_in(strs)
    all = unique(reduce((a, b) -> *(a, b), strs))
    map((str -> bvec(str, all)), strs)
end

function and_bvecs(strs)
    all = unique(reduce((a, b) -> *(a, b), strs))
    reduce(+, map(n -> n == length(strs), reduce(+, chars_in(strs), dims=1)[1]))
end

# Part 2 answer
# reduce(+, map(and_bvecs, parse_group_answers("inputs/day6")))
