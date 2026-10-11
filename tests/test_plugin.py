"""Run with: uv run --with lupa python -m unittest discover -s tests -v."""
import unittest
from pathlib import Path
import xml.etree.ElementTree as ET

from lupa import LuaRuntime

ROOT = Path(__file__).resolve().parents[1]
MOCKS = r'''
objects = {}
local function signal()
    return {Connect = function(self, callback) self.callback = callback end,
        Fire = function(self) if self.callback then self.callback() end end}
end
Instance = {new = function(class)
    local obj = {ClassName = class, Active = true, TextEditable = true,
        ClearTextOnFocus = true, AutoButtonColor = true, MouseButton1Click = signal()}
    function obj:Destroy() self.destroyed = true end
    table.insert(objects, obj)
    return obj
end}
local function value(...) return {...} end
UDim2 = {new = value}
UDim = {new = value}
Color3 = {fromRGB = value}
Vector3 = {new = value}
CFrame = {lookAt = value}
DockWidgetPluginGuiInfo = {new = value}
Enum = {InitialDockState = {Float = 1}, FillDirection = {Vertical = 1},
    HorizontalAlignment = {Center = 1}, Font = {GothamBold = 1, Gotham = 2, Code = 3},
    TextXAlignment = {Left = 1}, TextYAlignment = {Top = 1}}
plugin = {CreateToolbar = function()
    return {CreateButton = function() return {Click = signal()} end}
end, CreateDockWidgetPluginGui = function() return {} end}
city = {Name = 'CityMap', Destroy = function(self) self.destroyed = true end}
workspace = {CurrentCamera = {}, FindFirstChild = function() return city end}
manifest = {project = 'Test', version = '1', districts = {}}
responses = {}
requests = 0
http = {JSONDecode = function() return manifest end, RequestAsync = function(self, request)
    requests = requests + 1
    if onRequest then onRequest(request) end
    if request.Url:find('city/manifest.json', 1, true) then
        if manifestFailure then error('HTTP unavailable') end
        return {StatusCode = 200, Body = '{}'}
    end
    for path, source in pairs(responses) do
        if request.Url:find(path, 1, true) then return {StatusCode = 200, Body = source} end
    end
    return {StatusCode = 404}
end}
game = {GetService = function(self, name)
    if name == 'HttpService' then return http end
    if name == 'ChangeHistoryService' then return {SetWaypoint = function() end} end
    if name == 'Selection' then return {Set = function() end} end
end}
loadstring = load
print = function() end
function district(id, source, enabled)
    table.insert(manifest.districts, {name = id, file = id .. '.luau', enabled = enabled ~= false})
    responses[id .. '.luau'] = source
end
'''


class PluginTests(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.execute(MOCKS)
        self.lua.execute((ROOT / 'plugin/GitHubCitySync.lua').read_text())
        self.lua.execute('''
            for _, obj in ipairs(objects) do
                if obj.Text == '⚡ СИНХРОНИЗИРОВАТЬ ГОРОД' then sync = obj end
                if obj.Text == '🗑️ Очистить CityMap' then clear = obj end
                if obj.Text == 'Готов к синхронизации' then status = obj end
                if obj.Text == 'Логи синхронизации...\\n' then logs = obj end
                if obj.Text == 'Arte777/roblox-city-astra' then repo = obj end
                if obj.Text == 'main' then branch = obj end
                if obj.PlaceholderText == 'GitHub Token (опционально для приватных репо)' then token = obj end
            end
        ''')

    def run_lua(self, code):
        self.lua.execute(code)

    def assert_restored(self):
        self.run_lua('''assert(sync.Active and clear.Active)
            assert(sync.AutoButtonColor and clear.AutoButtonColor)
            assert(repo.TextEditable and branch.TextEditable and token.TextEditable)''')

    def test_inputs_preserve_text_on_focus(self):
        self.run_lua('assert(not repo.ClearTextOnFocus and not branch.ClearTextOnFocus and not token.ClearTextOnFocus)')

    def test_success_and_disabled_district(self):
        self.run_lua('''district('good', 'return function(city) city.built = true end')
            district('disabled', 'error("must not run")', false)
            sync.MouseButton1Click:Fire()
            assert(city.built and requests == 2)
            assert(status.Text:find('полностью синхронизирован', 1, true))''')
        self.assert_restored()

    def test_compile_runtime_and_invalid_generator_failures(self):
        for source in ('not valid lua !!!', 'return function() error("broken") end', 'return 123'):
            with self.subTest(source=source):
                self.setUp()
                self.lua.globals().bad_source = source
                self.run_lua('''district('bad', bad_source)
                    district('good', 'return function(city) city.built = true end')
                    sync.MouseButton1Click:Fire()
                    assert(city.built)
                    assert(not status.Text:find('полностью синхронизирован', 1, true))
                    assert(status.Text:find('Успешно: 1', 1, true))
                    assert(status.Text:find('ошибок: 1', 1, true))
                    assert(logs.Text:find('bad.luau', 1, true))''')
                self.assert_restored()

    def test_empty_manifest(self):
        self.run_lua('''sync.MouseButton1Click:Fire()
            assert(status.Text:find('Нет включённых районов', 1, true))''')
        self.assert_restored()

    def test_district_download_failure_restores_controls(self):
        self.run_lua('''district('missing', 'return function() end')
            responses['missing.luau'] = nil
            sync.MouseButton1Click:Fire()
            assert(status.Text:find('СБОЙ СИНХРОНИЗАЦИИ', 1, true))
            assert(logs.Text:find('missing.luau', 1, true))''')
        self.assert_restored()

    def test_busy_blocks_sync_clear_and_editing(self):
        self.run_lua('''onRequest = function()
                onRequest = nil
                controlsLocked = not sync.Active and not clear.Active
                inputsLocked = not repo.TextEditable and not branch.TextEditable and not token.TextEditable
                sync.MouseButton1Click:Fire()
                clear.MouseButton1Click:Fire()
            end
            sync.MouseButton1Click:Fire()
            assert(controlsLocked and inputsLocked)
            assert(not city.destroyed and requests == 1)''')
        self.assert_restored()
        self.run_lua('clear.MouseButton1Click:Fire(); assert(city.destroyed)')

    def test_http_failure_restores_controls_and_allows_retry(self):
        self.run_lua('''manifestFailure = true
            sync.MouseButton1Click:Fire()
            assert(status.Text:find('СБОЙ СИНХРОНИЗАЦИИ', 1, true))''')
        self.assert_restored()
        self.run_lua('''manifestFailure = false
            district('good', 'return function(city) city.built = true end')
            sync.MouseButton1Click:Fire(); assert(city.built)''')
        self.assert_restored()

    def test_packaged_plugin_matches_source(self):
        tree = ET.parse(ROOT / 'plugin/AstraCitySync.rbxmx')
        self.assertEqual(tree.find('.//ProtectedString[@name="Source"]').text,
                         (ROOT / 'plugin/GitHubCitySync.lua').read_text())


if __name__ == '__main__':
    unittest.main()
