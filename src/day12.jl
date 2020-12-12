function parseline(line)
    m = match(r"(N|S|E|W|L|R|F)([[:digit:]]+)", line)
    m.captures[1], parse(Int, m.captures[2])
end
function parsefile(file)
    map(parseline, readlines(file))
end

function ship_step(pos, dir)
    ship_dir, x, y = pos
    if dir[1] == "N"
        ship_dir, x, (y+dir[2])
    elseif dir[1] == "S"
        ship_dir, x, (y-dir[2])
    elseif dir[1] == "E"
        ship_dir, (x+dir[2]), y
    elseif dir[1] == "W"
        ship_dir, (x-dir[2]), y
    elseif dir[1] == "F"
        ship_dir, round(x+cosd(ship_dir)*dir[2]), round(y+sind(ship_dir)*dir[2])
    elseif dir[1] == "L"
        ship_dir + dir[2], x, y
    elseif dir[1] == "R"
        ship_dir - dir[2], x, y
    else
        error("Unknown direction")
    end
end

function travel(dirs)
    ship_pos = 0, 0, 0
    for d in dirs
        ship_pos = ship_step(ship_pos, d)
    end
    ship_pos
end

function rotate_point((x, y), angle)
#    r = sqrt((x-x0)^2 + (y-y0)^2)
    round(x*cosd(angle) - y*sind(angle)),
    round(x*sind(angle) + y*cosd(angle))
end

function change_waypoint(ship_pos, waypoint, dir)
    x, y = waypoint
    x0, y0 = ship_pos
    if dir[1] == "N"
        x, (y+dir[2])
    elseif dir[1] == "S"
        x, (y-dir[2])
    elseif dir[1] == "E"
        (x+dir[2]), y
    elseif dir[1] == "W"
        (x-dir[2]), y
    elseif dir[1] == "L"
        rotate_point((x, y), dir[2])
    elseif dir[1] == "R"
        rotate_point((x, y), -dir[2])
    else
        error("Unknown direction")
    end    
end

function ship_step2(ship_pos, waypoint, dir)
    x , y = ship_pos
    dx, dy = waypoint
    if dir[1] == "F"
        (x + dx * dir[2], y + dy * dir[2]), waypoint
    else
        ship_pos, change_waypoint(ship_pos, waypoint, dir)
    end
end

function travel2(dirs)
    ship_pos = 0, 0
    way_point = 10, 1
    for d in dirs
        ship_pos, way_point = ship_step2(ship_pos, way_point, d)
    end
    ship_pos, way_point
end
