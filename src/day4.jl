function parseinputs(filename)
    ls = readlines(filename)
    empty_lines = findall(l -> l == "", ls)
    start_r = cat([1], empty_lines .+ 1, dims=1)
    end_r = cat(empty_lines .- 1, [length(ls)], dims=1)
    a = []
    for (s, e) in collect(zip(start_r, end_r))
        push!(a, ls[range(s, stop=e)])
    end
    map(p -> reduce((s1, s2) -> (s1 * " ") * s2, p), a)
end

function is_valid(entry)
    field_strs = split(entry)
    fields = map(e -> (split(e, ':'))[1], field_strs)
    no_cid = ["byr", "ecl", "eyr", "hcl", "hgt", "iyr", "pid"]
    issubset(no_cid, fields)
end

function makepair(a)
    (a[1], a[2])
end

function parse_year(str)
    all(isdigit, str) &&
        parse(Int, str)
end
function parse_height(str)
    try
        len = length(str)
        type = str[len-1:len]
        mult = type == "cm" ? 1 : 2.54
        parse(Int, str[1:len-2]) * mult
    catch e
        false
    end
end

function get_data(str)
    entries_s = split(str)
    entries = map(e -> makepair(split(e, ':')), entries_s)
    ed = Dict(entries)
    nd = Dict([]):: Dict{Any, Any}
    nd["byr"] = parse_year(get(ed, "byr", "0"))
    nd["iyr"] = parse_year(get(ed, "iyr", "0"))
    nd["eyr"] = parse_year(get(ed, "eyr", "0"))
    nd["hgt"] = parse_height(get(ed, "hgt", "0cm"))
    nd["hcl"] = get(ed, "hcl", "")
    nd["ecl"] = get(ed, "ecl", "")
    nd["pid"] = get(ed, "pid", "")
    nd
end

function is_valid_hair_color(str)
    try
        str[1] == '#' &&
            all((c -> (isdigit(c) || 'a' <= c <= 'f')), str[2:length(str)])
    catch e
        false
    end
end

function is_valid_eye_color(str)
    in(str, ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
end

function is_valid2(data)
    (1920 <= data["byr"] <= 2002) &&
    (2010 <= data["iyr"] <= 2020) &&
    (2020 <= data["eyr"] <= 2030) &&
    (150 <= data["hgt"] <= 193) &&
    (is_valid_hair_color(data["hcl"])) &&
    (is_valid_eye_color(data["ecl"])) &&
    (all(isdigit, data["pid"]) && length(data["pid"])==9)
end
