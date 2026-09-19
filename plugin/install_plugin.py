import uuid
import os
import shutil
import sys

sys.stdout.reconfigure(encoding='utf-8')

DIR = os.path.dirname(os.path.abspath(__file__))
LUA_PATH = os.path.join(DIR, "GitHubCitySync.lua")
TARGET_DIR = r"C:\Users\user\AppData\Local\Roblox\Plugins"

with open(LUA_PATH, "r", encoding="utf-8") as f:
    lua_code = f.read()

guid = str(uuid.uuid4()).upper()
rbxmx = f'''<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
\t<External>null</External>
\t<External>nil</External>
\t<Item class="Script" referent="RBX{guid.replace('-', '')}">
\t\t<Properties>
\t\t\t<ProtectedString name="Source"><![CDATA[{lua_code}]]></ProtectedString>
\t\t\t<bool name="Disabled">false</bool>
\t\t\t<Content name="LinkedSource"><null></null></Content>
\t\t\t<token name="RunContext">0</token>
\t\t\t<string name="ScriptGuid">{{{guid}}}</string>
\t\t\t<BinaryString name="AttributesSerialize"></BinaryString>
\t\t\t<SecurityCapabilities name="Capabilities">0</SecurityCapabilities>
\t\t\t<bool name="DefinesCapabilities">false</bool>
\t\t\t<string name="Name">AstraCitySync</string>
\t\t\t<int64 name="SourceAssetId">-1</int64>
\t\t\t<BinaryString name="Tags"></BinaryString>
\t\t</Properties>
\t</Item>
</roblox>'''

local_rbxmx = os.path.join(DIR, "AstraCitySync.rbxmx")
with open(local_rbxmx, "w", encoding="utf-8") as f:
    f.write(rbxmx)

os.makedirs(TARGET_DIR, exist_ok=True)
studio_rbxmx = os.path.join(TARGET_DIR, "AstraCitySync.rbxmx")
shutil.copyfile(local_rbxmx, studio_rbxmx)

print(f"✅ Plugin AstraCitySync.rbxmx successfully generated and installed to:\n   {studio_rbxmx}")
