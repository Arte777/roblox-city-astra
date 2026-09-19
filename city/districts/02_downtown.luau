-- Downtown: Городской Банк (с хранилищем, золотом, кассами) + Офисный Небоскрёб (лобби, вывеска "DREAM BIGGER")
return function(city)
    local CHS = game:GetService("ChangeHistoryService")
    CHS:SetWaypoint("Before Downtown")

    local dist = city:FindFirstChild("Downtown") or Instance.new("Folder")
    dist.Name = "Downtown"
    dist.Parent = city

    -- ========================================================
    -- 1. ГОРОДСКОЙ БАНК (Hollow, кассы, пуленепробиваемое стекло, сейф)
    -- ========================================================
    local bank = Instance.new("Model")
    bank.Name = "CityBank"
    bank.Parent = dist
    local bPos = Vector3.new(35, 0, -200)

    -- Floor
    local bFloor = Instance.new("Part")
    bFloor.Name = "Floor"; bFloor.Size = Vector3.new(50, 1, 40)
    bFloor.Position = bPos + Vector3.new(0, 0.5, 0); bFloor.Anchored = true
    bFloor.Material = Enum.Material.Marble; bFloor.Color = Color3.fromRGB(240, 240, 245)
    bFloor.Parent = bank

    -- Ceiling
    local bCeil = Instance.new("Part")
    bCeil.Name = "Ceiling"; bCeil.Size = Vector3.new(50, 1.2, 40)
    bCeil.Position = bPos + Vector3.new(0, 16.5, 0); bCeil.Anchored = true
    bCeil.Material = Enum.Material.SmoothPlastic; bCeil.Color = Color3.fromRGB(220, 222, 228)
    bCeil.Parent = bank

    -- Walls (Brick, Classic)
    local wallMat = Enum.Material.Brick
    local wallCol = Color3.fromRGB(150, 75, 58)

    -- Back, Left, Right (Solid)
    local bw = Instance.new("Part"); bw.Size = Vector3.new(50, 16, 1.4); bw.Position = bPos + Vector3.new(0, 8.5, 19.3)
    bw.Anchored = true; bw.Material = wallMat; bw.Color = wallCol; bw.Parent = bank

    local lw = Instance.new("Part"); lw.Size = Vector3.new(1.4, 16, 40); lw.Position = bPos + Vector3.new(-24.3, 8.5, 0)
    lw.Anchored = true; lw.Material = wallMat; lw.Color = wallCol; lw.Parent = bank

    local rw = lw:Clone(); rw.Position = bPos + Vector3.new(24.3, 8.5, 0); rw.Parent = bank

    -- Front Wall (Split for 10-stud Entrance)
    local fwL = Instance.new("Part"); fwL.Size = Vector3.new(20, 16, 1.4); fwL.Position = bPos + Vector3.new(-15, 8.5, -19.3)
    fwL.Anchored = true; fwL.Material = wallMat; fwL.Color = wallCol; fwL.Parent = bank

    local fwR = fwL:Clone(); fwR.Position = bPos + Vector3.new(15, 8.5, -19.3); fwR.Parent = bank

    local fwTop = Instance.new("Part"); fwTop.Size = Vector3.new(10, 7, 1.4); fwTop.Position = bPos + Vector3.new(0, 13, -19.3)
    fwTop.Anchored = true; fwTop.Material = wallMat; fwTop.Color = wallCol; fwTop.Parent = bank

    -- Bank Signboard
    local bSign = Instance.new("Part"); bSign.Size = Vector3.new(26, 3.5, 0.4); bSign.Position = bPos + Vector3.new(0, 13.5, -20.2)
    bSign.Anchored = true; bSign.Material = Enum.Material.SmoothPlastic; bSign.Color = Color3.fromRGB(24, 28, 36); bSign.Parent = bank

    local sg = Instance.new("SurfaceGui"); sg.Face = Enum.NormalId.Front; sg.CanvasSize = Vector2.new(520, 70); sg.Parent = bSign
    local tl = Instance.new("TextLabel"); tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency = 1
    tl.Text = "★ БАНК РОБЛОКС ★"; tl.TextColor3 = Color3.fromRGB(255, 215, 0); tl.TextSize = 38; tl.Font = Enum.Font.GothamBold; tl.Parent = sg

    -- Interior: Teller counter with glass
    local desk = Instance.new("Part"); desk.Size = Vector3.new(34, 3.8, 3.5); desk.Position = bPos + Vector3.new(0, 2.4, 2)
    desk.Anchored = true; desk.Material = Enum.Material.WoodPlanks; desk.Color = Color3.fromRGB(110, 65, 40); desk.Parent = bank

    local glass = Instance.new("Part"); glass.Size = Vector3.new(34, 5, 0.3); glass.Position = bPos + Vector3.new(0, 6.8, 2)
    glass.Anchored = true; glass.Material = Enum.Material.Glass; glass.Transparency = 0.5; glass.Color = Color3.fromRGB(200, 230, 255); glass.Parent = bank

    -- Interior: Ceiling Lights
    for ix = -15, 15, 15 do
        for iz = -10, 10, 10 do
            local lamp = Instance.new("Part"); lamp.Size = Vector3.new(4, 0.3, 4); lamp.Position = bPos + Vector3.new(ix, 15.8, iz)
            lamp.Anchored = true; lamp.Material = Enum.Material.Neon; lamp.Color = Color3.fromRGB(255, 250, 235); lamp.Parent = bank
            local pl = Instance.new("PointLight"); pl.Brightness = 1.4; pl.Range = 20; pl.Parent = lamp
        end
    end

    -- Interior: Vault with Gold Bars
    local vDoor = Instance.new("Part"); vDoor.Shape = Enum.PartType.Cylinder; vDoor.Size = Vector3.new(1.8, 9, 9)
    vDoor.CFrame = CFrame.new(bPos + Vector3.new(6, 6, 12)) * CFrame.Angles(0, math.rad(-50), math.rad(90))
    vDoor.Anchored = true; vDoor.Material = Enum.Material.DiamondPlate; vDoor.Color = Color3.fromRGB(160, 165, 175); vDoor.Parent = bank

    for gx = -4, 4, 2.5 do
        for gy = 0, 1 do
            local bar = Instance.new("Part"); bar.Size = Vector3.new(2, 0.8, 3.5); bar.Position = bPos + Vector3.new(gx, 1.8 + gy*0.9, 16)
            bar.Anchored = true; bar.Material = Enum.Material.Metal; bar.Color = Color3.fromRGB(255, 215, 0); bar.Reflectance = 0.4; bar.Parent = bank
        end
    end

    -- ========================================================
    -- 2. ОФИСНЫЙ НЕБОСКРЁБ (Glass Curtain Tower)
    -- ========================================================
    local tower = Instance.new("Model")
    tower.Name = "OfficeTower"
    tower.Parent = dist
    local tPos = Vector3.new(-45, 0, -210)
    local tW, tD, tH = 48, 42, 80

    -- Lobby Floor
    local tFloor = Instance.new("Part"); tFloor.Size = Vector3.new(tW, 1, tD); tFloor.Position = tPos + Vector3.new(0, 0.5, 0)
    tFloor.Anchored = true; tFloor.Material = Enum.Material.Marble; tFloor.Color = Color3.fromRGB(40, 42, 48); tFloor.Parent = tower

    -- Floor Slabs (every 16 studs)
    for f = 1, 5 do
        local slab = Instance.new("Part"); slab.Size = Vector3.new(tW - 0.5, 0.8, tD - 0.5); slab.Position = tPos + Vector3.new(0, f * 16, 0)
        slab.Anchored = true; slab.Material = Enum.Material.Concrete; slab.Color = Color3.fromRGB(180, 182, 188); slab.Parent = tower
    end

    -- Glass Facade (Curtain Walls)
    local gCol = Color3.fromRGB(110, 170, 220)
    -- Back, Left, Right
    local bg = Instance.new("Part"); bg.Size = Vector3.new(tW, tH, 0.5); bg.Position = tPos + Vector3.new(0, tH/2, tD/2)
    bg.Anchored = true; bg.Material = Enum.Material.Glass; bg.Color = gCol; bg.Transparency = 0.35; bg.Reflectance = 0.3; bg.Parent = tower

    local lg = Instance.new("Part"); lg.Size = Vector3.new(0.5, tH, tD); lg.Position = tPos + Vector3.new(-tW/2, tH/2, 0)
    lg.Anchored = true; lg.Material = Enum.Material.Glass; lg.Color = gCol; lg.Transparency = 0.35; lg.Reflectance = 0.3; lg.Parent = tower

    local rg = lg:Clone(); rg.Position = tPos + Vector3.new(tW/2, tH/2, 0); rg.Parent = tower

    -- Front Glass Wall split for 12-stud Entrance
    local fgL = Instance.new("Part"); fgL.Size = Vector3.new((tW-12)/2, tH, 0.5); fgL.Position = tPos + Vector3.new(-(12/2 + (tW-12)/4), tH/2, -tD/2)
    fgL.Anchored = true; fgL.Material = Enum.Material.Glass; fgL.Color = gCol; fgL.Transparency = 0.35; fgL.Reflectance = 0.3; fgL.Parent = tower

    local fgR = fgL:Clone(); fgR.Position = tPos + Vector3.new(12/2 + (tW-12)/4, tH/2, -tD/2); fgR.Parent = tower

    local fgTop = Instance.new("Part"); fgTop.Size = Vector3.new(12, tH - 10, 0.5); fgTop.Position = tPos + Vector3.new(0, 10 + (tH-10)/2, -tD/2)
    fgTop.Anchored = true; fgTop.Material = Enum.Material.Glass; fgTop.Color = gCol; fgTop.Transparency = 0.35; fgTop.Parent = tower

    -- Billboard "DREAM BIGGER"
    local board = Instance.new("Part"); board.Size = Vector3.new(28, 14, 0.4); board.Position = tPos + Vector3.new(0, 52, -tD/2 - 0.4)
    board.Anchored = true; board.Material = Enum.Material.SmoothPlastic; board.Color = Color3.fromRGB(20, 24, 32); board.Parent = tower

    local bsg = Instance.new("SurfaceGui"); bsg.Face = Enum.NormalId.Front; bsg.CanvasSize = Vector2.new(560, 280); bsg.Parent = board
    local btl = Instance.new("TextLabel"); btl.Size = UDim2.new(1,0,1,0); btl.BackgroundTransparency = 1
    btl.Text = "DREAM\nBIGGER"; btl.TextColor3 = Color3.fromRGB(255, 255, 255); btl.TextSize = 64; btl.Font = Enum.Font.GothamBlack; btl.Parent = bsg

    -- Ground Floor Reception
    local rec = Instance.new("Part"); rec.Size = Vector3.new(16, 3.8, 4); rec.Position = tPos + Vector3.new(0, 2.4, 4)
    rec.Anchored = true; rec.Material = Enum.Material.Wood; rec.Color = Color3.fromRGB(80, 50, 35); rec.Parent = tower

    CHS:SetWaypoint("After Downtown")
    return dist
end
