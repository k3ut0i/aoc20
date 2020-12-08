function parseline(str)
    m = match(r"(acc|nop|jmp) (\+|\-)(\d+)", str)
    op = m.captures[1]
    sign = m.captures[2]
    val = m.captures[3]
    op_s = if op == "nop"
        :nop
    elseif op == "jmp"
        :jmp
    else
        :acc
    end
    sign_s = if sign == "+"; :plus else :minus end
    op_s, sign_s, parse(Int, val)
end

function get_code(filename)
    map(parseline, readlines(filename))
end

function change_ip(sign, val, ip)
    if sign == :plus
        ip + val
    else
        ip - val
    end
end

function change_context(sign, val, context)
    if sign == :plus
        context + val
    else
        context - val
    end
end

function step_instruction(ip, program, context)
#    print(ip, ":", program[ip], "\n")
    op, sign, val = program[ip]
    if op == :nop
        return ip+1, context
    elseif op == :acc
        ip+1, change_context(sign, val, context)
    elseif op == :jmp
        change_ip(sign, val, ip), context
    else
        throw("Unknown instruction")
    end
end

function run_instructions_once(program)
    l = length(program)
    m = Dict(zip(range(1, length=l), zeros(l)))
    ip = 1
    ip_list = []
    acc = 0
    while (ip <= l && m[ip] < 1)
        push!(ip_list, ip)
        m[ip] += 1
        ip, acc = step_instruction(ip, program, acc)
    end
    acc, ip, ip_list
end

function flip_at(ip, program)
    op, sign, val = program[ip]
    op_new = if op == :jmp; :nop elseif op == :nop; :jmp else op end
    program[ip] = (op_new, sign, val)
end

function try_all(program)
    len = length(program)
    _, _, ip_list = run_instructions_once(program)
    for idx in ip_list
        flip_at(idx, program)
        acc, ip, _ = run_instructions_once(program)
        print(acc, ";", ip, "\n")
        if ip > len
            return acc
        else
            flip_at(idx, program)
        end
    end
end
