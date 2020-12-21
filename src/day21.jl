function parseline(l)
    m = match(r"(.*)\(contains(.*)\)", l)
    ingredients_str, allergens_str = map(strip, m.captures)
    ingredients = split(ingredients_str, ' ')
    allergens = split(allergens_str, ',')
    map(strip, allergens), map(strip, ingredients)
end

function readinputs(file)
    ls = readlines(file)
    map(parseline, ls)
end

function createconstraints(allergenlist)
    cs :: Dict{String, Array{String, 1}} = Dict([])
    for (allergens, ingredients) in allergenlist
        for allergen in allergens
            if get(cs, allergen, nothing) === nothing
                cs[allergen] = ingredients
            else
                cs[allergen] = intersect(cs[allergen], ingredients)
            end
        end
    end
    cs
end

function allingredients(allergenlist)
    unique(mapreduce(kv -> kv[2], (acc, l) -> vcat(acc, l), allergenlist))
end

function noallergens(allergenlist)
    allin = allingredients(allergenlist)
    constr = createconstraints(allergenlist)
    allallergics = unique(reduce((acc, l) -> vcat(acc, l), values(constr)))
    setdiff(allin, allallergics)
end

function countoccurences(ingredients, allergenlist)
    ch :: Dict{String, Int} = Dict(map(i -> (i, 0), ingredients))
    for (_, ings) in allergenlist
        for ing in ings
            if get(ch, ing, nothing) !== nothing
                ch[ing] += 1
            end
        end
    end
    ch, sum(values(ch))
end

function solveconstraints!(constraints)
    while(any(kv -> length(kv[2]) !== 1, constraints))
        for (k, v) in constraints
            if length(v) === 1
                for (k1, v1) in constraints
                    if k !== k1
                        constraints[k1] = setdiff(v1, v)
                    end
                end
            end
        end
    end
    # for (k, v) in constraints
    #     constraints[k] = v[1]
    # end
    map(kv -> (kv[1], kv[2][1]), collect(constraints))
end

function dangerouslist(allergenlist)
    cs = createconstraints(allergenlist)
    solvcs = sort(solveconstraints!(cs),by=(kv -> kv[1])) # possible method call error why?
    reduce((acc, kv) -> acc * "," * kv[2], solvcs, init="")
end
