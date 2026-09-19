# 🏙️ Roblox Astra City Engine
> **Автономный пайплайн генерации детализированных 3D городов в Roblox Studio с помощью GPT-6 Astra через Notion и GitHub.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Roblox Studio](https://img.shields.io/badge/Roblox_Studio-Supported-blue.svg)](https://create.roblox.com)
[![GitHub API](https://img.shields.io/badge/GitHub_Sync-Active-brightgreen.svg)]()

---

## 🚀 Как работает связка (Notion → GitHub → Roblox Studio)

```
┌─────────────────────────┐
│     NOTION WORKSPACE    │   Пользователь описывает задачу или район
│   (GPT-6 Astra Agent)   │   (напр.: "Сделай автосалон в торговом районе")
└───────────┬─────────────┘
            │
            │ Notion-GitHub Integration (Commits / Pull Requests)
            ▼
┌─────────────────────────┐
│    GITHUB РЕПОЗИТОРИЙ   │   Реестр `city/manifest.json` и
│ (Arte777/roblox-city-… )│   скрипты районов в `city/districts/*.luau`
└───────────┬─────────────┘
            │
            │ HTTP Raw API / Direct Download
            ▼
┌─────────────────────────┐
│   ROBLOX STUDIO PLUGIN  │   Плагин "Astra City Sync" скачивает код,
│   (AstraCitySync.rbxmx) │   собирает полые здания, интерьеры и мебель
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  ГОТОВЫЙ 3D ГОРОД 1:1   │   Человеческий масштаб, свет, вывески,
│   (workspace.CityMap)   │   дверные проёмы, интерьер внутри каждого здания!
└─────────────────────────┘
```

---

## 📖 Руководство для GPT-6 Astra

Все системные правила, масштаб, архитектура полых зданий (Hollow Architecture) и Luau-спецификации подробно описаны в:
👉 **[ASTRA_GUIDE.md](ASTRA_GUIDE.md)**

### Кратко главные требования к Astra:
1. **Масштаб 1:1 (Human Scale)**: 1 stud ≈ 0.28 м. Персонаж = 5 studs. Дверные проёмы = 6×8 studs. Высота потолков = 14–18 studs.
2. **Никаких монолитных кубов**: здания полые, со сквозными дверными проёмами (раздельные стены `FrontWallLeft`, `FrontWallRight`, `FrontWallTop`).
3. **Обязательный интерьер**: пол нужного материала (Marble, Concrete, WoodPlanks), свет `PointLight` внутри `Neon` плафонов, мебель и прилавки.
4. **Вывески на русском**: `SurfaceGui` + `TextLabel` на фасадах.
5. **Материалы**: использовать `Enum.Material.Metal` вместо несуществующего `CorrugatedIron`.

---

## 🛠️ Установка и использование в Roblox Studio

### 1. Установка плагина
Файл плагина уже скомпилирован в:
`plugin/AstraCitySync.rbxmx`

Плагин автоматически копируется в:
`%localappdata%\Roblox\Plugins\AstraCitySync.rbxmx`

Если Studio уже открыта:
1. В Roblox Studio перейдите во вкладку **Plugins**.
2. Нажмите кнопку **Plugins Folder** (или перезапустите Studio).
3. Убедитесь, что `AstraCitySync.rbxmx` лежит в папке.
4. На панели появится иконка **"GitHub City Sync"**.

### 2. Включение HttpService (ОБЯЗАТЕЛЬНО)
Чтобы плагин мог скачивать файлы из GitHub:
1. В Roblox Studio откройте **Home** → **Game Settings** → **Security**.
2. Включите переключатель **Allow HTTP Requests** (Разрешить HTTP-запросы).
3. Нажмите **Save**.

### 3. Синхронизация города
1. Откройте виджет **GitHub City Sync** на панели Plugins.
2. Проверьте адрес репозитория: `Arte777/roblox-city-astra`, ветка: `main`.
3. Нажмите большую кнопку **⚡ СИНХРОНИЗИРОВАТЬ ГОРОД**.
4. Плагин скачает `city/manifest.json` и последовательно построит все районы!

---

## 📁 Структура репозитория

```
roblox-city-astra/
├── README.md                      # Главная документация
├── ASTRA_GUIDE.md                 # Детальная инструкция для GPT-6 Astra
├── city/
│   ├── manifest.json              # Реестр районов, сетка и порядок компиляции
│   ├── assets.json                # Каталог Toolbox / внешних ассетов
│   └── districts/                 # Luau генераторы районов:
│       ├── 01_foundation.luau     # Остров, океан, скалы, дороги, разметка
│       ├── 02_downtown.luau       # Банк (с золотом и сейфом), Офис "DREAM BIGGER"
│       ├── 03_commercial.luau     # Заправка 24/7, маркет, кофейня
│       ├── 04_residential_park.luau# Коттеджи с мебелью, Центральный парк с озером
│       ├── 05_port_industrial.luau# Морской порт, кран, контейнеры, завод
│       └── 06_bedroom_warehouses.luau # Многоэтажки, склады, подвесной мост
└── plugin/
    ├── GitHubCitySync.lua         # Исходный код плагина Studio
    ├── AstraCitySync.rbxmx        # Скомпилированный файл плагина
    └── install_plugin.py          # Скрипт сборки и автоустановки
```

---

## 🗺️ Координаты районов (Зонирование 640×640 studs)

| Район | Координаты центра (X, Z) | Назначение |
|---|---|---|
| **Северо-Запад (NW)** | `(-210, -210)` | Жилой сектор (коттеджи, сады) |
| **Север (NC)** | `(0, -210)` | Деловой центр (Банк, Небоскрёбы) |
| **Северо-Восток (NE)** | `(210, -210)` | Порт и морские доки (краны, контейнеры) |
| **Запад (CW)** | `(-210, 0)` | Промзона (завод, трубы, заборы) |
| **Центр (CC)** | `(0, 0)` | Центральный парк (озеро, фонтан, аллеи) |
| **Восток (CE)** | `(210, 0)` | Торговый район (заправка, супермаркет, кафе) |
| **Юго-Запад (SW)** | `(-210, 210)` | Спальный район (многоэтажные дома) |
| **Юг (SC)** | `(0, 210)` | Склады и логистический комплекс |
| **Юго-Восток (SE)** | `(210, 210)` | Подвесной мост на материк |
