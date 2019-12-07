class 'pgps'

-- waypoint locations
local waypoints = {}

-- exclusion locations (will not pathfind through area)
local exclusions = {}

-- cache world geometry
local cachedWorld = {}
-- cached wrld with block names
local cachedWorldDetail = {}

local aged = {}

-- A* parameters
local stopAt, nilCost = 1500, 1000

-- Directions
local North, West, South, East, Up, Down = 0, 1, 2, 3, 4, 5
local shortNames = {[North] = "N", [West] = "W", [South] = "S",
                    [East] = "E", [Up] = "U", [Down] = "D" }
local deltas = {[North] = {0, 0, -1}, [West] = {-1, 0, 0}, [South] = {0, 0, 1},
                [East] = {1, 0, 0}, [Up] = {0, 1, 0}, [Down] = {0, -1, 0}}

----------------------------------------
-- empty
--
-- funtion: test if the cachedWorld is empty
-- return: boolean cachedWorld is empty
--

function empty(table)
    table = table or cachedWorld
    for _, value in pairs(table) do
        if value ~= nil then
            return false
        end
    end
    return true
end

----------------------------------------
-- setBlock
--

function pgps:setBlock(trans, val, detail)
    local idx_block = trans.x..":"..trans.y..":"..trans.z
    cachedWorld[idx_block] = val or 1
    if(detail) then
        cachedWorldDetail[idx_block] = detail
    end
end


----------------------------------------
-- getBlock
--
-- function: tests to see if there is a block or space.
-- return: bool (true if there is a block)
-- return: nil if there is no information on the block
--

function pgps:getBlock(trans)
    local idx_block = trans.x..":"..trans.y..":"..trans.z
    if cachedWorld[idx_block] == nil then
        return nil
    elseif cachedWorld[idx_block] == 1 then
        return true, cachedWorldDetail[idx_block]
    elseif cachedWorld[idx_block] == 0 then
        return false
    else
        return nil
    end
end


function pgps:setWaypoint(name, x, y, z, d)
    d = d or 0
    x = x or nil
    y = y or nil
    z = z or nil
    if x == nil and y == nil and z == nil then
        waypoints[name] = nil
        print("waypoint deleted")
        return true
    end
    waypoints[name] = {x, y, z, d}
    if waypoints[name] ~= nil then
        return true
    else
        return false
    end
end

----------------------------------------
-- getWaypoint
--
-- function: get a waypoint from cache
-- input: name of waypoint
-- returns: waypoint coordinates and direction
-- returns: false if its not found
--

function pgps:getWaypoint(name)
    local x, y, z, d
    if waypoints[name] ~= nil then
        x = waypoints[name][1]
        y = waypoints[name][2]
        z = waypoints[name][3]
        d = waypoints[name][4]
        return x, y, z, d
    else
        print("waypoint "..name.." not found")
        return nil, nil, nil, nil
    end
end

function pgps:setExclusion(idx, y, z)
    local x

    if y == nil and z == nil then
        x = tonumber(string.match(idx, "(.*):"))
        y = tonumber(string.match(idx, ":(.*):"))
        z = tonumber(string.match(idx, ":(.*)"))
    else
        x = idx
        idx = x..":"..y..":"..z
    end
    d = d or 0
    exclusions[idx] = {x, y, z}
    if exclusions[idx] ~= nil then
        return true
    else
        return false
    end
end

----------------------------------------
-- excludeZone
--
-- function: exclude a cuboid
-- input: 2 opposite corners (x, y, z, x2, y2, z2)
-- option: boolean to include the zone
--

function pgps:excludeZone(x, y, z, x2, y2, z2, include)
    local temp, temp2
    temp, temp2 = x, x2
    x = math.min(temp, temp2)
    x2 = math.max(temp, temp2)
    temp, temp2 = y, y2
    y = math.min(temp, temp2)
    y2 = math.max(temp, temp2)
    temp, temp2 = z, z2
    z = math.min(temp, temp2)
    z2 = math.max(temp, temp2)

    for i = x, x2 do
        for j = y, y2 do
            for k = z, z2 do
                if include then
                    delExclusion(i, j, k)
                else
                    setExclusion(i, j, k)
                end
            end
        end
    end
end

----------------------------------------
-- getExclusion
--
-- function: get an exclusion from cache
-- input: index of exclusion: "x:y:z"
-- returns: exclusion coordinates (or nil, nil, nil)
--

function pgps:getExclusion(idx, y, z)
    local x
    if y == nil and z == nil then
        x = tonumber(string.match(idx, "(.*):"))
        y = tonumber(string.match(idx, ":(.*):"))
        z = tonumber(string.match(idx, ":(.*)"))
    else
        x = idx
        idx = x..":"..y..":"..z
    end
    if exclusions[idx] ~= nil then
        x = exclusions[idx][1]
        y = exclusions[idx][2]
        z = exclusions[idx][3]
        return x, y, z
    else
        print("exclusion "..idx.." not found")
        return nil, nil, nil
    end
end

----------------------------------------
-- delExclusion
--
-- function: remove an exclusion from cache
-- input: index of exclusion: "x:y:z" OR x, y, z
-- returns: boolean "success"
--

function pgps:delExclusion(idx, y, z)
    local x
    if y == nil and z == nil then
        x = tonumber(string.match(idx, "(.*):"))
        y = tonumber(string.match(idx, ":(.*):"))
        z = tonumber(string.match(idx, ":(.*)"))
    else
        x = idx
        idx = x..":"..y..":"..z
    end
    exclusions[idx] = nil
    print("exclusion deleted")
    return true
end

----------------------------------------
-- heuristic_cost_estimate
--
-- function: A* heuristic
-- input: X, Y, Z of the 2 points
-- return: Manhattan distance between the 2 points
--

local function heuristic_cost_estimate(x1, y1, z1, x2, y2, z2)
    return math.abs(x2 - x1) + math.abs(y2 - y1) + math.abs(z2 - z1)
end

----------------------------------------
-- reconstruct_path
--
-- function: A* path reconstruction
-- input: A* visited nodes and goal
-- return: List of movement to be executed
--

local function reconstruct_path(_cameFrom, _currentNode)
    if _cameFrom[_currentNode] ~= nil then
        local dir, nextNode = _cameFrom[_currentNode][1], _cameFrom[_currentNode][2]
        local path = reconstruct_path(_cameFrom, nextNode)
        table.insert(path, dir)
        return path
    else
        return {}
    end
end

----------------------------------------
-- a_star
--
-- function: A* path finding
-- input: start and goal coordinates
-- return: List of movement to be executed
--

function pgps:a_star(from, to, discover, priority)
    local x1, y1, z1 = from.x, from.y, from.z
    local x2, y2, z2 = to.x, to.y, to.z
    discover = discover or 1
    local start, idx_start = {x1, y1, z1}, x1..":"..y1..":"..z1
    local goal,  idx_goal  = {x2, y2, z2}, x2..":"..y2..":"..z2
    priority = priority or false

    if exclusions[idx_goal] ~= nil and not priority then
        print("goal is in exclusion zone")
        return {}
    end

    -- If goal is empty, unknown or a turtle position
    if (cachedWorld[idx_goal] ~= 1 or 0)then
        local openset, closedset, cameFrom, g_score, f_score, tries = {}, {}, {}, {}, {}, 0

        openset[idx_start] = start
        g_score[idx_start] = 0
        f_score[idx_start] = heuristic_cost_estimate(x1, y1, z1, x2, y2, z2)

        while not empty(openset) do
            local current, idx_current
            local cur_f = 9999999

            for idx_cur, cur in pairs(openset) do --for each entry in openset
                if cur ~= nil and f_score[idx_cur] <= cur_f then
                    idx_current, current, cur_f = idx_cur, cur, f_score[idx_cur]
                end
            end
            if idx_current == idx_goal then
                return reconstruct_path(cameFrom, idx_goal)
            end

            -- no more than 500 moves
            if cur_f >= stopAt then
                print("max limit")
                break
            end

            openset[idx_current] = nil
            closedset[idx_current] = true

            local x3, y3, z3 = current[1], current[2], current[3]

            for dir = 0, 5 do -- for all direction find the neighbor of the current position, put them on the openset
                local D = deltas[dir]
                local x4, y4, z4 = x3 + D[1], y3 + D[2], z3 + D[3]
                local neighbor, idx_neighbor = {x4, y4, z4}, x4..":"..y4..":"..z4
                if (exclusions[idx_neighbor] == nil or priority) and (((cachedWorld[idx_neighbor] or 0) == 0 ) or idx_neighbor == idx_goal)then -- if its free or unknow and not on exclusion list
                    if closedset[idx_neighbor] == nil then -- if not closed
                        local tentative_g_score = g_score[idx_current] + ((cachedWorld[idx_neighbor] == nil) and discover or 1)
                        if (cachedWorld[idx_neighbor] == 2) then
                            tentative_g_score = tentative_g_score - 1
                        end
                        --if block is undiscovered and there is a value for discover, it adds the discover value. else, it adds 1
                        if openset[idx_neighbor] == nil or tentative_g_score <= g_score[idx_neighbor] then -- tentative_g_score is always at least 1 more than g_score[idx_neighbor] T.T
                            --evaluates to if its not on the open list
                            cameFrom[idx_neighbor] = {dir, idx_current}
                            g_score[idx_neighbor] = tentative_g_score
                            f_score[idx_neighbor] = tentative_g_score + heuristic_cost_estimate(x4, y4, z4, x2, y2, z2)
                            openset[idx_neighbor] = neighbor
                        end
                    end
                end
            end
        end
    end
    print("no path found")
    return false
end

function explore(_range, limitY, drawAMap)--TODO: flag to explore previously explored blocks
    local ox, oy, oz, od = locate()
    local x, y, z, d = 0, 0, 0, 0
    --local i = 0
    --local total = 0
    local toCheck = {}
    local count = 0
    local maxCount
    local idx
    local dist
    local skip
    local yVal = _range
    drawMap = drawMap or false
    limitY = limitY or false

    if limitY then
        yVal = 1
    end

    for dx = -_range, _range do
        for dy = -yVal, yVal do
            for dz = -_range, _range do
                idx = ox+dx..":"..oy+dy..":"..oz+dz
                toCheck[idx] = {ox+dx, oy+dy, oz+dz}--set up the toCheck table
                count = count + 1
            end
        end
    end

    maxCount = count
    while count > 1 do--go through all entries in table
        x, y, z, d = locate()
        dist = 500
        skip = false

        for k, v in pairs(toCheck) do--find closest block to check
            if v[1] == x and v[2] == y and v[3] == z then--if on the block then remove from list
                toCheck[k] = nil
                skip = true--and run again
                count = count - 1
                maxCount = maxCount - 1
                break
            elseif (math.abs(x - v[1]) + math.abs(y - v[2]) + math.abs(z - v[3])) < dist then
                dist = math.abs(x - v[1]) + math.abs(y - v[2]) + math.abs(z - v[3])--TODO: pathfind to the location and use number of instructions instead of huristic distance
                idx = k
                if dist == 1 then
                    break
                end
            end
        end

        if not skip then
            count = count - 1
            moveTo(toCheck[idx][1], toCheck[idx][2], toCheck[idx][3], d, false, nilCost)--still not sure about nilcost
            toCheck[idx] = nil
        end
        sleep(0)--yield... remove this if possible
    end
    -- Go back to the starting point
    print(string.format("\nreturning..."))
    moveTo(ox, oy, oz, od, false, nilCost)
end

return pgps()