function boolvectonum(ls)
    reduce((a, b) -> 2*a + b, ls)
end

function gettile(ls)
    m = match(r"Tile (\d+)", ls[1])
    tilenum = parse(Int, m.captures[1])
    bfn = l -> map(c -> c === '#' ? 1 : 0, collect(l))
    boolarray = transpose(hcat(map(bfn, ls[2:length(ls)])...))
    rows, cols = size(boolarray)
    tilenum, map(boolvectonum, [boolarray[1,:], # up
                                boolarray[:,cols], # left
                                boolarray[rows,:], # bottom
                                boolarray[:,1]]) # right
end

function readtiles(file)
    ls = readlines(file)
    tilestrs = Main.listutil.splitlist(l -> l == "", ls)
    tiles = map(gettile, tilestrs)
    Dict(tiles)
end

"Rotate the tile clockwise by n*90 degress for n=1,2,3"
function rotatetile!(tiles, tile, n)
    if 1 <= n <= 3
        tiles[tile] = circshift(tiles[tile], n)
    else
        error("rotation requested for unsupported amount.")
    end
end

"Replace the tile with its mirror image along the middle column"
function fliptile!(tiles, tile)
    t, l, b, r = tiles[tile]
    tiles[tile] = [t, r, b, l]
end

function matchwith(tile, with, tiles)
    tile_borders = tiles[tile]
    with_borders = tiles[with]
    any(tile_borders) do tb
        any(with_borders) do wb
            tb == wb || bitstring(tb)[55:64] == reverse(bitstring(wb)[55:64])
        end
    end
end

"Return possible tiles that match borders with TILE"
function matchingtiles(tile, tiles)
    tile_borders = tiles[tile]
    findall(w -> matchwith(tile, w, tiles), collect(keys(tiles)))
    # do matching and the actions that require the match
end

function findcorners(tiles)
    tilenums = collect(keys(tiles))
    findall(tilenums) do tile
        length(matchingtiles(tile, tiles)) == 3
    end
end
