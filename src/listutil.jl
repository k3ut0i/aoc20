module listutil

export powerset, zipwith

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

end
