function re_s(str)
    replace(str, ' '=> '_')
end
function parseline(str)
    m = match(r"(.*) bags contain (.*)\.", str)
    bag = m.captures[1]
    if m.captures[2] == "no other bags"
        return re_s(bag), nothing
    else
        bags = map(map(strip, split(m.captures[2], ','))) do s
            bsm = match(r"(\d+) (.*) bags?", s).captures
            re_s(bsm[2]), parse(Int64, bsm[1])
        end
        return re_s(bag), Dict(bags)
    end
end

function get_rules(filename)
    Dict(map(parseline, readlines(filename)))
end

function draw_rules(infile, outfile)
    rs = get_rules(infile)
    open(outfile, "w") do io
        write(io, "digraph rules{\n")
        for (bag, contents) in pairs(rs)
            if contents !== nothing
                for (bagC, num) in pairs(contents)
                    write(io, bag, " -> ", bagC, "[weight=")
                    show(io, num)
                    write(io, "]\n")
                end
            end
        end
        write(io, "}\n")
    end
end

function flesh_rules(rules)
    for (bag, contents) in pairs(rules)
        if contents !== nothing
            for (bagC, num) in pairs(contents)
                if rules[bagC] !== nothing
                    mergewith!((a, b) -> a + num * b, contents, rules[bagC])
                    delete!(contents, bagC)
                end
            end
        end
    end
end

function count_rules_with(rules, bag)
    count = 0
    for (_, con) in pairs(rules)
        if con !== nothing && haskey(con, bag)
            count += 1
            end
    end
    count
end

function rank_bag(bag, rules)
    if rules[bag] === nothing
        1
    else
        1+ reduce(*, map(b -> rank_bag(b, rules), collect(keys(rules[bag]))))
    end
end

function get_ranks(rules)
    sort(collect(keys(rules)); by=(b -> rank_bag(b, rules)))
end

function flesh_rule(bag, rules)
    if rules[bag] !== nothing
        for (bagC, num) in pairs(rules[bag])
            if rules[bagC] !== nothing
                mergewith!((a, b) -> a + num * b, rules[bag], rules[bagC])
            end
        end
    end    
end
