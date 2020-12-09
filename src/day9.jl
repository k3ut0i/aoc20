function getnums(file)
    map(l -> parse(Int, l), readlines(file))
end

function isvalidnum(num, preamble)
    sp = sort(preamble) #for small preamble the overhead might be too large
    findfirst(e -> length(searchsorted(sp, num - e)) !== 0, sp)
end

function checknums(nums, size)
    preamble = nums[1:size]
    rest = nums[size+1:length(nums)]
    for n in rest
#        print(preamble, "\n")
#        print(n, "\n")
        if isvalidnum(n, preamble) == nothing
            return n
        else
            
            preamble[1] = n
            preamble = circshift(preamble, -1)
        end
    end
end

function find_cont_sum(sum, nums)
    len = length(nums)
    i = 1
    while (i <= len)
        j = i
        jsum = 0
        while (j <= len && jsum <= sum)
            if jsum == sum
                return maximum(nums[i:j-1]) + minimum(nums[i:j-1])
            else
                jsum += nums[j]
            end
            j += 1
        end
        i += 1
    end
end
