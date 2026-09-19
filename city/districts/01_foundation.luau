-- Mega foundation: 2400x2400 island, ocean, beaches, arterials, markings and signals
return function(city)
    local CHS = game:GetService("ChangeHistoryService")
    CHS:SetWaypoint("Before Mega Foundation")

    local function part(parent, name, size, position, material, color)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.Position = position
        p.Anchored = true
        p.Material = material
        p.Color = color
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = parent
        return p
    end

    local terrain = Instance.new("Folder")
    terrain.Name = "Terrain"
    terrain.Parent = city

    part(terrain, "IslandCliff", Vector3.new(2420, 42, 2420), Vector3.new(0, -22, 0), Enum.Material.Rock, Color3.fromRGB(104, 91, 75))
    part(terrain, "IslandBase", Vector3.new(2400, 8, 2400), Vector3.new(0, -4, 0), Enum.Material.Grass, Color3.fromRGB(72, 124, 57))

    local ocean = part(terrain, "Ocean", Vector3.new(6200, 3, 6200), Vector3.new(0, -35, 0), Enum.Material.Glass, Color3.fromRGB(23, 92, 171))
    ocean.Transparency = 0.28
    ocean.Reflectance = 0.12
    ocean.CanCollide = false

    local sand = Color3.fromRGB(221, 202, 162)
    part(terrain, "NorthBeach", Vector3.new(2400, 5, 35), Vector3.new(0, -1.5, -1190), Enum.Material.Sand, sand)
    part(terrain, "SouthBeach", Vector3.new(2400, 5, 35), Vector3.new(0, -1.5, 1190), Enum.Material.Sand, sand)
    part(terrain, "WestBeach", Vector3.new(35, 5, 2400), Vector3.new(-1190, -1.5, 0), Enum.Material.Sand, sand)
    part(terrain, "EastBeach", Vector3.new(35, 5, 2400), Vector3.new(1190, -1.5, 0), Enum.Material.Sand, sand)

    local lighting = game:GetService("Lighting")
    lighting.ClockTime = 14.5
    lighting.Brightness = 2.2
    lighting.Ambient = Color3.fromRGB(82, 87, 99)
    lighting.OutdoorAmbient = Color3.fromRGB(140, 149, 160)
    local atmosphere = lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
    atmosphere.Density = 0.28
    atmosphere.Offset = 0.08
    atmosphere.Color = Color3.fromRGB(199, 211, 230)
    atmosphere.Decay = Color3.fromRGB(100, 121, 154)
    atmosphere.Glare = 0.16
    atmosphere.Haze = 1.05
    atmosphere.Parent = lighting

    local roads = Instance.new("Folder")
    roads.Name = "Roads"
    roads.Parent = city
    local asphalt = Color3.fromRGB(44, 45, 49)
    local concrete = Color3.fromRGB(177, 176, 171)
    local yellow = Color3.fromRGB(238, 195, 36)
    local white = Color3.fromRGB(235, 235, 230)

    local function line(name, size, position, color)
        return part(roads, name, size, position, Enum.Material.SmoothPlastic, color)
    end

    -- Four-lane avenues divide the island into a 3x3 grid.
    for _, x in ipairs({-400, 400}) do
        part(roads, "NorthSouthAvenue", Vector3.new(44, 0.35, 2400), Vector3.new(x, 0.18, 0), Enum.Material.Asphalt, asphalt)
        part(roads, "Sidewalk", Vector3.new(10, 0.65, 2400), Vector3.new(x - 27, 0.33, 0), Enum.Material.Concrete, concrete)
        part(roads, "Sidewalk", Vector3.new(10, 0.65, 2400), Vector3.new(x + 27, 0.33, 0), Enum.Material.Concrete, concrete)
        line("Median", Vector3.new(2.4, 0.5, 2400), Vector3.new(x, 0.42, 0), Color3.fromRGB(77, 130, 62))
        for z = -1160, 1160, 40 do
            line("LaneDash", Vector3.new(0.35, 0.04, 18), Vector3.new(x - 11, 0.39, z), white)
            line("LaneDash", Vector3.new(0.35, 0.04, 18), Vector3.new(x + 11, 0.39, z), white)
        end
        line("CenterYellow", Vector3.new(0.25, 0.05, 2400), Vector3.new(x - 1.5, 0.45, 0), yellow)
        line("CenterYellow", Vector3.new(0.25, 0.05, 2400), Vector3.new(x + 1.5, 0.45, 0), yellow)
    end

    for _, z in ipairs({-400, 400}) do
        part(roads, "EastWestAvenue", Vector3.new(2400, 0.35, 44), Vector3.new(0, 0.19, z), Enum.Material.Asphalt, asphalt)
        part(roads, "Sidewalk", Vector3.new(2400, 0.65, 10), Vector3.new(0, 0.33, z - 27), Enum.Material.Concrete, concrete)
        part(roads, "Sidewalk", Vector3.new(2400, 0.65, 10), Vector3.new(0, 0.33, z + 27), Enum.Material.Concrete, concrete)
        line("Median", Vector3.new(2400, 0.5, 2.4), Vector3.new(0, 0.42, z), Color3.fromRGB(77, 130, 62))
        for x = -1160, 1160, 40 do
            line("LaneDash", Vector3.new(18, 0.04, 0.35), Vector3.new(x, 0.39, z - 11), white)
            line("LaneDash", Vector3.new(18, 0.04, 0.35), Vector3.new(x, 0.39, z + 11), white)
        end
        line("CenterYellow", Vector3.new(2400, 0.05, 0.25), Vector3.new(0, 0.45, z - 1.5), yellow)
        line("CenterYellow", Vector3.new(2400, 0.05, 0.25), Vector3.new(0, 0.45, z + 1.5), yellow)
    end

    local function trafficLight(x, z, rotation)
        local model = Instance.new("Model")
        model.Name = "TrafficLight"
        model.Parent = roads
        local pole = part(model, "Pole", Vector3.new(0.8, 13, 0.8), Vector3.new(x, 6.5, z), Enum.Material.Metal, Color3.fromRGB(63, 67, 72))
        pole.CFrame = CFrame.new(x, 6.5, z) * CFrame.Angles(0, rotation, 0)
        local arm = part(model, "Arm", Vector3.new(9, 0.65, 0.65), Vector3.new(x, 12, z), Enum.Material.Metal, pole.Color)
        arm.CFrame = CFrame.new(x, 12, z) * CFrame.Angles(0, rotation, 0)
        for i, color in ipairs({Color3.fromRGB(235, 45, 40), Color3.fromRGB(240, 190, 35), Color3.fromRGB(45, 210, 85)}) do
            local lens = part(model, "Signal", Vector3.new(1.15, 1.15, 0.35), Vector3.new(x + math.cos(rotation) * (5.5 + i * 1.5), 12, z - math.sin(rotation) * (5.5 + i * 1.5)), Enum.Material.Neon, color)
            lens.CanCollide = false
        end
    end

    for _, x in ipairs({-400, 400}) do
        for _, z in ipairs({-400, 400}) do
            trafficLight(x - 30, z - 30, 0)
            trafficLight(x + 30, z + 30, math.pi)
            for offset = -16, 16, 4 do
                line("Crosswalk", Vector3.new(2, 0.05, 8), Vector3.new(x + offset, 0.47, z - 27), white)
                line("Crosswalk", Vector3.new(8, 0.05, 2), Vector3.new(x - 27, 0.47, z + offset), white)
            end
        end
    end

    CHS:SetWaypoint("After Mega Foundation")
    return roads
end
