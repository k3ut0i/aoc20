function parsechar(c)
    if c == 'L'
        :empty
    elseif c == '#'
        :occ
    elseif c == '.'
        :floor
    else
        error("Unknown character in the grid")
    end
end
function readfloor(file)
    ls = map(l -> map(parsechar, collect(l)), readlines(file))
end

function inrange(i, j, grid)
    (1 <= i <= length(grid)) &
        (1 <= j <= length(grid[1]))
end

function neighbors(i, j, grid)
    nrows = length(grid)
    ncols = length(grid[1])
    n = [(i-1, j-1), (i-1, j), (i-1, j+1),
         (i, j-1), (i, j+1),
         (i+1, j-1), (i+1, j), (i+1, j+1)]
    filter(p -> inrange(p[1], p[2], grid), n)
end

function noOcc(i, j, grid)
    n = neighbors(i, j, grid)
    count(p -> grid[p[1]][p[2]] == :occ, n)
end
         
function stepg!(grid, occF, occN)
    nrows = length(grid)
    ncols = length(grid[1])
    changes = []
    for i = 1:nrows
        for j = 1:ncols
            no = occF(i, j, grid)
            if grid[i][j] == :empty && no == 0
                push!(changes, (i, j, :occ))
            elseif grid[i][j] == :occ && no >= occN
                push!(changes, (i, j, :empty))
            end
        end
    end
    for c in changes
        grid[c[1]][c[2]] = c[3]
    end
    return length(changes)
end

function printg(grid)
        nrows = length(grid)
    ncols = length(grid[1])
    for i = 1:nrows
        for j = 1:ncols
            c = if grid[i][j] == :occ
                '#'
            elseif grid[i][j] == :empty
                'L'
            else
                '.'
            end
            print(c)
        end
        print("\n")
    end
end

function step_until_no_changes(grid, occF, occN)
    while stepg!(grid, occF, occN) !== 0
    end
    sum(row -> count(e -> e == :occ, row), grid)
end

function noOcc2(i, j, grid)
    nrows = length(grid)
    ncols = length(grid[1])
    ns = []

    #north
    ii = i-1
    while(ii >= 1)
        if grid[ii][j] != :floor
            break
        end
        ii -= 1
    end
    push!(ns, (ii, j))

    ii = i-1
    jj = j+1
    # north east
    while(ii >= 1 && jj <= ncols)
        if grid[ii][jj] != :floor
            break
        end
        ii -=1
        jj +=1
    end
    push!(ns, (ii, jj))
    
    # east
    jj = j+1
    while (jj <= ncols)
        if grid[i][jj] != :floor
            break
        end
        jj += 1
    end
    push!(ns, (i, jj))

    ii = i+1
    jj = j+1
    # south east
    while(ii <= nrows && jj <= ncols)
        if grid[ii][jj] != :floor
            break
        end
        ii +=1
        jj +=1
    end
    push!(ns, (ii, jj))

    # south
    ii = i+1
    while(ii <= nrows)
        if grid[ii][j] != :floor
            break
        end
        ii += 1
    end
    push!(ns, (ii, j))

    ii = i+1
    jj = j-1
    # south west
    while(ii <= nrows && jj >= 1)
        if grid[ii][jj] != :floor
            break
        end
        ii +=1
        jj -=1
    end
    push!(ns, (ii, jj))

    
    #  west
    jj = j-1
    while (jj >= 1)
        if grid[i][jj] != :floor
            break
        end
        jj -= 1
    end
    push!(ns, (i, jj))

    ii = i-1
    jj = j-1
    # north west
    while(ii >= 1 && jj >= 1)
        if grid[ii][jj] != :floor
            break
        end
        ii -=1
        jj -=1
    end
    push!(ns, (ii, jj))
    ns = filter(p -> inrange(p[1], p[2], grid), ns)
    count(p -> grid[p[1]][p[2]] == :occ, ns)
end

function stepP2(g)
    stepg!(g, noOcc2, 5)
    printg(g)
end
