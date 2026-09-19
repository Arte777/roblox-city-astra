-- Port & Industrial: Морской причал, портальный кран, контейнеры + Завод с трубами
return function(city)
    local CHS = game:GetService("ChangeHistoryService")
    CHS:SetWaypoint("Before Port and Industrial")

    -- ========================================================
    -- 1. ПОРТ И ДОКИ (NE Block: 210, -210)
    -- ========================================================
    local port = city:FindFirstChild("Port") or Instance.new("Folder")
    port.Name = "Port"; port.Parent = city

    -- Concrete Pier over Ocean
    local pier = Instance.new("Part"); pier.Size = Vector3.new(80, 2, 70); pier.Position = Vector3.new(240, 0, -240)
    pier.Anchored = true; pier.Material = Enum.Material.Concrete; pier.Color = Color3.fromRGB(150, 148, 142); pier.Parent = port

    -- Massive Port Crane
    local crane = Instance.new("Model"); crane.Name = "HarborCrane"; crane.Parent = port
    local cBasePos = Vector3.new(230, 0, -260)

    local crBase = Instance.new("Part"); crBase.Size = Vector3.new(10, 2, 10); crBase.Position = cBasePos + Vector3.new(0, 1, 0)
    crBase.Anchored = true; crBase.Material = Enum.Material.Metal; crBase.Color = Color3.fromRGB(230, 160, 30); crBase.Parent = crane

    local crTower = Instance.new("Part"); crTower.Size = Vector3.new(4, 50, 4); crTower.Position = cBasePos + Vector3.new(0, 26, 0)
    crTower.Anchored = true; crTower.Material = Enum.Material.Metal; crTower.Color = Color3.fromRGB(230, 160, 30); crTower.Parent = crane

    local crBoom = Instance.new("Part"); crBoom.Size = Vector3.new(45, 3, 3); crBoom.Position = cBasePos + Vector3.new(15, 51, 0)
    crBoom.Anchored = true; crBoom.Material = Enum.Material.Metal; crBoom.Color = Color3.fromRGB(230, 160, 30); crBoom.Parent = crane

    -- Shipping Containers (Разноцветные штабеля)
    local contColors = {
        Color3.fromRGB(200, 50, 45),   -- Red
        Color3.fromRGB(40, 95, 185),   -- Blue
        Color3.fromRGB(45, 145, 65),   -- Green
        Color3.fromRGB(225, 150, 30),  -- Orange
        Color3.fromRGB(90, 95, 105),   -- Gray
    }

    for i = 1, 8 do
        local col = contColors[(i % #contColors) + 1]
        local cont = Instance.new("Part"); cont.Name = "Container_"..i
        cont.Size = Vector3.new(14, 6, 6)
        local stackY = (i > 5) and 6.5 or 0
        local offX = ((i - 1) % 4) * 16 - 20
        cont.Position = Vector3.new(220 + offX, 3 + stackY, -210 + (i > 4 and 10 or 0))
        cont.Anchored = true; cont.Material = Enum.Material.Metal; cont.Color = col; cont.Parent = port
    end

    -- ========================================================
    -- 2. ПРОМЗОНА И ЗАВОД (CW Block: -210, 0)
    -- ========================================================
    local ind = city:FindFirstChild("Industrial") or Instance.new("Folder")
    ind.Name = "Industrial"; ind.Parent = city

    local factory = Instance.new("Model"); factory.Name = "Factory"; factory.Parent = ind
    local fPos = Vector3.new(-210, 0, 0)
    local fW, fD, fH = 55, 45, 18

    -- Floor
    local fFloor = Instance.new("Part"); fFloor.Size = Vector3.new(fW, 0.6, fD); fFloor.Position = fPos + Vector3.new(0, 0.3, 0)
    fFloor.Anchored = true; fFloor.Material = Enum.Material.Concrete; fFloor.Color = Color3.fromRGB(130, 128, 122); fFloor.Parent = factory

    -- Walls (Metal)
    local fbw = Instance.new("Part"); fbw.Size = Vector3.new(fW, fH, 1.4); fbw.Position = fPos + Vector3.new(0, fH/2+0.3, fD/2)
    fbw.Anchored = true; fbw.Material = Enum.Material.Metal; fbw.Color = Color3.fromRGB(120, 125, 135); fbw.Parent = factory

    local flw = Instance.new("Part"); flw.Size = Vector3.new(1.4, fH, fD); flw.Position = fPos + Vector3.new(-fW/2, fH/2+0.3, 0)
    flw.Anchored = true; flw.Material = Enum.Material.Metal; flw.Color = Color3.fromRGB(120, 125, 135); flw.Parent = factory

    local frw = flw:Clone(); frw.Position = fPos + Vector3.new(fW/2, fH/2+0.3, 0); frw.Parent = factory

    -- Front Wall with Wide Cargo Doorway (14 studs)
    local cDoorW = 14
    local sW = (fW - cDoorW)/2
    local ffwL = Instance.new("Part"); ffwL.Size = Vector3.new(sW, fH, 1.4); ffwL.Position = fPos + Vector3.new(-(cDoorW/2 + sW/2), fH/2+0.3, -fD/2)
    ffwL.Anchored = true; ffwL.Material = Enum.Material.Metal; ffwL.Color = Color3.fromRGB(120, 125, 135); ffwL.Parent = factory

    local ffwR = ffwL:Clone(); ffwR.Position = fPos + Vector3.new((cDoorW/2 + sW/2), fH/2+0.3, -fD/2); ffwR.Parent = factory

    local ffwT = Instance.new("Part"); ffwT.Size = Vector3.new(cDoorW, fH - 12, 1.4); ffwT.Position = fPos + Vector3.new(0, 12 + (fH-12)/2 + 0.3, -fD/2)
    ffwT.Anchored = true; ffwT.Material = Enum.Material.Metal; ffwT.Color = Color3.fromRGB(120, 125, 135); ffwT.Parent = factory

    -- Smokestacks on Roof
    for _, sx in ipairs({-12, 12}) do
        local stack = Instance.new("Part"); stack.Shape = Enum.PartType.Cylinder
        stack.Size = Vector3.new(22, 3, 3); stack.CFrame = CFrame.new(fPos + Vector3.new(sx, fH + 11, 0)) * CFrame.Angles(0, 0, math.rad(90))
        stack.Anchored = true; stack.Material = Enum.Material.Metal; stack.Color = Color3.fromRGB(80, 85, 95); stack.Parent = factory
    end

    CHS:SetWaypoint("After Port and Industrial")
    return port
end
