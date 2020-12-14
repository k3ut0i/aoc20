import Main.listutil

function bitarrayToNum(ba)
    reduce((a, b) -> 2*a+b, ba)
end

function applymask(str, num)
    len = length(str)
    ones = bitarrayToNum(map(c -> c == '1', collect(str)))
    zeros = bitarrayToNum(map(c -> c !== '0', collect(str)))
    (num | ones) & zeros
end

function parseline(l)
    m = match(r"((mask)|(mem)\[(\d+)\]) = (\S+)", l)
    if m.captures[2] == "mask"
        :mask, m.captures[5]
    elseif m.captures[3] == "mem"
        :mem, parse(Int, m.captures[4]), parse(Int, m.captures[5])
    else
        error("Un parseable line")
    end
end

function parsefile(f)
    map(parseline, readlines(f))
end

function step_program1(mask, instr, dict)
    if instr[1] == :mask
        instr[2], dict
    else
        dict[instr[2]] = applymask(mask, instr[3])
        mask, dict
    end
end

function decode_masked_addr(mask)
    len = length(mask)
    ids = findall(c -> c == 'X', mask)
    offset = bitarrayToNum(map(c -> c == '1', collect(mask)))
    vals = map(i -> 2^(len-i), ids)
    map(c -> c+offset, map(v -> v == [] ? 0 : sum(v), # sum([]) is error
                           Main.listutil.powerset(vals)))
end

function decode_addr(mask, addr)
    masked = Main.listutil.zipwith((c1, c2) -> c1 == '0' ? c2 : c1, mask, addr)
    decode_masked_addr(masked)
end

function step_program2(mask, instr, dict)
    if instr[1] == :mask
        instr[2], dict
    else # get the 36bit rep using bitstring and type conversion
        addrs = decode_addr(mask, bitstring(Int64(instr[2]))[29:64])
        for add in addrs
            dict[add] = instr[3]
        end
        mask, dict
    end
end

function run_program(file, stepFn)
    is = parsefile(file)
    mask = is[1][1]
    dict = Dict([])
    for instr in is
        mask, dict = stepFn(mask, instr, dict)
    end
    sum(values(dict))
end
