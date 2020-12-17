function readnums(file)
    map(l -> parse(Int, l), readlines(file))
end

function difflist(in)
    nums = cat(0, sort(in), dims=1)
    numsnext = cat(nums[2:length(nums)], maximum(nums)+3, dims=1)
    numsnext - nums
end

function onesTimesThrees(ls)
    ones = count(e -> e == 1, ls)
    threes = count(e -> e == 3, ls)
    ones*threes
end

function getadapts(file)
    nums = readnums(file)
    cat(0, sort(nums), maximum(nums) + 3, dims=1)
end


function find_in_range(idx, nums)
    rs = filter(f -> f > 0, idx-3:idx-1)
    filter(e -> nums[e] >= nums[idx] - 3, rs)
end

# Dict for memoizing known paths to a node.
function possible_paths(idx, nums, dict)
    if get!(dict, idx, nothing) !== nothing
        return dict[idx]
    end
    if idx == 1
        dict[idx] = 1
        return 1
    else
        prev = find_in_range(idx, nums)
        dict[idx] = sum(p -> possible_paths(p, nums, dict), prev)
    end
end
