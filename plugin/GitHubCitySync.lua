-- GitHub City Sync: Плагин для загрузки и сборки города из GitHub репозитория в Roblox Studio
local HttpService = game:GetService("HttpService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local toolbar = plugin:CreateToolbar("Astra City Sync")
local toggleButton = toolbar:CreateButton("GitHub City Sync", "Синхронизировать город из GitHub репозитория", "rbxassetid://1507949215")

local dockInfo = DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Float,
    false,
    false,
    380,
    440,
    300,
    350
)

local widget = plugin:CreateDockWidgetPluginGui("AstraGitHubCitySyncWidget", dockInfo)
widget.Title = "🌆 Astra City Sync (GitHub)"

-- Base UI layout
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = widget

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = mainFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingBottom = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 26)
title.BackgroundTransparency = 1
title.Text = "🚀 ASTRA GITHUB SYNC"
title.TextColor3 = Color3.fromRGB(80, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Repository input
local repoBox = Instance.new("TextBox")
repoBox.Size = UDim2.new(1, 0, 0, 32)
repoBox.BackgroundColor3 = Color3.fromRGB(38, 42, 50)
repoBox.TextColor3 = Color3.fromRGB(255, 255, 255)
repoBox.Text = "Arte777/roblox-city-astra"
repoBox.PlaceholderText = "owner/repo (напр. Arte777/roblox-city-astra)"
repoBox.Font = Enum.Font.Gotham
repoBox.TextSize = 13
repoBox.BorderSizePixel = 0
repoBox.Parent = mainFrame

-- Branch input
local branchBox = Instance.new("TextBox")
branchBox.Size = UDim2.new(1, 0, 0, 30)
branchBox.BackgroundColor3 = Color3.fromRGB(38, 42, 50)
branchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
branchBox.Text = "main"
branchBox.PlaceholderText = "branch (напр. main)"
branchBox.Font = Enum.Font.Gotham
branchBox.TextSize = 13
branchBox.BorderSizePixel = 0
branchBox.Parent = mainFrame

-- Token input (optional)
local tokenBox = Instance.new("TextBox")
tokenBox.Size = UDim2.new(1, 0, 0, 30)
tokenBox.BackgroundColor3 = Color3.fromRGB(38, 42, 50)
tokenBox.TextColor3 = Color3.fromRGB(200, 200, 200)
tokenBox.Text = ""
tokenBox.PlaceholderText = "GitHub Token (опционально для приватных репо)"
tokenBox.Font = Enum.Font.Gotham
tokenBox.TextSize = 12
tokenBox.BorderSizePixel = 0
tokenBox.Parent = mainFrame

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 22)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Готов к синхронизации"
statusLabel.TextColor3 = Color3.fromRGB(160, 165, 175)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = mainFrame

-- Sync Button
local syncBtn = Instance.new("TextButton")
syncBtn.Size = UDim2.new(1, 0, 0, 42)
syncBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
syncBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
syncBtn.Text = "⚡ СИНХРОНИЗИРОВАТЬ ГОРОД"
syncBtn.Font = Enum.Font.GothamBold
syncBtn.TextSize = 14
syncBtn.BorderSizePixel = 0
syncBtn.Parent = mainFrame

-- Clear Button
local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(1, 0, 0, 32)
clearBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.Text = "🗑️ Очистить CityMap"
clearBtn.Font = Enum.Font.Gotham
clearBtn.TextSize = 13
clearBtn.BorderSizePixel = 0
clearBtn.Parent = mainFrame

-- Log Box
local logBox = Instance.new("TextBox")
logBox.Size = UDim2.new(1, 0, 1, -260)
logBox.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
logBox.TextColor3 = Color3.fromRGB(140, 230, 140)
logBox.Text = "Логи синхронизации...\n"
logBox.ClearTextOnFocus = false
logBox.TextEditable = false
logBox.MultiLine = true
logBox.Font = Enum.Font.Code
logBox.TextSize = 11
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.BorderSizePixel = 0
logBox.Parent = mainFrame

toggleButton.Click:Connect(function()
    widget.Enabled = not widget.Enabled
end)

local function appendLog(msg)
    print("[AstraSync] " .. msg)
    logBox.Text = logBox.Text .. msg .. "\n"
    statusLabel.Text = msg
end

local function fetchGitHub(path)
    local repo = repoBox.Text
    local branch = branchBox.Text
    local token = tokenBox.Text
    local url = string.format("https://raw.githubusercontent.com/%s/%s/%s?t=%d", repo, branch, path, os.time())

    local headers = {}
    if token and #token > 0 then
        headers["Authorization"] = "token " .. token
    end

    local ok, res = pcall(function()
        return HttpService:RequestAsync({
            Url = url,
            Method = "GET",
            Headers = headers
        })
    end)

    if not ok or not res or res.StatusCode ~= 200 then
        error("Ошибка запроса " .. path .. " (HTTP " .. tostring(res and res.StatusCode or "FAIL") .. ")")
    end

    return res.Body
end

local function syncCity()
    syncBtn.Text = "⏳ Загрузка манифеста..."
    syncBtn.Active = false
    appendLog("--- Начало синхронизации ---")

    local ok, err = pcall(function()
        ChangeHistoryService:SetWaypoint("Before Astra City Sync")

        -- 1. Скачиваем манифест
        appendLog("Загрузка city/manifest.json...")
        local manifestJson = fetchGitHub("city/manifest.json")
        local manifest = HttpService:JSONDecode(manifestJson)

        appendLog("Проект: " .. tostring(manifest.project) .. " v" .. tostring(manifest.version))

        -- 2. Готовим папку CityMap
        local cityFolder = workspace:FindFirstChild("CityMap")
        if not cityFolder then
            cityFolder = Instance.new("Folder")
            cityFolder.Name = "CityMap"
            cityFolder.Parent = workspace
        end

        -- 3. Загружаем и выполняем каждый район
        for _, dist in ipairs(manifest.districts) do
            if dist.enabled then
                appendLog("Строим район: " .. dist.name .. " (" .. dist.file .. ")")
                local luauCode = fetchGitHub(dist.file)

                local chunk, compileErr = loadstring(luauCode)
                if not chunk then
                    appendLog("❌ Ошибка компиляции " .. dist.file .. ": " .. tostring(compileErr))
                else
                    local runOk, runErr = pcall(function()
                        local res = chunk()
                        if type(res) == "function" then
                            res(cityFolder)
                        end
                    end)
                    if not runOk then
                        appendLog("❌ Ошибка выполнения " .. dist.file .. ": " .. tostring(runErr))
                    else
                        appendLog("✅ Успешно: " .. dist.name)
                    end
                end
            end
        end

        -- 4. Ставим красивую камеру
        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = CFrame.lookAt(Vector3.new(0, 380, -250), Vector3.new(0, 0, 50))
        end

        Selection:Set({cityFolder})
        ChangeHistoryService:SetWaypoint("After Astra City Sync")
        appendLog("🎉 Город полностью синхронизирован и построен!")
    end)

    if not ok then
        appendLog("❌ СБОЙ СИНХРОНИЗАЦИИ: " .. tostring(err))
    end

    syncBtn.Text = "⚡ СИНХРОНИЗИРОВАТЬ ГОРОД"
    syncBtn.Active = true
end

syncBtn.MouseButton1Click:Connect(syncCity)

clearBtn.MouseButton1Click:Connect(function()
    local city = workspace:FindFirstChild("CityMap")
    if city then
        ChangeHistoryService:SetWaypoint("Before Clear CityMap")
        city:Destroy()
        ChangeHistoryService:SetWaypoint("After Clear CityMap")
        appendLog("🧹 CityMap очищен!")
    else
        appendLog("CityMap не найден в Workspace.")
    end
end)
