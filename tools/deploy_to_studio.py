import urllib.request
import json
import os
import sys

sys.stdout.reconfigure(encoding='utf-8')

BRIDGE = "http://127.0.0.1:28111/execute"
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MANIFEST_PATH = os.path.join(ROOT, "city", "manifest.json")

def send(code, desc="Step"):
    try:
        req = urllib.request.Request(
            BRIDGE,
            data=json.dumps({"action": "eval", "code": code}).encode("utf-8"),
            headers={"Content-Type": "application/json"}
        )
        with urllib.request.urlopen(req, timeout=60) as r:
            res = json.loads(r.read().decode("utf-8"))
            ok = "OK" if res.get("success") else "FAIL"
            print(f"[{ok}] {desc}: {str(res.get('result', res.get('error', '')))[:200]}")
            return res.get("success", False)
    except Exception as e:
        print(f"[ERR] {desc}: {e}")
        return False

with open(MANIFEST_PATH, "r", encoding="utf-8") as f:
    manifest = json.load(f)

print(f"🚀 Deploying {manifest['project']} v{manifest['version']} into Roblox Studio...")

# 1. Reset CityMap
send("""
local old = workspace:FindFirstChild('CityMap')
if old then old:Destroy() end
local city = Instance.new('Folder')
city.Name = 'CityMap'
city.Parent = workspace
return 'CityMap folder created'
""", "Init CityMap")

# 2. Deploy each district module
for dist in manifest["districts"]:
    if not dist.get("enabled", True):
        continue
    file_path = os.path.join(ROOT, dist["file"].replace("/", os.sep))
    with open(file_path, "r", encoding="utf-8") as df:
        code = df.read()

    wrapper = f"""
local city = workspace:FindFirstChild('CityMap')
local fn = (function()
{code}
end)()
if type(fn) == 'function' then
    fn(city)
    return 'Built {dist["name"]}'
else
    return 'Executed {dist["name"]}'
end
"""
    send(wrapper, f"District {dist['id']}")

# 3. Position camera for high overview
send("""
local cam = workspace.CurrentCamera
if cam then
    cam.CFrame = CFrame.lookAt(Vector3.new(0, 1100, -1400), Vector3.new(0, 0, -200))
end
return 'Camera positioned for full 2400x2400 megacity view'
""", "Camera Position")

print("\n🎉 All districts deployed successfully!")
