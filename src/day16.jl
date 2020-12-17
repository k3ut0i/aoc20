import Main.listutil

struct Rule
    name :: String
    ranges :: Array{Base.Fix2{typeof(in), UnitRange{Int}}}
end

function parserule(str)
    c = match(r"(.+):\s+(\d+)-(\d+) or (\d+)-(\d+)", str).captures
    nums = map(s -> parse(Int, s), c[2:length(c)])
    Rule(c[1], [in(nums[1]:nums[2]), in(nums[3]:nums[4])])
end

function numsfromcsv(str)
    splitstr = split(str, ',')
    map(n -> parse(Int, n), splitstr)
end

struct ParseException <: Exception end

function readinputs(file)
    ls = readlines(file)
    rules, yourticket, othertickets = Main.listutil.splitlist(f -> f == "", ls)
    if !(yourticket[1] == "your ticket:" && othertickets[1] == "nearby tickets:")
        throw(ParseException)
    else
        map(parserule, rules),
        numsfromcsv(yourticket[2]),
        map(numsfromcsv, othertickets[2:length(othertickets)])
    end
end

function validinrule(num, rule)
    any(f -> f(num), rule.ranges)
end

function validnum(num, rules)
    any(r -> validinrule(num, r), rules)
end

function validticket(nums, rules)
    all(n -> validnum(n, rules), nums)
end

function invalidnuminticket(ticket, rules)
    for n in ticket
        if !validnum(n, rules)
            return n
        end
    end
    0 # default to zero since we require sum
end

function part1(file)
    rules, _, nearby = readinputs(file)
    sum(map(n -> invalidnuminticket(n, rules), nearby))
end

"Return the index of the rule for which all the nums are valid"
function validrule(nums, rules)
    rs = filter(r -> all(n -> validinrule(n, r), nums), rules)
    map(r -> r.name, rs)
end

function validnamesperfield(nearbytickets, rules)
    order = []
    for i in 1:length(nearbytickets[1])
        ith = map(t -> t[i], nearbytickets)
        push!(order, validrule(ith, rules))
    end
    order
end

function writeprolog(constraints, file)
    open(file, "w") do io
        idx = 0
        for c in constraints
            write(io, "idx(")
            show(io, idx)
            write(io, ",X) :- member(X, ")
            show(io, c)
            write(io,  ").\n")
            idx += 1
        end
    end
end

function solveconstraints(prefix, ls)
    if length(ls) == 0
        return [prefix]
    elseif length(ls) == 1
        first_step = filter(l -> !in(l, prefix), ls[1])
        return map(f -> vcat(prefix, f), first_step)
    else
        first_step = filter(l -> !in(l, prefix), ls[1])
        if length(first_step) == 0
            return []
        else
            newprefixes = map(f -> cat(prefix, f, dims=1), first_step)
            return mapreduce(p -> solveconstraints(p, ls[2:length(ls)]),
                             (a, b) -> cat(a, b, dims=1),
                             newprefixes)
        end
    end
end

function part2(file)
    rules, myticket, nearby = readinputs(file)
    validfields = validnamesperfield(filter(n -> validticket(n, rules), nearby), rules)
    Sperm = sortperm(validfields, by=length)
    sortedvalidfields = validfields[Sperm]
    ansperm = solveconstraints([], sortedvalidfields)[1]
    ans = ansperm[invperm(Sperm)]
    depindices = findall(a -> length(a) >= 9 && a[1:9] == "departure", ans)
    prod(myticket[depindices])
end
