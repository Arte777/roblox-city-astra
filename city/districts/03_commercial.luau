-- Commercial: Заправка 24/7 (навес, колонки, маркет) + Супермаркет + Уютная Кофейня
return function(city)
    local CHS = game:GetService("ChangeHistoryService")
    CHS:SetWaypoint("Before Commercial")

    local dist = city:FindFirstChild("Commercial") or Instance.new("Folder")
    dist.Name = "Commercial"
    dist.Parent = city

    -- ========================================================
    -- 1. ЗАПРАВКА 24/7 С НАВЕСОМ И МАРКЕТОМ
    -- ========================================================
    local gas = Instance.new("Model")
    gas.Name = "GasStation"
    gas.Parent = dist
    local gPos = Vector3.new(190, 0, -30)

    -- Concrete ground pad
    local pad = Instance.new("Part"); pad.Size = Vector3.new(64, 0.4, 54); pad.Position = gPos + Vector3.new(0, 0.2, 0)
    pad.Anchored = true; pad.Material = Enum.Material.Concrete; pad.Color = Color3.fromRGB(165, 163, 158); pad.Parent = gas

    -- Canopy (Навес)
    local canopy = Instance.new("Part"); canopy.Size = Vector3.new(46, 2, 28); canopy.Position = gPos + Vector3.new(0, 15, -10)
    canopy.Anchored = true; canopy.Material = Enum.Material.SmoothPlastic; canopy.Color = Color3.fromRGB(240, 240, 245); canopy.Parent = gas

    local cEdge = Instance.new("Part"); cEdge.Size = Vector3.new(47, 1.2, 29); cEdge.Position = gPos + Vector3.new(0, 15, -10)
    cEdge.Anchored = true; cEdge.Material = Enum.Material.SmoothPlastic; cEdge.Color = Color3.fromRGB(215, 45, 40); cEdge.Parent = gas

    -- 4 Pillars
    for _, px in ipairs({-16, 16}) do
        for _, pz in ipairs({-18, -2}) do
            local pil = Instance.new("Part"); pil.Size = Vector3.new(1.8, 14, 1.8); pil.Position = gPos + Vector3.new(px, 7.2, pz)
            pil.Anchored = true; pil.Material = Enum.Material.Metal; pil.Color = Color3.fromRGB(220, 222, 228); pil.Parent = gas
        end
    end

    -- 3 Gas Pumps
    for _, gx in ipairs({-14, 0, 14}) do
        local pump = Instance.new("Part"); pump.Size = Vector3.new(2.4, 5.5, 1.4); pump.Position = gPos + Vector3.new(gx, 3, -10)
        pump.Anchored = true; pump.Material = Enum.Material.SmoothPlastic; pump.Color = Color3.fromRGB(215, 45, 40); pump.Parent = gas

        local screen = Instance.new("Part"); screen.Size = Vector3.new(1.4, 1, 0.2); screen.Position = gPos + Vector3.new(gx, 4.2, -9.2)
        screen.Anchored = true; screen.Material = Enum.Material.Neon; screen.Color = Color3.fromRGB(80, 220, 100); screen.Parent = gas
    end

    -- Mini-Mart Building (behind pumps)
    local mW, mD, mH = 32, 22, 12
    local mZ = 16

    local mFloor = Instance.new("Part"); mFloor.Size = Vector3.new(mW, 0.6, mD); mFloor.Position = gPos + Vector3.new(0, 0.5, mZ)
    mFloor.Anchored = true; mFloor.Material = Enum.Material.Concrete; mFloor.Color = Color3.fromRGB(230, 230, 235); mFloor.Parent = gas

    local mCeil = Instance.new("Part"); mCeil.Size = Vector3.new(mW+1, 0.8, mD+1); mCeil.Position = gPos + Vector3.new(0, mH+0.6, mZ)
    mCeil.Anchored = true; mCeil.Material = Enum.Material.Concrete; mCeil.Color = Color3.fromRGB(120, 122, 128); mCeil.Parent = gas

    -- Back, Left, Right Walls
    local mbw = Instance.new("Part"); mbw.Size = Vector3.new(mW, mH, 1.2); mbw.Position = gPos + Vector3.new(0, mH/2+0.6, mZ+mD/2)
    mbw.Anchored = true; mbw.Material = Enum.Material.Brick; mbw.Color = Color3.fromRGB(145, 75, 60); mbw.Parent = gas

    local mlw = Instance.new("Part"); mlw.Size = Vector3.new(1.2, mH, mD); mlw.Position = gPos + Vector3.new(-mW/2, mH/2+0.6, mZ)
    mlw.Anchored = true; mlw.Material = Enum.Material.Brick; mlw.Color = Color3.fromRGB(145, 75, 60); mlw.Parent = gas

    local mrw = mlw:Clone(); mrw.Position = gPos + Vector3.new(mW/2, mH/2+0.6, mZ); mrw.Parent = gas

    -- Front Glass Wall with Entrance
    local mgL = Instance.new("Part"); mgL.Size = Vector3.new(12, mH, 0.4); mgL.Position = gPos + Vector3.new(-10, mH/2+0.6, mZ-mD/2)
    mgL.Anchored = true; mgL.Material = Enum.Material.Glass; mgL.Color = Color3.fromRGB(190, 225, 245); mgL.Transparency = 0.4; mgL.Parent = gas

    local mgR = mgL:Clone(); mgR.Position = gPos + Vector3.new(10, mH/2+0.6, mZ-mD/2); mgR.Parent = gas

    local mgTop = Instance.new("Part"); mgTop.Size = Vector3.new(8, mH - 8, 0.4); mgTop.Position = gPos + Vector3.new(0, 8 + (mH-8)/2 + 0.6, mZ-mD/2)
    mgTop.Anchored = true; mgTop.Material = Enum.Material.SmoothPlastic; mgTop.Color = Color3.fromRGB(215, 45, 40); mgTop.Parent = gas

    -- 24/7 Signboard
    local mSign = Instance.new("Part"); mSign.Size = Vector3.new(18, 3, 0.4); mSign.Position = gPos + Vector3.new(0, mH + 2, mZ-mD/2-0.3)
    mSign.Anchored = true; mSign.Material = Enum.Material.SmoothPlastic; mSign.Color = Color3.fromRGB(30, 32, 40); mSign.Parent = gas

    local msg = Instance.new("SurfaceGui"); msg.Face = Enum.NormalId.Front; msg.CanvasSize = Vector2.new(360, 60); msg.Parent = mSign
    local mtl = Instance.new("TextLabel"); mtl.Size = UDim2.new(1,0,1,0); mtl.BackgroundTransparency = 1
    mtl.Text = "24/7 МАРКЕТ"; mtl.TextColor3 = Color3.fromRGB(255, 220, 50); mtl.TextSize = 34; mtl.Font = Enum.Font.GothamBold; mtl.Parent = msg

    -- Mart Shelves and Cashier
    local reg = Instance.new("Part"); reg.Size = Vector3.new(8, 3.5, 3); reg.Position = gPos + Vector3.new(8, 2.3, mZ - 4)
    reg.Anchored = true; reg.Material = Enum.Material.WoodPlanks; reg.Color = Color3.fromRGB(110, 65, 40); reg.Parent = gas

    for sx = -8, -2, 6 do
        local sh = Instance.new("Part"); sh.Size = Vector3.new(3, 7, 12); sh.Position = gPos + Vector3.new(sx, 4, mZ + 3)
        sh.Anchored = true; sh.Material = Enum.Material.Metal; sh.Color = Color3.fromRGB(180, 182, 188); sh.Parent = gas
    end

    CHS:SetWaypoint("After Commercial")
    return dist
end
