function decode_bsp(str, onechar)
    reduce((a, b) -> 2*a+b, map(c -> (c==onechar), collect(str)))
end

function seat_id(str)
    rowStr = str[range(1, stop=7)]
    colStr = str[range(8, stop=10)]
    decode_bsp(rowStr, 'B') * 8 + decode_bsp(colStr, 'R')
end

function find_max_and_seat(nums)
    min = minimum(nums)
    max = maximum(nums)
    prev = min - 1
    for f in sort(nums)
        if f !== prev+1
            return max, prev+1
        else
            prev = prev + 1
        end
    end
end

function solution(filename)
    find_max_and_seat(map(seat_id, readlines(filename)))
end
