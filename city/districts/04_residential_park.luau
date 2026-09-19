-- Residential & Central Park: Коттеджи со скатными крышами и мебелью + Парк с озером, фонтаном, деревьями
return function(city)
    local CHS = game:GetService("ChangeHistoryService")
    CHS:SetWaypoint("Before Residential and Park")

    -- ========================================================
    -- 1. ЦЕНТРАЛЬНЫЙ ПАРК (CC Block: 0, 0)
    -- ========================================================
    local park = city:FindFirstChild("Park") or Instance.new("Folder")
    park.Name = "Park"; park.Parent = city

    -- Sunken Lake
    local lake = Instance.new("Part"); lake.Name = "ParkLake"
    lake.Size = Vector3.new(70, 1.2, 50); lake.Position = Vector3.new(20, -0.4, 15)
    lake.Anchored = true; lake.Material = Enum.Material.Glass; lake.Color = Color3.fromRGB(30, 110, 180)
    lake.Transparency = 0.4; lake.Reflectance = 0.25; lake.CanCollide = false; lake.Parent = park

    -- Fountain in Center
    local fBase = Instance.new("Part"); fBase.Shape = Enum.PartType.Cylinder
    fBase.Size = Vector3.new(1.8, 22, 22); fBase.CFrame = CFrame.new(0, 0.9, 0) * CFrame.Angles(0, 0, math.rad(90))
    fBase.Anchored = true; fBase.Material = Enum.Material.Marble; fBase.Color = Color3.fromRGB(230, 230, 235); fBase.Parent = park

    local fJet = Instance.new("Part"); fJet.Size = Vector3.new(2, 6, 2); fJet.Position = Vector3.new(0, 4.5, 0)
    fJet.Anchored = true; fJet.Material = Enum.Material.Neon; fJet.Color = Color3.fromRGB(150, 230, 255); fJet.Parent = park

    -- Walking Paths (Cross pattern)
    local pCol = Color3.fromRGB(180, 175, 165)
    local p1 = Instance.new("Part"); p1.Size = Vector3.new(150, 0.2, 8); p1.Position = Vector3.new(0, 0.1, 0)
    p1.Anchored = true; p1.Material = Enum.Material.Concrete; p1.Color = pCol; p1.Parent = park

    local p2 = Instance.new("Part"); p2.Size = Vector3.new(8, 0.2, 150); p2.Position = Vector3.new(0, 0.1, 0)
    p2.Anchored = true; p2.Material = Enum.Material.Concrete; p2.Color = pCol; p2.Parent = park

    -- Park Trees
    local function mkTree(x, z)
        local trunk = Instance.new("Part"); trunk.Shape = Enum.PartType.Cylinder
        trunk.Size = Vector3.new(7, 1.6, 1.6); trunk.CFrame = CFrame.new(x, 3.5, z) * CFrame.Angles(0, 0, math.rad(90))
        trunk.Anchored = true; trunk.Material = Enum.Material.Wood; trunk.Color = Color3.fromRGB(90, 55, 30); trunk.Parent = park

        local crown = Instance.new("Part"); crown.Shape = Enum.PartType.Ball
        crown.Size = Vector3.new(8, 8, 8); crown.Position = Vector3.new(x, 8.5, z)
        crown.Anchored = true; crown.Material = Enum.Material.Grass; crown.Color = Color3.fromRGB(55, 135, 45); crown.Parent = park
    end

    for tx = -40, 40, 25 do
        for tz = -40, 40, 25 do
            if math.abs(tx) > 10 or math.abs(tz) > 10 then
                mkTree(tx, tz)
            end
        end
    end

    -- Park Benches
    for _, bz in ipairs({-18, 18}) do
        local bench = Instance.new("Part"); bench.Size = Vector3.new(6, 1.6, 2); bench.Position = Vector3.new(12, 0.8, bz)
        bench.Anchored = true; bench.Material = Enum.Material.WoodPlanks; bench.Color = Color3.fromRGB(120, 70, 35); bench.Parent = park
    end

    -- ========================================================
    -- 2. ЖИЛОЙ СЕКТОР (NW Block: -210, -210)
    -- ========================================================
    local res = city:FindFirstChild("Residential") or Instance.new("Folder")
    res.Name = "Residential"; res.Parent = city

    local function mkHouse(name, hx, hz, wallColor, roofColor)
        local house = Instance.new("Model"); house.Name = name; house.Parent = res
        local hW, hD, hH = 34, 26, 12

        -- Floor
        local fl = Instance.new("Part"); fl.Size = Vector3.new(hW, 0.6, hD); fl.Position = Vector3.new(hx, 0.3, hz)
        fl.Anchored = true; fl.Material = Enum.Material.WoodPlanks; fl.Color = Color3.fromRGB(180, 140, 95); fl.Parent = house

        -- Solid Back, Left, Right
        local bw = Instance.new("Part"); bw.Size = Vector3.new(hW, hH, 1.2); bw.Position = Vector3.new(hx, hH/2+0.3, hz+hD/2)
        bw.Anchored = true; bw.Material = Enum.Material.WoodPlanks; bw.Color = wallColor; bw.Parent = house

        local lw = Instance.new("Part"); lw.Size = Vector3.new(1.2, hH, hD); lw.Position = Vector3.new(hx-hW/2, hH/2+0.3, hz)
        lw.Anchored = true; lw.Material = Enum.Material.WoodPlanks; lw.Color = wallColor; lw.Parent = house

        local rw = lw:Clone(); rw.Position = Vector3.new(hx+hW/2, hH/2+0.3, hz); rw.Parent = house

        -- Front Wall split for 6-stud doorway
        local doorW = 6
        local sW = (hW - doorW)/2
        local fwL = Instance.new("Part"); fwL.Size = Vector3.new(sW, hH, 1.2); fwL.Position = Vector3.new(hx - (doorW/2 + sW/2), hH/2+0.3, hz-hD/2)
        fwL.Anchored = true; fwL.Material = Enum.Material.WoodPlanks; fwL.Color = wallColor; fwL.Parent = house

        local fwR = fwL:Clone(); fwR.Position = Vector3.new(hx + (doorW/2 + sW/2), hH/2+0.3, hz-hD/2); fwR.Parent = house

        local fwT = Instance.new("Part"); fwT.Size = Vector3.new(doorW, hH - 8, 1.2); fwT.Position = Vector3.new(hx, 8 + (hH-8)/2 + 0.3, hz-hD/2)
        fwT.Anchored = true; fwT.Material = Enum.Material.WoodPlanks; fwT.Color = wallColor; fwT.Parent = house

        -- Peaked Roof using WedgeParts
        for _, side in ipairs({-1, 1}) do
            local wedge = Instance.new("WedgePart")
            wedge.Size = Vector3.new(hD + 2, 5, hW/2 + 1)
            wedge.CFrame = CFrame.new(hx + side * (hW/4), hH + 2.8, hz) * CFrame.Angles(0, math.rad(90 + side * 90), 0)
            wedge.Anchored = true; wedge.Material = Enum.Material.Brick; wedge.Color = roofColor; wedge.Parent = house
        end

        -- Interior: Sofa, Table, Lights
        local sofa = Instance.new("Part"); sofa.Size = Vector3.new(8, 2, 3); sofa.Position = Vector3.new(hx - 8, 1.3, hz + 6)
        sofa.Anchored = true; sofa.Material = Enum.Material.SmoothPlastic; sofa.Color = Color3.fromRGB(60, 80, 120); sofa.Parent = house

        local lamp = Instance.new("Part"); lamp.Size = Vector3.new(3, 0.2, 3); lamp.Position = Vector3.new(hx, hH - 0.2, hz)
        lamp.Anchored = true; lamp.Material = Enum.Material.Neon; lamp.Color = Color3.fromRGB(255, 245, 215); lamp.Parent = house
        local pl = Instance.new("PointLight"); pl.Brightness = 1.2; pl.Range = 18; pl.Parent = lamp
    end

    mkHouse("FamilyCottageA", -240, -240, Color3.fromRGB(190, 165, 130), Color3.fromRGB(140, 50, 45))
    mkHouse("FamilyCottageB", -180, -200, Color3.fromRGB(210, 205, 195), Color3.fromRGB(45, 70, 110))

    CHS:SetWaypoint("After Residential and Park")
    return res
end
