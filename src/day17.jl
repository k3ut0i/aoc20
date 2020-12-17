function gettrinary(n)
    q0 = (n % 3) - 1
    q1 = (div(n, 3) % 3) - 1
    q2 = (div(n, 9) % 3) - 1
    q0, q1, q2
end

# Why is my macro not working within a function ?
macro getneighbors(x, y, z)
    ls = []
    for i in vcat(0:12, 14:26)
        xd, yd, zd = gettrinary(i)
        push!(ls, :(($x + $xd, $y + $yd, $z + $zd)))
    end
    return Expr(:vect, ls...)
end

function getn(x, y, z)
    ls = []
    for i in vcat(0:12, 14:26)
        xd, yd, zd = gettrinary(i)
        push!(ls, (x + xd, y + yd, z + zd))
    end
    ls
end

function readinput(file; dims = 3)
    ls = readlines(file)
    init = map(ls) do line
        map(c -> c === '.' ? :inactive : :active, collect(line))
    end
    init_vals = []
    for i in 1:length(init), j in 1:length(init[1])
        pt = dims === 3 ? (i-1, j-1, 0) : (i-1, j-1, 0, 0)
        push!(init_vals, (pt, init[i][j]))
    end
    Dict(init_vals)
end

function step_game(state, getn=getn)
    newstate = Dict([])
    # add all the surrounding neighbours to the context
    for k in keys(state)
        nk = getn(k...)
        for n in nk
            newstate[n] = get(state, n, :inactive)
        end
    end
    # now change them simultaneously
    for k in keys(newstate)
        nk = getn(k...)
        status = get(state, k, :inactive)
        activen = count(n -> get(state, n, :inactive) === :active, nk)
        if (status === :inactive && activen === 3) ||
            (status === :active && 2 <= activen <= 3)
            newstate[k] = :active
        else
            newstate[k] = :inactive
        end
    end
    newstate
end

function step_ntimes_active_count(state, n, getn=getn)
    for i in 1:n
        state = step_game(state, getn)
    end
    count(kv -> kv[2] === :active, state)
end

function getquadrinary(n)
    q0 = (n % 3) - 1
    q1 = (div(n, 3) % 3) - 1
    q2 = (div(n, 9) % 3) - 1
    q3 = (div(n, 27) % 3) - 1
    q0, q1, q2, q3
end

function getn2(x, y, z, w)
    ls = []
    for i in vcat(0:39, 41:80)
        xd, yd, zd, wd = getquadrinary(i)
        push!(ls, (x + xd, y + yd, z + zd, w + wd))
    end
    ls
end
