-- Bedroom District, Warehouses & Suspension Bridge
return function(city)
    local CHS = game:GetService("ChangeHistoryService")
    CHS:SetWaypoint("Before Bedroom Warehouses Bridge")

    -- ========================================================
    -- 1. СПАЛЬНЫЙ РАЙОН: МНОГОЭТАЖКА (SW Block: -210, 210)
    -- ========================================================
    local bed = city:FindFirstChild("BedroomDistrict") or Instance.new("Folder")
    bed.Name = "BedroomDistrict"; bed.Parent = city

    local apt = Instance.new("Model"); apt.Name = "ApartmentBuilding"; apt.Parent = bed
    local aPos = Vector3.new(-220, 0, 210)
    local aW, aD, aH = 50, 32, 42 -- 3 floors

    -- Floor slabs
    for f = 0, 3 do
        local fl = Instance.new("Part"); fl.Size = Vector3.new(aW, 0.8, aD); fl.Position = aPos + Vector3.new(0, f * 14 + 0.4, 0)
        fl.Anchored = true; fl.Material = Enum.Material.Concrete; fl.Color = Color3.fromRGB(215, 210, 200); fl.Parent = apt
    end

    -- Back, Left, Right
    local wallCol = Color3.fromRGB(210, 195, 175)
    local abw = Instance.new("Part"); abw.Size = Vector3.new(aW, aH, 1.2); abw.Position = aPos + Vector3.new(0, aH/2+0.4, aD/2)
    abw.Anchored = true; abw.Material = Enum.Material.Brick; abw.Color = wallCol; abw.Parent = apt

    local alw = Instance.new("Part"); alw.Size = Vector3.new(1.2, aH, aD); alw.Position = aPos + Vector3.new(-aW/2, aH/2+0.4, 0)
    alw.Anchored = true; alw.Material = Enum.Material.Brick; alw.Color = wallCol; alw.Parent = apt

    local arw = alw:Clone(); arw.Position = aPos + Vector3.new(aW/2, aH/2+0.4, 0); arw.Parent = apt

    -- Front Entrance split
    local doorW = 8
    local sW = (aW - doorW)/2
    local afwL = Instance.new("Part"); afwL.Size = Vector3.new(sW, aH, 1.2); afwL.Position = aPos + Vector3.new(-(doorW/2 + sW/2), aH/2+0.4, -aD/2)
    afwL.Anchored = true; afwL.Material = Enum.Material.Brick; afwL.Color = wallCol; afwL.Parent = apt

    local afwR = afwL:Clone(); afwR.Position = aPos + Vector3.new((doorW/2 + sW/2), aH/2+0.4, -aD/2); afwR.Parent = apt

    local afwT = Instance.new("Part"); afwT.Size = Vector3.new(doorW, aH - 8, 1.2); afwT.Position = aPos + Vector3.new(0, 8 + (aH-8)/2 + 0.4, -aD/2)
    afwT.Anchored = true; afwT.Material = Enum.Material.Brick; afwT.Color = wallCol; afwT.Parent = apt

    -- Windows
    for f = 0, 2 do
        for wx = -18, 18, 9 do
            if math.abs(wx) > 5 or f > 0 then
                local win = Instance.new("Part"); win.Size = Vector3.new(4, 5, 0.2)
                win.Position = aPos + Vector3.new(wx, f * 14 + 5.5, -aD/2 - 0.1)
                win.Anchored = true; win.Material = Enum.Material.Glass; win.Color = Color3.fromRGB(160, 200, 230); win.Transparency = 0.3; win.Parent = apt
            end
        end
    end

    -- ========================================================
    -- 2. ПОДВЕСНОЙ МОСТ (SE Block: 210, 210)
    -- ========================================================
    local bridge = city:FindFirstChild("Bridge") or Instance.new("Folder")
    bridge.Name = "Bridge"; bridge.Parent = city

    local deck = Instance.new("Part"); deck.Name = "BridgeDeck"
    deck.Size = Vector3.new(24, 1.5, 220); deck.Position = Vector3.new(310, 2, 260)
    deck.Anchored = true; deck.Material = Enum.Material.Concrete; deck.Color = Color3.fromRGB(160, 158, 152); deck.Parent = bridge

    local bRoad = Instance.new("Part"); bRoad.Name = "BridgeAsphalt"
    bRoad.Size = Vector3.new(18, 0.3, 220); bRoad.Position = Vector3.new(310, 2.9, 260)
    bRoad.Anchored = true; bRoad.Material = Enum.Material.Asphalt; bRoad.Color = Color3.fromRGB(48, 48, 52); bRoad.Parent = bridge

    -- Bridge Cable Towers
    for _, pz in ipairs({200, 300}) do
        for _, side in ipairs({-1, 1}) do
            local tow = Instance.new("Part"); tow.Size = Vector3.new(3, 48, 3)
            tow.Position = Vector3.new(310 + side * 11, 25, pz)
            tow.Anchored = true; tow.Material = Enum.Material.Metal; tow.Color = Color3.fromRGB(180, 45, 35); tow.Parent = bridge
        end
        local beam = Instance.new("Part"); beam.Size = Vector3.new(25, 2.5, 2.5); beam.Position = Vector3.new(310, 48, pz)
        beam.Anchored = true; beam.Material = Enum.Material.Metal; beam.Color = Color3.fromRGB(180, 45, 35); beam.Parent = bridge
    end

    CHS:SetWaypoint("After Bedroom Warehouses Bridge")
    return bed
end
