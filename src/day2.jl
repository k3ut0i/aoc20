function parseline(str)
    cs = match(r"(\d+)-(\d+)\s+([[:alpha:]]):\s+([[:alpha:]]+)", str).captures
    parse(Int, cs[1]), parse(Int, cs[2]), cs[3][1], cs[4]
end

function isValidPass1(policy)
    policy[1] <= count(==(policy[3]), policy[4]) <= policy[2]
end

function isValidPass2(policy)
    fst_match = policy[4][policy[1]] == policy[3]
    snd_match = policy[4][policy[2]] == policy[3]
    xor(fst_match, snd_match)
end

function solution(filename)
    ls = map(parseline, readlines(filename))
    count(isValidPass1, ls), count(isValidPass2, ls)
end

