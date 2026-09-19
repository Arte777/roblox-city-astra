-- Complete nine-zone megacity expansion for the 2400x2400 master plan.
return function(city)
    local CHS = game:GetService("ChangeHistoryService")
    CHS:SetWaypoint("Before Mega City Expansion")

    local root = Instance.new("Folder")
    root.Name = "MegaCityExpansion"
    root.Parent = city

    local C = {
        concrete = Color3.fromRGB(155, 155, 152), dark = Color3.fromRGB(42, 45, 52),
        glass = Color3.fromRGB(120, 188, 225), white = Color3.fromRGB(235, 235, 238),
        brick = Color3.fromRGB(156, 80, 62), green = Color3.fromRGB(63, 137, 58),
        wood = Color3.fromRGB(116, 73, 43), yellow = Color3.fromRGB(245, 198, 42),
    }

    local function part(parent, name, size, pos, material, color, transparency)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.Position = pos
        p.Anchored = true
        p.Material = material or Enum.Material.SmoothPlastic
        p.Color = color or C.white
        p.Transparency = transparency or 0
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = parent
        return p
    end

    local function light(parent, pos, range)
        local lamp = part(parent, "CeilingLight", Vector3.new(4, 0.3, 2), pos, Enum.Material.Neon, Color3.fromRGB(255, 244, 218))
        local source = Instance.new("PointLight")
        source.Brightness = 1.55
        source.Range = range or 24
        source.Color = Color3.fromRGB(255, 241, 214)
        source.Parent = lamp
        return lamp
    end

    local function sign(parent, text, pos, size, color)
        local board = part(parent, "Sign_" .. text, size or Vector3.new(24, 4, 0.5), pos, Enum.Material.SmoothPlastic, C.dark)
        local gui = Instance.new("SurfaceGui")
        gui.Face = Enum.NormalId.Front
        gui.CanvasSize = Vector2.new(600, 100)
        gui.Parent = board
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = color or C.white
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = gui
        return board
    end

    local function furniture(parent, center, theme)
        if theme == "office" then
            for x = -12, 12, 12 do
                local desk = part(parent, "OfficeDesk", Vector3.new(8, 3.2, 3), center + Vector3.new(x, 1.6, 5), Enum.Material.WoodPlanks, C.wood)
                local screen = part(parent, "Monitor", Vector3.new(3, 2, 0.3), desk.Position + Vector3.new(0, 2.2, 0), Enum.Material.Neon, Color3.fromRGB(60, 180, 255))
                screen.CanCollide = false
            end
        elseif theme == "retail" then
            for z = -8, 8, 8 do
                part(parent, "Shelf", Vector3.new(20, 6, 2.5), center + Vector3.new(-4, 3, z), Enum.Material.Metal, Color3.fromRGB(180, 184, 190))
            end
            part(parent, "Checkout", Vector3.new(12, 3.5, 3), center + Vector3.new(10, 1.75, -10), Enum.Material.WoodPlanks, C.wood)
        elseif theme == "home" then
            part(parent, "Sofa", Vector3.new(8, 2.2, 3.2), center + Vector3.new(-7, 1.2, 5), Enum.Material.Fabric, Color3.fromRGB(74, 102, 145))
            part(parent, "CoffeeTable", Vector3.new(5, 1.6, 3), center + Vector3.new(0, 0.8, 5), Enum.Material.WoodPlanks, C.wood)
            part(parent, "Bed", Vector3.new(7, 2, 10), center + Vector3.new(8, 1, 5), Enum.Material.Fabric, Color3.fromRGB(225, 225, 232))
            part(parent, "Kitchen", Vector3.new(14, 3.6, 3), center + Vector3.new(0, 1.8, -8), Enum.Material.SmoothPlastic, C.white)
        elseif theme == "cafe" then
            part(parent, "Counter", Vector3.new(16, 3.7, 3.5), center + Vector3.new(0, 1.85, 7), Enum.Material.WoodPlanks, C.wood)
            for x = -9, 9, 9 do
                part(parent, "Table", Vector3.new(4, 2.8, 4), center + Vector3.new(x, 1.4, -4), Enum.Material.WoodPlanks, C.wood)
                part(parent, "Chair", Vector3.new(2, 2, 2), center + Vector3.new(x, 1, -8), Enum.Material.Wood, C.wood)
            end
        end
    end

    local function hollowBuilding(parent, name, center, width, depth, height, material, color, label, theme)
        local model = Instance.new("Model")
        model.Name = name
        model.Parent = parent
        part(model, "Floor", Vector3.new(width, 1, depth), center + Vector3.new(0, 0.5, 0), theme == "home" and Enum.Material.WoodPlanks or Enum.Material.Concrete, C.white)
        part(model, "Roof", Vector3.new(width + 1, 1.2, depth + 1), center + Vector3.new(0, height + 0.6, 0), Enum.Material.Metal, C.dark)
        part(model, "BackWall", Vector3.new(width, height, 1.4), center + Vector3.new(0, height/2 + 0.5, depth/2), material, color)
        part(model, "LeftWall", Vector3.new(1.4, height, depth), center + Vector3.new(-width/2, height/2 + 0.5, 0), material, color)
        part(model, "RightWall", Vector3.new(1.4, height, depth), center + Vector3.new(width/2, height/2 + 0.5, 0), material, color)
        local doorW, doorH = 8, 9
        local sideW = (width - doorW) / 2
        part(model, "FrontWallLeft", Vector3.new(sideW, height, 1.4), center + Vector3.new(-(doorW/2 + sideW/2), height/2 + 0.5, -depth/2), material, color)
        part(model, "FrontWallRight", Vector3.new(sideW, height, 1.4), center + Vector3.new(doorW/2 + sideW/2, height/2 + 0.5, -depth/2), material, color)
        part(model, "DoorArch", Vector3.new(doorW, height-doorH, 1.4), center + Vector3.new(0, doorH + (height-doorH)/2 + 0.5, -depth/2), material, color)
        sign(model, label, center + Vector3.new(0, height - 3, -depth/2 - 0.9), Vector3.new(math.min(width-8, 32), 4, 0.45), C.yellow)
        for x = -width/3, width/3, width/3 do
            light(model, center + Vector3.new(x, height - 0.2, 0), 26)
        end
        furniture(model, center, theme)
        return model
    end

    local function tree(parent, pos, scale)
        scale = scale or 1
        local trunk = part(parent, "TreeTrunk", Vector3.new(1.6*scale, 7*scale, 1.6*scale), pos + Vector3.new(0, 3.5*scale, 0), Enum.Material.Wood, Color3.fromRGB(91, 58, 34))
        trunk.Shape = Enum.PartType.Cylinder
        part(parent, "TreeCrown", Vector3.new(9*scale, 9*scale, 9*scale), pos + Vector3.new(0, 10*scale, 0), Enum.Material.Grass, C.green).Shape = Enum.PartType.Ball
    end

    -- DOWNTOWN (north center): six towers, bank, police/city hall.
    local downtown = Instance.new("Folder"); downtown.Name = "DowntownComplete"; downtown.Parent = root
    for i, config in ipairs({{-190,-850,120},{-65,-820,180},{65,-820,220},{190,-850,145},{-125,-680,95},{125,-680,110}}) do
        local x, z, h = config[1], config[2], config[3]
        local tower = Instance.new("Model"); tower.Name = "Skyscraper"..i; tower.Parent = downtown
        part(tower, "LobbyFloor", Vector3.new(72, 1, 64), Vector3.new(x, 0.5, z), Enum.Material.Marble, Color3.fromRGB(45,47,54))
        for y = 16, h, 16 do
            part(tower, "FloorSlab", Vector3.new(70, 0.8, 62), Vector3.new(x, y, z), Enum.Material.Concrete, C.concrete)
        end
        part(tower, "BackGlass", Vector3.new(72, h, 0.6), Vector3.new(x, h/2, z+32), Enum.Material.Glass, C.glass, 0.35)
        part(tower, "LeftGlass", Vector3.new(0.6, h, 64), Vector3.new(x-36, h/2, z), Enum.Material.Glass, C.glass, 0.35)
        part(tower, "RightGlass", Vector3.new(0.6, h, 64), Vector3.new(x+36, h/2, z), Enum.Material.Glass, C.glass, 0.35)
        part(tower, "FrontLeft", Vector3.new(30, h, 0.6), Vector3.new(x-21, h/2, z-32), Enum.Material.Glass, C.glass, 0.35)
        part(tower, "FrontRight", Vector3.new(30, h, 0.6), Vector3.new(x+21, h/2, z-32), Enum.Material.Glass, C.glass, 0.35)
        part(tower, "FrontArch", Vector3.new(12, h-10, 0.6), Vector3.new(x, 10+(h-10)/2, z-32), Enum.Material.Glass, C.glass, 0.35)
        part(tower, "Helipad", Vector3.new(42, 1, 42), Vector3.new(x, h+1, z), Enum.Material.Metal, C.dark)
        sign(tower, i == 3 and "DREAM BIGGER" or "METROPOLIS CORP", Vector3.new(x, math.min(h-18, 72), z-32.6), Vector3.new(38, 12, 0.5), C.white)
        furniture(tower, Vector3.new(x, 0, z), "office")
        light(tower, Vector3.new(x, 15.3, z), 28)
    end
    local bank = hollowBuilding(downtown, "MetropolisBank", Vector3.new(-210,0,-570), 90, 64, 18, Enum.Material.Marble, C.white, "ГОРОДСКОЙ БАНК", "office")
    part(bank, "VaultDoor", Vector3.new(2,12,12), Vector3.new(-210,7,-545), Enum.Material.DiamondPlate, Color3.fromRGB(145,150,160)).Shape = Enum.PartType.Cylinder
    for x=-235,-185,10 do part(bank,"Gold",Vector3.new(6,1.2,3),Vector3.new(x,1.3,-544),Enum.Material.Metal,Color3.fromRGB(255,210,35)) end
    hollowBuilding(downtown, "CityHallPolice", Vector3.new(210,0,-570), 100, 68, 20, Enum.Material.Brick, C.brick, "МЭРИЯ • ПОЛИЦИЯ", "office")

    -- COMMERCIAL (east center): supermarket, fuel plaza, cafe and burger restaurant.
    local commercial = Instance.new("Folder"); commercial.Name = "CommercialComplete"; commercial.Parent = root
    hollowBuilding(commercial, "Hypermarket", Vector3.new(760,0,-80), 160, 100, 20, Enum.Material.Concrete, Color3.fromRGB(210,212,218), "ГИПЕРМАРКЕТ", "retail")
    hollowBuilding(commercial, "CityCafe", Vector3.new(690,0,120), 68, 52, 16, Enum.Material.Brick, C.brick, "ГОРОДСКОЕ КАФЕ", "cafe")
    hollowBuilding(commercial, "BurgerHouse", Vector3.new(810,0,120), 68, 52, 16, Enum.Material.Brick, Color3.fromRGB(190,85,50), "БУРГЕРНАЯ", "cafe")
    local fuel = Instance.new("Model"); fuel.Name="FuelPlaza"; fuel.Parent=commercial
    part(fuel,"Forecourt",Vector3.new(180,1,110),Vector3.new(980,0.5,0),Enum.Material.Concrete,C.concrete)
    part(fuel,"Canopy",Vector3.new(130,3,52),Vector3.new(980,18,0),Enum.Material.SmoothPlastic,C.white)
    for x=930,1030,20 do
        local pump=part(fuel,"FuelPump",Vector3.new(3,7,3),Vector3.new(x,3.5,0),Enum.Material.Metal,Color3.fromRGB(220,50,45))
        part(fuel,"Display",Vector3.new(2,1.5,0.25),pump.Position+Vector3.new(0,1,1.65),Enum.Material.Neon,Color3.fromRGB(85,235,110))
    end
    hollowBuilding(fuel,"FuelMarket",Vector3.new(980,0,70),74,40,14,Enum.Material.Brick,C.brick,"АЗС 24/7", "retail")

    -- RESIDENTIAL (northwest): eight complete cottages with yards.
    local residential = Instance.new("Folder"); residential.Name="ResidentialComplete"; residential.Parent=root
    local houseIndex=0
    for row=0,1 do
        for col=0,3 do
            houseIndex += 1
            local x=-1060+col*170
            local z=-1020+row*220
            local home=hollowBuilding(residential,"FamilyHouse"..houseIndex,Vector3.new(x,0,z),76,58,16,Enum.Material.WoodPlanks,Color3.fromRGB(185+row*20,165+col*8,135),"ДОМ "..houseIndex,"home")
            part(home,"Driveway",Vector3.new(20,0.4,70),Vector3.new(x+24,0.2,z-52),Enum.Material.Concrete,C.concrete)
            for tx=-30,30,60 do tree(home,Vector3.new(x+tx,0,z+42),0.75) end
        end
    end

    -- CENTRAL PARK: lake, pier, fountain, paths, forty trees and furniture.
    local park=Instance.new("Folder"); park.Name="CentralParkComplete"; park.Parent=root
    local lake=part(park,"NaturalLake",Vector3.new(260,2,190),Vector3.new(80,-0.5,50),Enum.Material.Glass,Color3.fromRGB(35,118,185),0.35); lake.CanCollide=false
    part(park,"WoodenPier",Vector3.new(18,1,90),Vector3.new(-25,1,50),Enum.Material.WoodPlanks,C.wood)
    local basin=part(park,"FountainBasin",Vector3.new(4,42,42),Vector3.new(-130,2,0),Enum.Material.Marble,C.white); basin.Shape=Enum.PartType.Cylinder; basin.CFrame=CFrame.new(-130,2,0)*CFrame.Angles(0,0,math.rad(90))
    for y=4,16,4 do part(park,"WaterJet",Vector3.new(2,4,2),Vector3.new(-130,y,0),Enum.Material.Neon,Color3.fromRGB(125,225,255)) end
    part(park,"PathEW",Vector3.new(700,0.35,12),Vector3.new(0,0.18,-150),Enum.Material.Cobblestone,C.concrete)
    part(park,"PathNS",Vector3.new(12,0.35,700),Vector3.new(-200,0.18,0),Enum.Material.Cobblestone,C.concrete)
    for i=1,40 do
        local angle=(i/40)*math.pi*2
        local radius=230+(i%4)*28
        tree(park,Vector3.new(math.cos(angle)*radius,0,math.sin(angle)*radius),0.8+(i%3)*0.12)
    end
    for z=-240,240,80 do
        part(park,"Bench",Vector3.new(7,2,2),Vector3.new(-180,1,z),Enum.Material.WoodPlanks,C.wood)
        part(park,"ParkLamp",Vector3.new(0.6,10,0.6),Vector3.new(-215,5,z),Enum.Material.Metal,C.dark)
    end

    -- PORT: three cranes, container terminal, cargo vessel and lighthouse.
    local port=Instance.new("Folder"); port.Name="PortComplete"; port.Parent=root
    part(port,"Quay",Vector3.new(650,3,420),Vector3.new(780,0,-850),Enum.Material.Concrete,C.concrete)
    for i=0,2 do
        local crane=Instance.new("Model"); crane.Name="GantryCrane"..(i+1); crane.Parent=port
        local x=620+i*180
        for dx=-35,35,70 do part(crane,"Leg",Vector3.new(7,70,7),Vector3.new(x+dx,35,-1030),Enum.Material.Metal,Color3.fromRGB(232,155,30)) end
        part(crane,"Beam",Vector3.new(110,7,7),Vector3.new(x,70,-1030),Enum.Material.Metal,Color3.fromRGB(232,155,30))
        part(crane,"Boom",Vector3.new(7,7,150),Vector3.new(x,70,-1095),Enum.Material.Metal,Color3.fromRGB(232,155,30))
    end
    local containerColors={Color3.fromRGB(190,50,45),Color3.fromRGB(35,90,175),Color3.fromRGB(45,140,65),Color3.fromRGB(220,145,30)}
    for i=1,48 do
        local col=(i-1)%8; local row=math.floor((i-1)/8)%3; local level=math.floor((i-1)/24)
        part(port,"Container",Vector3.new(34,8,9),Vector3.new(560+col*42,5+level*8.5,-760+row*14),Enum.Material.Metal,containerColors[(i%4)+1])
    end
    local ship=Instance.new("Model"); ship.Name="CargoShip"; ship.Parent=port
    part(ship,"Hull",Vector3.new(260,18,70),Vector3.new(850,-17,-1140),Enum.Material.Metal,Color3.fromRGB(45,55,70))
    part(ship,"Deck",Vector3.new(230,3,64),Vector3.new(850,-6,-1140),Enum.Material.WoodPlanks,C.wood)
    part(ship,"Bridge",Vector3.new(48,32,48),Vector3.new(935,10,-1140),Enum.Material.Metal,C.white)
    local lighthouse=Instance.new("Model"); lighthouse.Name="Lighthouse"; lighthouse.Parent=port
    local tower=part(lighthouse,"Tower",Vector3.new(55,16,16),Vector3.new(1100,27,-1050),Enum.Material.Concrete,C.white); tower.Shape=Enum.PartType.Cylinder; tower.CFrame=CFrame.new(1100,27,-1050)*CFrame.Angles(0,0,math.rad(90))
    local beacon=part(lighthouse,"Beacon",Vector3.new(12,8,12),Vector3.new(1100,58,-1050),Enum.Material.Neon,Color3.fromRGB(255,245,180),0.15)
    local spot=Instance.new("PointLight"); spot.Range=90; spot.Brightness=4; spot.Parent=beacon

    -- INDUSTRIAL: factories, chimneys, pipe racks, substation and secure perimeter.
    local industrial=Instance.new("Folder"); industrial.Name="IndustrialComplete"; industrial.Parent=root
    for i=0,2 do
        hollowBuilding(industrial,"FactoryHall"..(i+1),Vector3.new(-1050+i*210,0,0),170,120,28,Enum.Material.Metal,Color3.fromRGB(112,120,132),"ЦЕХ "..(i+1),"office")
    end
    for i=0,3 do
        local chimney=part(industrial,"Smokestack",Vector3.new(75,10,10),Vector3.new(-1080+i*160,38,150),Enum.Material.Metal,i%2==0 and C.white or Color3.fromRGB(190,45,40)); chimney.Shape=Enum.PartType.Cylinder; chimney.CFrame=CFrame.new(-1080+i*160,38,150)*CFrame.Angles(0,0,math.rad(90))
    end
    for z=-150,200,70 do part(industrial,"PipeRack",Vector3.new(600,3,3),Vector3.new(-800,14,z),Enum.Material.Metal,Color3.fromRGB(70,150,175)) end
    for x=-1160,-440,40 do part(industrial,"FencePost",Vector3.new(0.6,8,0.6),Vector3.new(x,4,-210),Enum.Material.Metal,C.dark) end
    part(industrial,"Substation",Vector3.new(90,4,70),Vector3.new(-520,2,170),Enum.Material.DiamondPlate,C.concrete)

    -- BEDROOM DISTRICT: four apartment blocks and playground.
    local bedroom=Instance.new("Folder"); bedroom.Name="BedroomDistrictComplete"; bedroom.Parent=root
    for i,pos in ipairs({Vector3.new(-1050,0,650),Vector3.new(-780,0,650),Vector3.new(-1050,0,920),Vector3.new(-780,0,920)}) do
        local block=hollowBuilding(bedroom,"ApartmentBlock"..i,pos,170,100,64,Enum.Material.Brick,Color3.fromRGB(205,190,170),"ЖК АСТРА "..i,"home")
        for floor=1,4 do
            for x=-65,65,26 do part(block,"Window",Vector3.new(12,7,0.3),pos+Vector3.new(x,floor*14-7,-50.8),Enum.Material.Glass,C.glass,0.3) end
            light(block,pos+Vector3.new(0,floor*14-1,0),24)
        end
    end
    local playground=Instance.new("Model"); playground.Name="Playground"; playground.Parent=bedroom
    part(playground,"Sandbox",Vector3.new(28,1,28),Vector3.new(-650,0.5,820),Enum.Material.Sand,Color3.fromRGB(225,202,150))
    local slide=part(playground,"Slide",Vector3.new(6,1,24),Vector3.new(-670,7,820),Enum.Material.Metal,Color3.fromRGB(235,65,45)); slide.CFrame=CFrame.new(-670,7,820)*CFrame.Angles(math.rad(25),0,0)
    for x=-620,-580,40 do part(playground,"SwingFrame",Vector3.new(3,14,3),Vector3.new(x,7,820),Enum.Material.Metal,Color3.fromRGB(45,105,190)) end

    -- LOGISTICS: three enterable warehouses, racks, pallets and forklift.
    local logistics=Instance.new("Folder"); logistics.Name="LogisticsComplete"; logistics.Parent=root
    for i=0,2 do
        local center=Vector3.new(-220+i*220,0,820)
        local warehouse=hollowBuilding(logistics,"Warehouse"..(i+1),center,180,150,26,Enum.Material.Metal,Color3.fromRGB(130,136,145),"ЛОГИСТИКА "..(i+1),"retail")
        for x=-65,65,26 do
            part(warehouse,"PalletRack",Vector3.new(12,18,90),center+Vector3.new(x,9,15),Enum.Material.Metal,Color3.fromRGB(225,150,30))
            part(warehouse,"Pallet",Vector3.new(10,1.2,8),center+Vector3.new(x,1,45),Enum.Material.WoodPlanks,C.wood)
        end
        part(warehouse,"LoadingRamp",Vector3.new(80,4,22),center+Vector3.new(0,2,86),Enum.Material.DiamondPlate,C.concrete)
        local forklift=Instance.new("Model"); forklift.Name="Forklift"; forklift.Parent=warehouse
        part(forklift,"Body",Vector3.new(9,5,12),center+Vector3.new(50,2.5,-35),Enum.Material.Metal,C.yellow)
        part(forklift,"Fork",Vector3.new(8,0.5,2),center+Vector3.new(50,1,-44),Enum.Material.Metal,C.dark)
    end

    -- INFRASTRUCTURE: illuminated cable-stayed bridge and rock tunnel.
    local infra=Instance.new("Folder"); infra.Name="InfrastructureComplete"; infra.Parent=root
    part(infra,"BridgeDeck",Vector3.new(54,4,850),Vector3.new(800,6,1180),Enum.Material.Concrete,C.concrete)
    part(infra,"BridgeRoad",Vector3.new(42,0.5,850),Vector3.new(800,8.3,1180),Enum.Material.Asphalt,C.dark)
    for z=900,1450,275 do
        for side=-1,1,2 do part(infra,"Pylon",Vector3.new(6,110,6),Vector3.new(800+side*25,61,z),Enum.Material.Metal,Color3.fromRGB(185,48,40)) end
        part(infra,"PylonBeam",Vector3.new(56,5,5),Vector3.new(800,112,z),Enum.Material.Metal,Color3.fromRGB(185,48,40))
        for dz=-240,240,40 do
            local cable=part(infra,"StayCable",Vector3.new(0.5,90,0.5),Vector3.new(800,60,z+dz/2),Enum.Material.Metal,C.white)
            cable.CFrame=CFrame.lookAt(Vector3.new(800,112,z),Vector3.new(800,9,z+dz))*CFrame.new(0,0,-math.sqrt(103*103+dz*dz)/2)
            cable.Size=Vector3.new(0.5,0.5,math.sqrt(103*103+dz*dz))
        end
    end
    part(infra,"TunnelRock",Vector3.new(150,95,120),Vector3.new(-1120,40,800),Enum.Material.Rock,Color3.fromRGB(105,95,82))
    part(infra,"TunnelRoad",Vector3.new(44,1,150),Vector3.new(-1120,1,800),Enum.Material.Asphalt,C.dark)
    sign(infra,"ТОННЕЛЬ",Vector3.new(-1120,58,739),Vector3.new(38,7,0.6),C.white)

    CHS:SetWaypoint("After Mega City Expansion")
    return root
end
