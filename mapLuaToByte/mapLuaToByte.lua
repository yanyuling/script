
local path = arg[1]
package.path = package.path .. ";../../?.lua;"


local mapBaseCfg = require "src/app/config/mapBaseCfg"
local file = io.open(path .."/../../src/app/config/map_data_byte.lua", "wb")
print(#mapBaseCfg)
if #mapBaseCfg ~= 1201*1201 then
    error("地图尺寸不对 ".. #mapBaseCfg)
end
file:write("return [[")

for i=1,1201*1201 do
    local value = mapBaseCfg[i]
    if not value then
        error("出错了".. i .. " " .. math.floor(i / 1201) +1  .. " " .. i%1201 +1)
    end
    value = value + 31
    if string.byte(string.char(value)) ~= value then
        error("出错了".. i .. " " ..value)
    end
    file:write(string.char(value))
end
file:write("]]")
file:close()

local _MAP_STR_ = require "src/app/config/map_data_byte"
for i,v in ipairs(mapBaseCfg) do
    if v ~= string.byte(string.sub(_MAP_STR_, i,i))-31 then
        print("不相同", i, v, string.byte(string.sub(_MAP_STR_, i,i)))
        error("出错了")
        break
    end
end
local mapBaseMockCfg = require "src/app/config/mapBaseMockCfg"
local file = io.open(path .."/../../src/app/config/map_data_mock_byte.lua", "wb")
print(#mapBaseMockCfg)
file:write("return [[")
for i,value in ipairs(mapBaseMockCfg) do
    value = value + 31
    if not value then
        error("出错了".. i)
    end
    if string.byte(string.char(value)) ~= value then
        error("出错了".. i .. " " ..value)
    end
    file:write(string.char(value))
end
file:write("]]")
file:close()

local _MAP_STR_MOCK_ = require "src/app/config/map_data_mock_byte"
for i,v in ipairs(mapBaseMockCfg) do
    if v ~= string.byte(string.sub(_MAP_STR_MOCK_, i,i))-31 then
        print("不相同", i, v, string.byte(string.sub(_MAP_STR_MOCK_, i,i)))
        error("出错了")
        break
    end
end