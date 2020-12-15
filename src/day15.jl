function init_seq(ls)
    len = length(ls)
    butlast = ls[1:len-1]
    ls[len], len+1, Dict(zip(butlast, (zip(1:len-1, ones(Int, len-1)))))
end

function step_seq(prev, stepnum, dict)
    num, count = get(dict, prev, (stepnum-1, 0))
    if count == 0
        dict[prev] = stepnum - 1, 1
        0, stepnum + 1, dict
    else
        dif = stepnum - num - 1
        dict[prev] = stepnum - 1, count + 1
        dif, stepnum + 1, dict
    end
end

function nth_num(n, initnums)
    prev, nth, dict = init_seq(initnums)
    while nth <= n
        prev, nth, dict = step_seq(prev, nth, dict)
#        print(nth, " ", prev, " ", dict, "\n")
    end
    prev
end
