--[[
工具方法
@author 赵占涛
]]
local util = {}

--[[
拆分一个字符串
@param szFullString 原字符串
@param szSeparator  分隔符
]]
function util:Split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
       local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
       if not nFindLastIndex then
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
        break
       end
       nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
       nFindStartIndex = nFindLastIndex + string.len(szSeparator)
       nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end
function util:formatColor(value)
    if value and value[4] then
        return string.format("cc.c4b(%s, %s, %s, %s)", tostring(value[1]), tostring(value[2]), tostring(value[3]), tostring(value[4]))
    elseif value then
        return string.format("cc.c3b(%s, %s, %s)", tostring(value[1]), tostring(value[2]), tostring(value[3]))
    else
        return "nil"
    end
end
-- 去掉数字后面的小数点（如果确实是一个整数的话）
function util:fixFloat(number)
    if math.floor(number) == number then
        return math.floor(number)
    else 
        return number
    end
end

function util:isPointEqual(pt, values)
    return pt.x == values[1] and pt.y == values[2]
end


function util:isSizeEqual(size, values)
    print(size.width, size.height, values[1], values[2])
    return size.width == values[1] and size.height == values[2]
end

function util:isColorEqual(clr, values)
    if clr.r ~= values[1] or clr.g ~= values[2] or clr.b ~= values[3] or (clr.a and clr.a ~= values[4]) then
        return false
    end
    return true
end

function util:formatSize(value)
    if value then
        return string.format("cc.size(%s, %s)", tostring(util:fixFloat(value[1] or 0)), tostring(util:fixFloat(value[2] or 0)))
    else
        return "nil"
    end
end
function util:formatPoint(value)
    if value then
        return string.format("cc.p(%s, %s)", tostring(util:fixFloat(value[1] or 0)), tostring(util:fixFloat(value[2] or 0)))
    else
        return "nil"
    end
end
function util:formatString(value)
    if string.find(value, "[", 1, true) or string.find(value, "]", 1, true) then
        local i, s, f, e = 1
        while true do
            s = string.rep("=", i)
            f = "[" .. s .. "["
            e = "]" .. s .. "]"

            if not string.find(value, f, 1, true) and not string.find(value, e, 1, true) then
                return f .. value .. e
            end

            i = i + 1
        end
    end
    return "[[" .. value .. "]]"
end
return util