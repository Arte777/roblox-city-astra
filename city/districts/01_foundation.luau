-- Foundation: Остров 640x640, скалы, океан, пляжи, дорожная сеть, разметка и атмосфера
return function(city)
    local CHS = game:GetService("ChangeHistoryService")
    CHS:SetWaypoint("Before Foundation")

    -- Main island surface
    local island = Instance.new("Part")
    island.Name = "IslandBase"
    island.Size = Vector3.new(640, 6, 640)
    island.Position = Vector3.new(0, -3, 0)
    island.Anchored = true
    island.Material = Enum.Material.Grass
    island.Color = Color3.fromRGB(78, 122, 52)
    island.TopSurface = Enum.SurfaceType.Smooth
    island.Parent = city

    -- Rocky cliff beneath island
    local cliff = Instance.new("Part")
    cliff.Name = "IslandCliff"
    cliff.Size = Vector3.new(650, 28, 650)
    cliff.Position = Vector3.new(0, -20, 0)
    cliff.Anchored = true
    cliff.Material = Enum.Material.Rock
    cliff.Color = Color3.fromRGB(112, 98, 78)
    cliff.Parent = city

    -- Ocean plane
    local ocean = Instance.new("Part")
    ocean.Name = "Ocean"
    ocean.Size = Vector3.new(4000, 2, 4000)
    ocean.Position = Vector3.new(0, -34.5, 0)
    ocean.Anchored = true
    ocean.Material = Enum.Material.Glass
    ocean.Color = Color3.fromRGB(22, 85, 165)
    ocean.Transparency = 0.3
    ocean.Reflectance = 0.12
    ocean.CanCollide = false
    ocean.Parent = city

    -- Sand beaches around the island edges
    for _, d in ipairs({
        {640, 4, 16, 0, -2, -320},
        {640, 4, 16, 0, -2, 320},
        {16, 4, 640, -320, -2, 0},
        {16, 4, 640, 320, -2, 0},
    }) do
        local b = Instance.new("Part")
        b.Name = "Beach"
        b.Size = Vector3.new(d[1], d[2], d[3])
        b.Position = Vector3.new(d[4], d[5], d[6])
        b.Anchored = true
        b.Material = Enum.Material.Sand
        b.Color = Color3.fromRGB(218, 198, 158)
        b.Parent = city
    end

    -- Lighting setup
    local L = game:GetService("Lighting")
    L.ClockTime = 14.5
    L.Brightness = 2.2
    L.OutdoorAmbient = Color3.fromRGB(138, 146, 156)
    L.Ambient = Color3.fromRGB(82, 86, 98)

    local atm = L:FindFirstChildOfClass("Atmosphere")
    if not atm then atm = Instance.new("Atmosphere") end
    atm.Density = 0.3
    atm.Offset = 0.1
    atm.Color = Color3.fromRGB(198, 208, 228)
    atm.Decay = Color3.fromRGB(98, 118, 152)
    atm.Glare = 0.15
    atm.Haze = 1.2
    atm.Parent = L

    -- ROADS
    local roads = Instance.new("Folder")
    roads.Name = "Roads"
    roads.Parent = city

    local asphalt = Color3.fromRGB(46, 46, 50)
    local swColor = Color3.fromRGB(172, 170, 165)
    local curbCol = Color3.fromRGB(188, 186, 182)

    local function mkPart(name, sx, sy, sz, px, py, pz, mat, col, par)
        local p = Instance.new("Part")
        p.Name = name; p.Size = Vector3.new(sx, sy, sz)
        p.Position = Vector3.new(px, py, pz)
        p.Anchored = true; p.Material = mat; p.Color = col
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = par
        return p
    end

    -- N-S Roads (along Z)
    for _, rx in ipairs({-100, 100}) do
        mkPart("NSRoad", 24, 0.3, 640, rx, 0.15, 0, Enum.Material.Asphalt, asphalt, roads)
        mkPart("Sidewalk", 8, 0.5, 640, rx - 16, 0.25, 0, Enum.Material.Concrete, swColor, roads)
        mkPart("Sidewalk", 8, 0.5, 640, rx + 16, 0.25, 0, Enum.Material.Concrete, swColor, roads)
        mkPart("Curb", 0.8, 0.7, 640, rx - 12.4, 0.35, 0, Enum.Material.Concrete, curbCol, roads)
        mkPart("Curb", 0.8, 0.7, 640, rx + 12.4, 0.35, 0, Enum.Material.Concrete, curbCol, roads)
    end

    -- E-W Roads (along X)
    for _, rz in ipairs({-100, 100}) do
        mkPart("EWRoad", 640, 0.3, 24, 0, 0.15, rz, Enum.Material.Asphalt, asphalt, roads)
        mkPart("Sidewalk", 640, 0.5, 8, 0, 0.25, rz - 16, Enum.Material.Concrete, swColor, roads)
        mkPart("Sidewalk", 640, 0.5, 8, 0, 0.25, rz + 16, Enum.Material.Concrete, swColor, roads)
        mkPart("Curb", 640, 0.7, 0.8, 0, 0.35, rz - 12.4, Enum.Material.Concrete, curbCol, roads)
        mkPart("Curb", 640, 0.7, 0.8, 0, 0.35, rz + 12.4, Enum.Material.Concrete, curbCol, roads)
    end

    -- Intersections
    for _, rx in ipairs({-100, 100}) do
        for _, rz in ipairs({-100, 100}) do
            mkPart("Intersection", 24, 0.3, 24, rx, 0.16, rz, Enum.Material.Asphalt, asphalt, roads)
        end
    end

    -- Road Markings
    local mk = Instance.new("Folder")
    mk.Name = "Markings"
    mk.Parent = roads

    local Y = Color3.fromRGB(232, 192, 32)
    local W = Color3.fromRGB(222, 222, 218)

    local function ln(sx, sz, px, pz, c)
        local l = Instance.new("Part")
        l.Name = "Line"
        l.Size = Vector3.new(sx, 0.04, sz)
        l.Position = Vector3.new(px, 0.34, pz)
        l.Anchored = true
        l.Material = Enum.Material.SmoothPlastic
        l.Color = c
        l.TopSurface = Enum.SurfaceType.Smooth
        l.Parent = mk
    end

    -- Center Double Yellows
    for _, rx in ipairs({-100, 100}) do
        ln(0.25, 600, rx - 0.35, 0, Y)
        ln(0.25, 600, rx + 0.35, 0, Y)
    end
    for _, rz in ipairs({-100, 100}) do
        ln(600, 0.25, 0, rz - 0.35, Y)
        ln(600, 0.25, 0, rz + 0.35, Y)
    end

    -- Zebra Crosswalks
    for _, rx in ipairs({-100, 100}) do
        for _, rz in ipairs({-100, 100}) do
            for _, dz in ipairs({-14, 14}) do
                for i = -9, 9, 2.2 do
                    ln(1, 4.5, rx + i, rz + dz, W)
                end
            end
            for _, dx in ipairs({-14, 14}) do
                for i = -9, 9, 2.2 do
                    ln(4.5, 1, rx + dx, rz + i, W)
                end
            end
        end
    end

    CHS:SetWaypoint("After Foundation")
    return roads
end
