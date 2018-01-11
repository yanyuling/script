
-- csd文件路径
local csdPath = arg[1]
-- 对应lua文件路径
local luaPath = string.sub(arg[1], 1, -4).. "lua"
luaPath = string.gsub(luaPath, "cocosstudio/cocosstudio", "res")
print("csdPath=".. csdPath)
print("luaPath=".. luaPath)
require("ccext.csd2lua"):csd2lua(csdPath, luaPath)