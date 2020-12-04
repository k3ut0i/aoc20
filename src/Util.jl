module Util

export takewhile

function takewhile(f::Function, ls)
    # next = iterate(ls)
    # res = []
    # while next !== nothing
    #     (elt, state) = next
    #     if f(res)
    #         push!(res, elt)
    #         next = iterate(next, state)
    #     else
    #         next = nothing
    #     end
    # end
    # res
    idx = findfirst(e -> !f(e), ls)
    if idx === nothing
        return ls
    else
        return ls[range(1, stop=idx-1)]
    end
end

end
