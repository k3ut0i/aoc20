module listutil

export powerset, zipwith, splitlist

"Return he power set of all elements of ITR"
function powerset(itr, state = nothing)
    if state === nothing
        first_itr = iterate(itr)
    else
        first_itr = iterate(itr, state)
    end
    
    if first_itr === nothing
        []
    else
        elem, next = first_itr
        rest = powerset(itr, next)
        if rest == []
            [[], [elem]]
        else
            mapreduce(e -> [e, cat(e, elem, dims=1)],
                      append!, rest)
        end
    end
end

"Standard zip with a binary function"
function zipwith(f, itr1, itr2)
    e1s = iterate(itr1)
    e2s = iterate(itr2)
    collection = []
    while !(e1s === nothing || e2s === nothing)
        e1, s1 = e1s
        e2, s2 = e2s
        push!(collection, f(e1, e2))
        e1s = iterate(itr1, s1)
        e2s = iterate(itr2, s2)
    end
    collection
end

function zipwith(f, str1 :: String, str2 :: String) :: String
    sl = invoke(zipwith, Tuple{Any, Any, Any}, f, str1, str2)
    String(map(Char, sl)) # Is there a way to cast sl to Array{Char, 1} type?
end

"Split the list LS at elements where f is true"
function splitlist(f, ls)
    ids = findall(f, ls)
    start_ids = cat(1, map(x -> x+1, ids), dims=1)
    end_ids = cat(map(x -> x - 1, ids), length(ls), dims=1)
    map(r -> ls[r], zipwith(:, start_ids, end_ids))
end

end

