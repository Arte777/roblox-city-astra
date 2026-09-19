# 🤖 ASTRA ARCHITECT GUIDE (GPT-6 ASTRA)
> **Полная системная инструкция для GPT-6 Astra по генерации детальных 3D городов в Roblox Studio через связку Notion → GitHub → Roblox Studio Plugin.**

---

## 🌐 1. Архитектура взаимодействия (Pipeline)

```
┌─────────────────┐       Auto-Sync       ┌────────────────────────┐
│  USER в NOTION  │ ────────────────────> │  GITHUB РЕПОЗИТОРИЙ    │
│  (Задачи, план) │                       │  (Код Luau, Манифесты) │
└─────────────────┘                       └────────────────────────┘
        │                                             ▲
        ▼                                             │ Commits / PRs
┌─────────────────┐                                   │
│  GPT-6 ASTRA    │ ──────────────────────────────────┘
│  (Архитектор)   │   Создает скрипты районов, hollow-зданий,
└─────────────────┘   интерьеры, свет и manifest.json
                                                      │
                                                      │ HTTP / Raw API
                                                      ▼
                                          ┌────────────────────────┐
                                          │  ROBLOX STUDIO PLUGIN  │
                                          │  (GitHub City Sync)    │
                                          └────────────────────────┘
                                                      │
                                                      │ ChangeHistoryService
                                                      ▼
                                          ┌────────────────────────┐
                                          │  3D ГОРОД В WORKSPACE  │
                                          │  (1:1 Human Scale)     │
                                          └────────────────────────┘
```

1. **Notion**: Пользователь ставит задачу или описывает район/здание (например: *"Построй пожарную часть в Центре"* или *"Добавь автосалон в торговом районе"*).
2. **GPT-6 Astra**:
   - Читает `city/manifest.json`.
   - Создает или обновляет скрипт здания/района в `city/districts/<district_name>.luau`.
   - При необходимости добавляет готовые ассеты в `city/assets.json`.
   - Обновляет манифест `city/manifest.json` и делает коммит в репозиторий.
3. **Roblox Studio Plugin**:
   - Считывает репозиторий GitHub через HTTP API или Raw URL.
   - Выполняет Luau-скрипты в изолированном контексте `workspace.CityMap`.
   - Автоматически создает детализированную геометрию, интерьеры, мебель, освещение и настраивает камеру.

---

## 📐 2. Золотые правила масштаба и архитектуры (CRITICAL)

### ⚠️ ГЛАВНАЯ ОШИБКА, КОТОРУЮ ЗАПРЕЩЕНО ПОВТОРЯТЬ:
> **НИКОГДА НЕ СОЗДАВАТЬ ЗДАНИЯ В ВИДЕ СПЛОШНЫХ МОНОЛИТНЫХ КУБОВ!**  
> Пользователь сразу забракует постройку, если в неё нельзя войти или если она игрушечного размера.

### 📏 Метрики масштаба персонажа (Human Scale 1:1):
| Объект | Размеры в Studs (Ш × В × Г) | Примечание |
|---|---|---|
| **Персонаж Roblox (R15/R6)** | `4 × 5 × 2` | Базовый ориентир роста человека |
| **Дверной проём (проход)** | `6 × 8 × 2` (минимум `4 × 7`) | Игрок должен свободно проходить без застревания |
| **Высота этажа (чистовая)** | `14 – 18` studs | Просторные реалистичные помещения |
| **Толщина стен** | `1.2 – 1.6` studs | Не делать стены тоньше 0.8 и толще 2.5 studs |
| **Ширина дороги (2 полосы)** | `24 – 28` studs | 12-14 studs на полосу для движения авто |
| **Ширина тротуара** | `8 – 10` studs | Высота бордюра: `0.5 – 0.8` studs |
| **Стол / Кассовая стойка** | `3.2 – 4.0` высота | Под уровень пояса персонажа |
| **Стул / Диван** | Сиденье: высота `1.8 – 2.0`, спинка `3.5 – 4.0` | Удобная посадка персонажа |

---

## 🏛️ 3. Техника "Hollow Architecture" (Полые здания с входами)

Чтобы здание было функциональным и детализированным, стены вокруг дверей строятся из **трёх частей**:
1. `FrontWallLeft` (левая панель от пола до потолка)
2. `FrontWallRight` (правая панель от пола до потолка)
3. `FrontWallTop` (арка/перемычка над дверным проёмом, оставляющая проход снизу)

```lua
-- ПРИМЕР: Создание полой стены фасада со сквозным входом
local buildingWidth = 50
local buildingHeight = 16
local wallThickness = 1.4
local doorWidth = 8
local doorHeight = 9

local sidePanelWidth = (buildingWidth - doorWidth) / 2

-- Левая секция
local wallL = Instance.new("Part")
wallL.Name = "FrontWall_Left"
wallL.Size = Vector3.new(sidePanelWidth, buildingHeight, wallThickness)
wallL.Position = basePos + Vector3.new(-(doorWidth/2 + sidePanelWidth/2), buildingHeight/2, -frontZ)
wallL.Anchored = true
wallL.Material = Enum.Material.Brick
wallL.Color = Color3.fromRGB(150, 75, 60)
wallL.Parent = buildingModel

-- Правая секция
local wallR = wallL:Clone()
wallR.Name = "FrontWall_Right"
wallR.Position = basePos + Vector3.new((doorWidth/2 + sidePanelWidth/2), buildingHeight/2, -frontZ)
wallR.Parent = buildingModel

-- Верхняя перемычка над дверью (вход свободен от Y=0 до Y=doorHeight)
local wallTop = Instance.new("Part")
wallTop.Name = "FrontWall_TopArch"
wallTop.Size = Vector3.new(doorWidth, buildingHeight - doorHeight, wallThickness)
wallTop.Position = basePos + Vector3.new(0, doorHeight + (buildingHeight - doorHeight)/2, -frontZ)
wallTop.Anchored = true
wallTop.Material = Enum.Material.Brick
wallTop.Color = Color3.fromRGB(150, 75, 60)
wallTop.Parent = buildingModel
```

---

## 🛋️ 4. Обязательный стандарт интерьеров

Каждое создаваемое здание **ОБЯЗАНО** включать:
1. **Пол с фактурой**:
   - Банк, офисы: `Enum.Material.Marble` (светлые или темные тона)
   - Магазины, склады: `Enum.Material.Concrete` или `Enum.Material.SmoothPlastic`
   - Жилые дома, кафе: `Enum.Material.WoodPlanks`
2. **Потолочное освещение**:
   - Панели из `Enum.Material.Neon`
   - Внутри каждой панели — `PointLight` или `SpotLight` (`Brightness = 1.2..2.0`, `Range = 18..28`, теплый или дневной оттенок).
3. **Меблировка (минимум 3-4 предмета на комнату)**:
   - Стойка администратора / кассира / барная стойка.
   - Места ожидания (диваны, кресла, столики).
   - Тематическое наполнение:
     - Банк: стекло касс (`Glass`, `Transparency = 0.5`), хранилище, сейфовая дверь, банкоматы.
     - Магазин/Заправка: стеллажи с товарами, холодильники, кассовые терминалы.
     - Офис: столы, мониторы со светящимися экранами (`SurfaceGui`), кулеры, комнатные растения.
     - Жилой дом: кухня (холодильник, плита), спальня (кровать с изголовьем), гостиная (диван, ТВ).

---

## ⚠️ 5. Ограничения Luau API в Roblox Studio

- ❌ `Enum.Material.CorrugatedIron` — **НЕ СУЩЕСТВУЕТ** в современном Roblox. Вызовет падение скрипта!
  - ✅ **Используй**: `Enum.Material.Metal` или `Enum.Material.DiamondPlate`.
- ❌ Не используй недоступные типы мешей или неподтвержденные ID ассетов напрямую через `InsertService:LoadAsset` без проверки прав, так как сторонние ассеты могут требовать авторизации создателя.
  - ✅ **Используй**: процедурную сборку из примитивов (Part, WedgePart, Cylinder, CornerWedge, TrussPart) либо ассеты из проверенного `city/assets.json`.
- ❌ Не оставляй детали незакрепленными (`Anchored = false`). Все элементы зданий и дорог должны иметь `Anchored = true`.

---

## 📁 6. Структура репозитория

```
roblox-city-astra/
├── README.md                      # Документация проекта
├── ASTRA_GUIDE.md                 # Этот гайд для GPT-6 Astra
├── city/
│   ├── manifest.json              # Главный реестр карты и районов
│   ├── assets.json                # Каталог Toolbox Asset ID и мешей
│   └── districts/                 # Скрипты генерации Luau
│       ├── 01_foundation.luau     # Остров, вода, дорожная сеть, освещение
│       ├── 02_downtown.luau       # Небоскрёбы, банк, ратуша, офисы
│       ├── 03_commercial.luau     # Заправка 24/7, супермаркет, кафе
│       ├── 04_residential.luau    # Дома, коттеджи, центральный парк
│       ├── 05_port_industrial.luau# Порт, краны, контейнеры, заводы
│       └── 06_bedroom_suburb.luau # Многоэтажки, склады, мост
└── plugin/
    ├── GitHubCitySync.lua         # Исходник плагина для Roblox Studio
    └── install_plugin.py          # Скрипт быстрой компиляции и установки .rbxmx
```

---

## 📜 7. Формат файлов скриптов районов (`districts/*.luau`)

Каждый Luau файл должен возвращать функцию генерации или выполнять безопасное построение в родительской папке:

```lua
-- city/districts/sample_building.luau
return function(cityFolder)
    local ChangeHistoryService = game:GetService("ChangeHistoryService")
    ChangeHistoryService:SetWaypoint("Before Building Sample")

    local district = cityFolder:FindFirstChild("Commercial")
    if not district then
        district = Instance.new("Folder")
        district.Name = "Commercial"
        district.Parent = cityFolder
    end

    local model = Instance.new("Model")
    model.Name = "SampleStore"
    model.Parent = district

    local basePos = Vector3.new(150, 0, 50)

    -- [ПОСТРОЕНИЕ ПОЛА, СТЕН, ВХОДОВ, ИНТЕРЬЕРА]
    -- ...

    ChangeHistoryService:SetWaypoint("After Building Sample")
    return model
end
```

---

## 🗺️ 8. Карта зонирования острова (Координатная сетка)

Остров размером `2400 × 2400` studs. Дорожная сеть делит остров на 9 зон (сетка 3×3):
- Дороги проходят по осям `X = -400`, `X = 400` и `Z = -400`, `Z = 400`.
- Высота земли: `Y = 0`. Вода океана: `Y = -34`.

```
           [СЕВЕР (Z = -1200)]
  NW: ЖИЛОЙ СЕКТОР  │ NC: ЦЕНТР (DOWNTOWN) │ NE: ПОРТ И ДОКИ
  (-800, -800)      │ (0, -800)            │ (800, -800)
────────────────────┼──────────────────────┼────────────────────
  CW: ПРОМЗОНА      │ CC: ЦЕНТРАЛЬНЫЙ ПАРК │ CE: ТОРГОВЫЙ РАЙОН
  (-800, 0)         │ (0, 0)               │ (800, 0)
────────────────────┼──────────────────────┼────────────────────
  SW: СПАЛЬНЫЙ Р-Н  │ SC: СКЛАДСКАЯ ЗОНА   │ SE: ПОДВЕСНОЙ МОСТ
  (-800, 800)       │ (0, 800)             │ (800, 800)
           [ЮГ (Z = +1200)]
```

---

## 🎯 9. Чек-лист для GPT-6 Astra перед отправкой коммита:
1. [ ] У здания есть фундамент/пол и крыша.
2. [ ] В здание **можно зайти пешком** (есть проём от 6x8 studs без коллизий).
3. [ ] Внутри есть источники света (`PointLight` в `Neon` плафонах).
4. [ ] Внутри есть базовый интерьер (мебель, прилавки, декор).
5. [ ] Все детали `Anchored = true`.
6. [ ] Нет устаревших материалов (`Enum.Material.CorrugatedIron`).
7. [ ] На фасаде есть читаемая вывеска (`SurfaceGui` + `TextLabel`).
8. [ ] Скрипт зарегистрирован в `city/manifest.json`.
