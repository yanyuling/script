
require("ccext.NodeDefaultProperty")
local NodeGenerater = require("ccext.NodeGenerater")
-- 工具类
local util = require("ccext.util")

local _M = {}

-- 加载plist文件表
local _ADD_TEXTURES_PLIST = false

-- 存放节点名字的table(用来检测重名)
local nameTable = {}
local currentCsd = ""

--/////////////////////////////////////////////////////////////////////////////
local _SCRIPT_HELPER =
[[
local _L = require("ccext.LuaResHelper")
]]

local _SCRIPT_HEAD =
[[
local _M = { CCSVER = "%s" }
]]

local _CREATE_FUNC_HEAD = ""
if _ADD_TEXTURES_PLIST then
_CREATE_FUNC_HEAD = [[
function _M.createWithObject(self)
	local ccspc = cc.SpriteFrameCache:getInstance()
	local ccsam = ccs.ArmatureDataManager:getInstance()

	local setValue, bind, addChildForPre, createLabel = _L.setValue, _L.bind, _L.addChildForPre, _L.createLabel
	local setBgColor, setBgImage = _L.setBgColor, _L.setBgImage
	local setClickEvent, setTouchEvent = _L.setClickEvent, _L.setTouchEvent
	local loadPlist = _L.loadPlist
	local CreatePositionFrame,CreateVisibleFrame,CreateColorFrame,CreateEventFrame,CreateInnerActionFrame,CreateScaleFrame,CreateRotationSkewFrame,CreateTextureFrame = _L.CreatePositionFrame,_L.CreateVisibleFrame,_L.CreateColorFrame,_L.CreateEventFrame,_L.CreateInnerActionFrame,_L.CreateScaleFrame,_L.CreateRotationSkewFrame,_L.CreateTextureFrame

	local roots, obj, inc = {}
	loadPlist(_M.textures)
]]
else
_CREATE_FUNC_HEAD = [[
function _M.createWithObject(self)
	local ccspc = cc.SpriteFrameCache:getInstance()
	local ccsam = ccs.ArmatureDataManager:getInstance()

	local setValue, bind, addChildForPre, createLabel = _L.setValue, _L.bind, _L.addChildForPre, _L.createLabel
	local setBgColor, setBgImage = _L.setBgColor, _L.setBgImage
	local setClickEvent, setTouchEvent = _L.setClickEvent, _L.setTouchEvent
	local CreatePositionFrame,CreateVisibleFrame,CreateColorFrame,CreateEventFrame,CreateInnerActionFrame,CreateScaleFrame,CreateRotationSkewFrame,CreateTextureFrame = _L.CreatePositionFrame,_L.CreateVisibleFrame,_L.CreateColorFrame,_L.CreateEventFrame,_L.CreateInnerActionFrame,_L.CreateScaleFrame,_L.CreateRotationSkewFrame,_L.CreateTextureFrame

	local roots, obj, inc = {}
]]
end

local _CREATE_FUNC_FOOT =
[[
	return self
end
]]

local _SCRIPT_FOOT =
[[

return _M
]]

--/////////////////////////////////////////////////////////////////////////////
local function nextSiblingIter(node)
	local i, c, a = 1, node:numChildren(), node:children()
	return function()
		if i <= c then
			local n = a[i]
			i = i + 1
			return n
		end
		return nil
	end
end




local function resourceType(t)
	if t == "Normal" or t == "Default" or t == "MarkedSubImage" then
		return 0
	else -- PlistSubImage
	return 1
	end
end

--/////////////////////////////////////////////////////////////////////////////


--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_Node(obj, name, value)
	local opts = self.opts
	local lays = self.lays

	if name == "Name" then
		opts[name] = value

		-- 如果发现重名节点，就发出警告
		if not nameTable[value] then
			nameTable[value] = true
		else
			error("发现重名节点".. value .."@".. currentCsd)
		end
	elseif name == "Tag" or name == "RotationSkewX" or name == "RotationSkewY" then
		opts[name] = tonumber(value) or 0
	elseif name == "Rotation" then
	elseif name == "FlipX" or name == "FlipY" then
		opts["Flipped" .. string.sub(name, 5)] = (value == "True")
	elseif name == "ZOrder" then
		opts["LocalZOrder"] = tonumber(value) or 0
	elseif name == "Visible" then
	elseif name == "VisibleForFrame" then
		opts["Visible"] = (value == "True")
	elseif name == "Alpha" then
		opts["Opacity"] = tonumber(value) or 255
	elseif name == "TouchEnable" then
		opts[name .. "d"] = (value == "True")
	elseif name == "UserData" then
	elseif name == "FrameEvent" then
	elseif name == "CallBackType" or name == "CallBackName" then
		opts["Callback" .. string.sub(name, 9)] = value
	elseif name == "PositionPercentXEnabled" or name == "PositionPercentYEnabled" or
			name == "PercentWidthEnabled" or name == "PercentHeightEnabled" or
			name == "StretchWidthEnable" or name == "StretchHeightEnable" then
		lays[name] = (value == "True")
		-- fix bad name likes PercentHeightEnable
	elseif name == "PositionPercentXEnable" or name == "PositionPercentYEnable" or
			name == "PercentWidthEnable" or name == "PercentHeightEnable" then
		lays[name .. "d"] = (value == "True")
	elseif name == "HorizontalEdge" or name == "VerticalEdge" then
		if value == "LeftEdge" or value == "BottomEdge" then
			lays[name] = 1
		elseif value == "RightEdge" or value == "TopEdge" then
			lays[name] = 2
		elseif value == "BothEdge" then
			lays[name] = 3
		end
	elseif name == "LeftMargin" or name == "RightMargin" or
			name == "TopMargin" or name == "BottomMargin" then
		lays[name] = tonumber(value) or 0
	elseif name == "Scale9Enable" then
		opts["Scale9Enabled"] = (value == "True")
	elseif name == "Scale9OriginX" or name == "Scale9OriginY" or
			name == "Scale9Width" or name == "Scale9Height" then
		opts[name] = tonumber(value) or 0
	elseif name == "FontSize" then
		opts[name] = tonumber(value) or 22
	elseif name == "FontName" then
		opts[name] = value
	elseif name == "DisplayState" or name == "IsCustomSize" or name == "OutlineEnabled" or name == "ShadowEnabled" then
		opts[name] = (value == "True")
	elseif name == "OutlineSize" or name == "ShadowOffsetX" or name == "ShadowOffsetY" or name == "ShadowBlurRadius" then
		opts[name] = tonumber(value) or 0
	else
		return false
	end

	--	print("onProperty_Node(" .. name .. ", " .. tostring(value) .. ")")
	return true
end

function _M:onChildren_Node(obj, name, c)
	local opts = self.opts
	local lays = self.lays
	print("_M:onChildren_Node", name)
	if name == "Position" then
		opts[name] = { tonumber(c["@X"]) or 0, tonumber(c["@Y"]) or 0 }
	elseif name == "Scale" then
		opts[name] = { tonumber(c["@ScaleX"]) or 1, tonumber(c["@ScaleY"]) or 1 }
	elseif name == "AnchorPoint" then
		opts[name] = { tonumber(c["@ScaleX"]) or 0, tonumber(c["@ScaleY"]) or 0 }
	elseif name == "CColor" then
		opts["Color"] = {
			tonumber(c["@R"]) or 0, tonumber(c["@G"]) or 0,
			tonumber(c["@B"]) or 0, tonumber(c["@A"])
		}
	elseif name == "Size" then
		print("onChildren_Node Size", opts.Name)
		opts[name] = { tonumber(c["@X"]) or 0, tonumber(c["@Y"]) or 0 }
	elseif name == "PrePosition" then
		lays["PositionPercentX"] = tonumber(c["@X"]) or 0
		lays["PositionPercentY"] = tonumber(c["@Y"]) or 0
	elseif name == "PreSize" then
		lays["PercentWidth"] = tonumber(c["@X"]) or 0
		lays["PercentHeight"] = tonumber(c["@Y"]) or 0
	elseif name == "FileData" then
		local f, t, p = c["@Path"] or "", resourceType(c["@Type"]), c["@Plist"] or ""
		if #p > 0 then
			self:addTexture(t, p)
		else
			self:addTexture(t, f)
		end
		opts[name] = { f, t, p }
	elseif name == "OutlineColor" or name == "ShadowColor" then
		opts[name] = {
			tonumber(c["@R"]) or 0, tonumber(c["@G"]) or 0,
			tonumber(c["@B"]) or 0, tonumber(c["@A"]) or 0
		}
	elseif name == "FontResource" then
		opts[name] = c["@Path"]
		print("发现FontResource", c["@Path"])
	else
		return false
	end

	return true
end

function _M:handleOpts_Node(obj)
	local opts = self.opts
	local lays = self.lays

	local tblVal, tblTmp, str = {}, {}, ""

	local node_name = opts.Name

	local optsKeys = {}
	for k, v in pairs(opts) do
		table.insert(optsKeys, k)
	end
	table.sort(optsKeys, function (a,b)
		return a<b
	end)
	for k, v in pairs(optsKeys) do
		local name = v
		local value = opts[v]
		str = ""
		if name == "Name" then
			local pos = string.find(value, "@class_")
			if pos then
				value = string.sub(value, 1, pos - 1)
			end
			tblTmp[name] = value
		elseif name == "Tag" or name == "LocalZOrder" or name == "Opacity" then
			if obj["get" .. name](obj) ~= value then
				tblTmp[name] = value
			end
		elseif name == "RotationSkewX" or name == "RotationSkewY" then
			if (type(obj["get" .. name]) == "function" and obj["get" .. name](obj) ~= value) then
				-- print("name", name, value)
				str = string.format("obj:set%s(%s)\n", name, tostring(util:fixFloat(value)))
			end
		elseif name == "Visible" or name == "FlippedX" or name == "FlippedY" then
			if type(obj["is" .. name]) == "function" and obj["is" .. name](obj) ~= value then
				str = string.format("obj:set%s(%s)\n", name, tostring(value))
			end
		elseif name == "Position" or name == "Scale" then
			if obj["get" .. name .. "X"](obj) ~= value[1] or
					obj["get" .. name .. "Y"](obj) ~= value[2] then
				if name == "Scale" then
					print(opts.Name)
					print("ScaleScaleScaleScaleScaleScale")
					if tostring(value[1]) == tostring(value[2]) then
						print("scalex == scaley")
						str = string.format("obj:setScale(%s)\n", tostring(util:fixFloat(value[1])))
						print(str)
						print(opts.Name)
					else
						str = string.format("obj:setScaleX(%s)\n", tostring(util:fixFloat(value[1])))
						str = str .. string.format("	self.".. opts.Name .. ":setScaleY(%s)\n", tostring(util:fixFloat(value[2])))
					end

				else
					tblTmp[name] = value
				end
			end
		elseif name == "AnchorPoint" then
			if not util:isPointEqual(obj["get" .. name](obj), value) then
				tblTmp[name] = value
			end
		elseif name == "Size" then
			-- getSize is deprecated, use getContentSize
			print("util:isSizeEqual", opts.Name, util:isSizeEqual(obj["getContentSize"](obj), value))
			if type(obj["getContentSize"]) == "function" and not util:isSizeEqual(obj["getContentSize"](obj), value) then
				tblTmp[name] = value
				print("setSize", opts.Name, util:formatSize(tblTmp.Size))
			end
		elseif name == "Color" then
			if not util:isColorEqual(obj:getColor(), value) then
				tblTmp[name] = value
			end
		end

		if #str > 0 then
			str = string.gsub(str, "obj", "self." .. node_name)
			table.insert(tblVal, "	" .. str)
		end
	end

	-- self:writef("	setValue(obj, \"%s\", %s, %s, %s, %s, %s, %s, %s, %s)\n",
	-- 	tostring(tblTmp.Name), tostring(tblTmp.Tag), util:formatSize(tblTmp.Size), util:formatPoint(tblTmp.Position), util:formatPoint(tblTmp.AnchorPoint),
	-- 	util:formatColor(tblTmp.Color), tostring(tblTmp.Opacity), tostring(tblTmp.LocalZOrder), tostring(opts.IgnoreContentAdaptWithSize))
	print("this size", opts.Name, util:formatSize(tblTmp.Size))
	print("	setValue(self.%s, \"%s\", %s, %s, %s, %s, %s, %s, %s, %s)\n",
	tostring(tblTmp.Name),tostring(tblTmp.Name), tostring(tblTmp.Tag), util:formatSize(tblTmp.Size), util:formatPoint(tblTmp.Position), util:formatPoint(tblTmp.AnchorPoint),
	util:formatColor(tblTmp.Color), tostring(tblTmp.Opacity), tostring(tblTmp.LocalZOrder), tostring(opts.IgnoreContentAdaptWithSize))
	self:writef("	setValue(self.%s, \"%s\", %s, %s, %s, %s, %s, %s, %s, %s)\n",
	tostring(tblTmp.Name),tostring(tblTmp.Name), tostring(tblTmp.Tag), util:formatSize(tblTmp.Size), util:formatPoint(tblTmp.Position), util:formatPoint(tblTmp.AnchorPoint),
	util:formatColor(tblTmp.Color), tostring(tblTmp.Opacity), tostring(tblTmp.LocalZOrder), tostring(opts.IgnoreContentAdaptWithSize))


	if #tblVal > 0 then
		self:write(table.concat(tblVal))
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_ImageView(obj, name, value)
	-- nothing to do
	return self:onProperty_Node(obj, name, value)
end

function _M:onChildren_ImageView(obj, name, c)
	--	local opts = self.opts
	--
	--	if name == "Size" and opts.Scale9Enabled then
	--		opts["Scale9Size"] = { tonumber(c["@X"]) or 0, tonumber(c["@Y"]) or 0 }
	--	else
	return self:onChildren_Node(obj, name, c)
	--	end
	--
	--	print("onChildren_ImageView(" .. name .. ", " .. tostring(opts[name]) .. ")")
	--	return true
end

function _M:handleOpts_ImageView(obj)
	local opts = self.opts


	if opts.Scale9Enabled then
		opts["IgnoreContentAdaptWithSize"] = false
	end

	self:handleOpts_Node(obj)

	if not opts.Scale9Enabled then
		self:writef("	self.%s:ignoreContentAdaptWithSize(false)\n", opts.Name)
	end
	if opts.FileData then
		self:writef("	Util:loadTextureForImage(self.%s,\"%s\")\n", opts.Name, tostring(opts.FileData[1]))
	end
	if opts.Scale9Enabled then
		local capInsets = string.format("cc.rect(%s, %s, %s, %s)",
			tostring(opts.Scale9OriginX or 0), tostring(opts.Scale9OriginY or 0),
			tostring(opts.Scale9Width or 0), tostring(opts.Scale9Height or 0))

		self:write(string.format("	self.%s:setScale9Enabled(true)\n", opts.Name))
		self:write(string.format("	self.%s:setCapInsets(" .. capInsets .. ")\n", opts.Name))

		if opts.Scale9Size then
			self:writef("	self.%s:setContentSize(%s)\n", opts.Name, util:formatSize(opts.Scale9Size))
		end
	end

end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_Button(obj, name, value)
	local opts = self.opts

	if name == "ButtonText" then
		opts[name] = value
	elseif name == "Scale9Width" then
		opts[name] = value
	elseif name == "Scale9Height" then
		opts[name] = value
	else
		return self:onProperty_Node(obj, name, value)
	end

	--	print("onProperty_Button(" .. name .. ", " .. tostring(value) .. ")")
	return true
end

function _M:onChildren_Button(obj, name, c)
	local opts = self.opts

	if name == "TextColor" then
		opts[name] = {
			tonumber(c["@R"]) or 0, tonumber(c["@G"]) or 0,
			tonumber(c["@B"]) or 0
		}
	elseif name == "NormalFileData" or name == "PressedFileData" or name == "DisabledFileData" then
		local f, t, p = c["@Path"] or "", resourceType(c["@Type"]), c["@Plist"] or ""
		if #p > 0 then
			self:addTexture(t, p)
		else
			self:addTexture(t, f)
		end
		opts[name] = { f, t, p }
	elseif name == "Size" and opts.Scale9Enabled then
		opts["Scale9Size"] = { tonumber(c["@X"]) or 0, tonumber(c["@Y"]) or 0 }
	else
		return self:onChildren_Node(obj, name, c)
	end

	--	print("onChildren_Button(" .. name .. ", " .. tostring(opts[name]) .. ")")
	return true
end

function _M:handleOpts_Button(obj)
	local opts = self.opts

	if opts.Scale9Enabled then
		local capInsets = string.format("cc.rect(%s, %s, %s, %s)",
			tostring(opts.Scale9OriginX or 0), tostring(opts.Scale9OriginY or 0),
			tostring(opts.Scale9Width or 0), tostring(opts.Scale9Height or 0))

		self:write("	self."..opts.Name..":setCapInsets(" .. capInsets .. ")\n")
		self:write("	self."..opts.Name..":setScale9Enabled(true)\n")

		if opts.Scale9Size then
			self:writef("	self."..opts.Name..":setContentSize(%s)\n", util:formatSize(opts.Scale9Size))
		end
	else
		if opts["ButtonText"] ~= "" then
			opts["IgnoreContentAdaptWithSize"] = false
		end
	end

	self:handleOpts_Node(obj)

	if opts.NormalFileData then
		local textureType = 0
		if opts.NormalFileData[3] ~= "" then
			textureType = 1
		end
		self:writef("	self.%s:loadTextureNormal(\"%s\", _L.getPicType(\"%s\"))\n", opts.Name,  tostring(opts.NormalFileData[1]), tostring(opts.NormalFileData[1]))
	end

	if opts.PressedFileData then
		local textureType = 0
		if opts.PressedFileData[3] ~= "" then
			textureType = 1
		end
		self:writef("	self.%s:loadTexturePressed(\"%s\", _L.getPicType(\"%s\"))\n", opts.Name, tostring(opts.PressedFileData[1]), tostring(opts.PressedFileData[1]))
	end

	if opts.DisabledFileData then
		local textureType = 0
		if opts.DisabledFileData[3] ~= "" then
			textureType = 1
		end
		self:writef("	self.%s:loadTextureDisabled(\"%s\", _L.getPicType(\"%s\"))\n", opts.Name, tostring(opts.DisabledFileData[1]), tostring(opts.DisabledFileData[1]))
		self:writef(" 	Util:darkNode(self.%s:getRendererDisabled())\n", opts.Name)
	end

	if opts.FontResource then
	end

	if nil ~= opts.DisplayState then
		if obj:isBright() ~= opts.DisplayState then
			self:writef("	self.%s:setBright(%s)\n", opts.Name, tostring(opts.DisplayState))
		end

		if obj:isEnabled() ~= opts.DisplayState then
			self:writef("	self.%s:setEnabled(%s)\n", opts.Name, tostring(opts.DisplayState))
		end
	end

	if opts.OutlineEnabled then
		self:writef("	self.%s:enableOutline(%s, %s)\n", opts.Name, util:formatColor(opts.OutlineColor or { 0, 0, 0, 0 }), tostring(opts.OutlineSize or 0))
	end

	if opts.ShadowEnabled then
		self:writef("	self.%s:enableShadow(%s, cc.size(%d, %d), %s)\n", opts.Name,
			util:formatColor(opts.ShadowColor or { 0, 0, 0, 0 }), tonumber(opts.ShadowOffsetX) or 0, tonumber(opts.ShadowOffsetY) or 0, tostring(opts.ShadowBlurRadius or 0))
	end

	if opts.ButtonText and not obj:getTitleText() ~= opts.ButtonText then
		-- self:writef("	self.%s:setTitleText(" .. util:formatString(opts.ButtonText) .. ")\n", opts.Name)
	end

	if opts.TextColor and not util:isColorEqual(obj:getTitleColor(), opts.TextColor) then
		self:writef("	self.%s:setTitleColor(" .. util:formatColor(opts.TextColor) .. ")\n", opts.Name)
	end

	if opts.FontSize and obj:getTitleFontSize() ~= opts.FontSize then
		self:writef("	self.%s:setTitleFontSize(" .. tostring(opts.FontSize) .. ")\n", opts.Name)
	end

	if opts.FontResource and obj:getTitleFontName() ~= opts.FontResource then
		self:writef("	self.%s:setTitleFontName(\"".. opts.FontResource .. "\")\n", opts.Name)
	end
	self:write("	setClickEvent(self, self.".. opts.Name .. [[, "]] .. opts.Name .. [[")]] .. "\n")
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_Text(obj, name, value)
	local opts = self.opts

	if name == "TouchScaleChangeAble" then
		opts["TouchScaleEnabled"] = (value == "True")
	elseif name == "LabelText" then
		opts[name] = value
	elseif name == "AreaWidth" or name == "AreaHeight" then
		opts[name] = tonumber(value) or 0
	elseif name == "HorizontalAlignmentType" then
		if value == "HT_Left" then
			opts["TextHorizontalAlignment"] = 0
		elseif value == "HT_Center" then
			opts["TextHorizontalAlignment"] = 1
		elseif value == "HT_Right" then
			opts["TextHorizontalAlignment"] = 2
		end
	elseif name == "VerticalAlignmentType" then
		if value == "VT_Top" then
			opts["TextVerticalAlignment"] = 0
		elseif value == "VT_Center" then
			opts["TextVerticalAlignment"] = 1
		elseif value == "VT_Bottom" then
			opts["TextVerticalAlignment"] = 2
		end
	else
		return self:onProperty_Node(obj, name, value)
	end

	--	print("onProperty_Text(" .. name .. ", " .. tostring(value) .. ")")
	return true
end

function _M:onChildren_Text(obj, name, c)
	-- nothing to do
	return self:onChildren_Node(obj, name, c)
end

function _M:handleOpts_Text(obj)
	local opts = self.opts

	self:handleOpts_Node(obj)

	if opts.LabelText then
		-- self:writef("	%s:setString(%s)\n", "self." ..opts.Name , util:formatString(opts.LabelText))
	end

	if opts.FontSize and obj:getFontSize() ~= opts.FontSize then
		self:writef("	%s:setFontSize(%s)\n", "self." ..opts.Name, tostring(opts.FontSize))
	end
	if opts.FontResource then
		self:writef("	%s:setFontName(\"%s\")\n", "self." ..opts.Name, tostring(opts.FontResource))
	else
		self:writef("	%s:setFontName(\"%s\")\n", "self." ..opts.Name, "Helvetica")
	end

	if nil ~= opts.TouchScaleChangeAble and obj:isTouchScaleChangeAble() ~= opts.TouchScaleChangeAble then
		self:writef("	%s:setTouchScaleChangeAble(%s)\n", "self." ..opts.Name, tostring(opts.TouchScaleChangeAble))
	end

	if (nil ~= opts.AreaWidth or nil ~= opts.AreaHeight) and
			obj:getTextAreaSize().width ~= (opts.opts.AreaWidth or 0) and
			obj:getTextAreaSize().height ~= (opts.opts.AreaHeight or 0) then
		self:writef("	%s:setTextAreaSize(cc.size(%s))\n", "self." ..opts.Name, tostring(opts.AreaWidth or 0), tostring(opts.AreaHeight or 0))
	end

	if opts.TextHorizontalAlignment and obj:getTextHorizontalAlignment() ~= opts.TextHorizontalAlignment then
		self:writef("	%s:setTextHorizontalAlignment(%s)\n", "self." ..opts.Name, tostring(opts.TextHorizontalAlignment))
	end

	if opts.TextVerticalAlignment and obj:getTextVerticalAlignment() ~= opts.TextVerticalAlignment then
		self:writef("	%s:setTextVerticalAlignment(%s)\n", "self." ..opts.Name, tostring(opts.TextVerticalAlignment))
	end

	if opts.OutlineEnabled then
		self:writef("	%s:enableOutline(%s, %s)\n", "self." ..opts.Name, util:formatColor(opts.OutlineColor or { 0, 0, 0, 0 }), tostring(opts.OutlineSize or 0))
	end

	if opts.ShadowEnabled then
		self:writef("	%s:enableShadow(%s, cc.size(%s, %s), %s)\n", "self." ..opts.Name,
			util:formatColor(opts.ShadowColor or { 0, 0, 0, 0 }),tostring( opts.ShadowOffsetX or 0), tostring( opts.ShadowOffsetY or 0), tostring(opts.ShadowBlurRadius or 0))
	end

	if opts.Color and not util:isColorEqual(obj:getTextColor(), opts.Color) then
		self:writef("	%s:setColor(%s)\n", "self." ..opts.Name, util:formatColor(opts.Color))
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_RichTextEx(obj, name, value)
	-- nothing to do
	return self:onProperty_Text(obj, name, value)
end

function _M:onChildren_RichTextEx(obj, name, c)
	-- nothing to do
	return self:onChildren_Text(obj, name, c)
end

function _M:handleOpts_RichTextEx(obj)
	local opts = self.opts

	if nil ~= opts.AreaWidth or nil ~= opts.AreaHeight then
		opts["IgnoreContentAdaptWithSize"] = false
	end

	self:handleOpts_Node(obj)

	if opts.FontSize and obj:getFontSizeDef() ~= opts.FontSize then
		self:writef("	self.".. opts.Name .. ":setFontSizeDef(%s)\n", tostring(opts.FontSize))
	end

	if opts.Color and not util:isColorEqual(obj:getTextColorDef(), opts.Color) then
		self:writef("	self.".. opts.Name .. ":setTextColorDef(%s)\n", util:formatColor(opts.Color))
	end

	if opts.TextHorizontalAlignment or opts.TextVerticalAlignment then
		self:writef("	self.".. opts.Name .. ":setAlignment(%d, %d)\n", tonumber(opts.TextHorizontalAlignment) or 0, tonumber(opts.TextVerticalAlignment) or 0)
	end

	if opts.LabelText then
		-- self:writef("	self.".. opts.Name .. ":setString(%s)\n", util:formatString(opts.LabelText))
	end

	print("handleOpts_RichTextEx")
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_TextField(obj, name, value)
	local opts = self.opts

	if name == "LabelText" or name == "PlaceHolderText" or name == "PasswordStyleText" then
		opts[name] = value
	elseif name == "MaxLengthEnable" or name == "PasswordEnable" then
		opts[name .. "d"] = (value == "True")
	elseif name == "MaxLengthText" then
		opts["MaxLength"] = tonumber(value) or 0
	elseif name == "PasswordStyleText" then
		opts["PasswordStyle"] = value
	else
		return self:onProperty_Node(obj, name, value)
	end

	--	print("onProperty_TextField(" .. name .. ", " .. tostring(value) .. ")")
	return true
end

function _M:onChildren_TextField(obj, name, c)
	-- nothing to do
	return self:onChildren_Node(obj, name, c)
end

function _M:handleOpts_TextField(obj)
	self:handleOpts_Node(obj)

	local opts = self.opts

	if opts.LabelText then
		-- self:writef("	self.%s:setString(%s)\n", opts.Name, util:formatString(opts.LabelText))
	end

	if opts.PlaceHolderText then
		self:writef("	self.%s:setPlaceHolder(%s)\n", opts.Name, util:formatString(opts.PlaceHolderText))
	end

	if opts.FontSize and obj:getFontSize() ~= opts.FontSize then
		self:writef("	self.%s:setFontSize(%s)\n", opts.Name, tostring(opts.FontSize))
	end

	if opts.FontName and obj:getFontName() ~= opts.FontName then
		self:writef("	self.%s:FontName(\"%s\")\n", opts.Name, tostring(opts.FontName))
	end

	if opts.MaxLengthEnabled then
		if obj:isMaxLengthEnabled() ~= opts.MaxLengthEnabled then
			self:writef("	self.%s:setMaxLengthEnabled(%s)\n", opts.Name, tostring(opts.MaxLengthEnabled))
		end

		if opts.MaxLength and obj:getMaxLength() ~= opts.MaxLength then
			self:writef("	self.%s:setMaxLength(%s)\n", opts.Name, tostring(opts.MaxLength))
		end
	end

	if opts.PasswordEnabled then
		if obj:isPasswordEnabled() ~= opts.PasswordEnabled then
			self:writef("	self.%s:setPasswordEnabled(%s)\n", opts.Name, tostring(opts.PasswordEnabled))
		end

		if opts.PasswordStyleText then
			self:writef("	self.%s:setPasswordStyleText(%s)\n", opts.Name, util:formatString(opts.PasswordStyleText))
		end
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_EditBox(obj, name, value)
	-- nothing to do
	return self:onProperty_TextField(obj, name, value)
end

function _M:onChildren_EditBox(obj, name, c)
	-- nothing to do
	return self:onChildren_TextField(obj, name, c)
end

function _M:handleOpts_EditBox(obj)
	self:handleOpts_Node(obj)

	local opts = self.opts

	if opts.LabelText then
		self:writef("	self.".. opts.Name .. ":setText(%s)\n", util:formatString(opts.LabelText))
	end


	if opts.PlaceHolderText then
		self:writef("	self.".. opts.Name .. ":setPlaceHolder(%s)\n", util:formatString(opts.PlaceHolderText))
	end

	if opts.FontSize then
		self:writef("	self.".. opts.Name .. ":setFontSize(%s)\n", tostring(opts.FontSize))
	end

	if opts.Color then
		self:writef("	self.".. opts.Name .. ":setFontColor(%s)\n", util:formatColor(opts.Color))
	end

	if opts.FontName then
		self:writef("	self.".. opts.Name .. ":FontName(\"%s\")\n", tostring(opts.FontName))
		self:writef("	self.".. opts.Name .. ":PlaceHolderFontName(\"%s\")\n", tostring(opts.FontName))
	end

	if opts.MaxLengthEnabled and opts.MaxLength then
		self:writef("	self.".. opts.Name .. ":setMaxLength(%s)\n", tostring(opts.MaxLength))
	end

	if opts.PasswordEnabled then
		self:write("	self.".. opts.Name .. ":setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)\n")
	end

	self:write("	self.".. opts.Name .. ":setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)\n")
	self:write("	self.".. opts.Name .. ":setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)\n")
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_TextAtlas(obj, name, value)
	local opts = self.opts

	if name == "LabelText" or name == "StartChar" then
		opts[name] = value
	elseif name == "CharWidth" or name == "CharHeight" then
		opts[name] = tonumber(value) or 0
	else
		return self:onProperty_Node(obj, name, value)
	end

	--	print("onProperty_TextAtlas(" .. name .. ", " .. tostring(value) .. ")")
	return true
end

function _M:onChildren_TextAtlas(obj, name, c)
	local opts = self.opts

	if name == "LabelAtlasFileImage_CNB" then
		local f = c["@Path"] or "", 0, ""
		self:addTexture(0, f)
		opts[name] = f
	else
		return self:onChildren_Node(obj, name, c)
	end

	--	print("onChildren_TextAtlas(" .. name .. ", " .. tostring(opts[name]) .. ")")
	return true
end

function _M:handleOpts_TextAtlas(obj)
	local opts = self.opts

	if not obj:isIgnoreContentAdaptWithSize() then
		opts["IgnoreContentAdaptWithSize"] = true
	end

	self:handleOpts_Node(obj)

	if opts.LabelAtlasFileImage_CNB and opts.StartChar and opts.CharWidth and opts.CharHeight then
		self:writef("	self.".. opts.Name .. ":setProperty(%s, \"%s\", %s, %s, %s)\n",
			util:formatString(opts.LabelText), opts.LabelAtlasFileImage_CNB,
			tostring(opts.CharWidth), tostring(opts.CharHeight),
			util:formatString(opts.StartChar))
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_TextBMFont(obj, name, value)
	local opts = self.opts

	if name == "LabelText" then
		opts[name] = value
	else
		return self:onProperty_Node(obj, name, value)
	end

	--	print("onProperty_TextBMFont(" .. name .. ", " .. tostring(value) .. ")")
	return true
end

function _M:onChildren_TextBMFont(obj, name, c)
	local opts = self.opts

	if name == "LabelBMFontFile_CNB" then
		local f = c["@Path"] or "", 0, ""
		--		self:addTexture(0, f)
		opts[name] = f
	else
		return self:onChildren_Node(obj, name, c)
	end

	--	print("onChildren_TextBMFont(" .. name .. ", " .. tostring(opts[name]) .. ")")
	return true
end

function _M:handleOpts_TextBMFont(obj)
	local opts = self.opts

	if not obj:isIgnoreContentAdaptWithSize() then
		opts["IgnoreContentAdaptWithSize"] = true
	end

	self:handleOpts_Node(obj)

	if opts.LabelText then
		-- self:writef("	self.".. opts.Name .. ":setString(%s)\n", util:formatString(opts.LabelText))
	end

	if opts.LabelBMFontFile_CNB then
		self:writef("	self.".. opts.Name .. ":setFntFile(\"%s\")\n", opts.LabelBMFontFile_CNB)
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_CheckBox(obj, name, value)
	local opts = self.opts

	if name == "CheckedState" or name == "DisplayState" then
		opts[name] = (value == "True")
	elseif name == "TouchEnable" then
		opts[name] = (value == "True")
	else
		return self:onProperty_Node(obj, name, value)
	end

	--	print("onProperty_CheckBox(" .. name .. ", " .. tostring(value) .. ")")
	return true
end

function _M:onChildren_CheckBox(obj, name, c)
	local opts = self.opts

	if name == "NormalBackFileData" or name == "PressedBackFileData" or name == "DisableBackFileData" or
			name == "NodeNormalFileData" or name == "NodeDisableFileData" then
		local f, t, p = c["@Path"] or "", resourceType(c["@Type"]), c["@Plist"] or ""
		if #p > 0 then
			self:addTexture(t, p)
		else
			self:addTexture(t, f)
		end
		opts[name] = { f, t, p }
	else
		return self:onChildren_Node(obj, name, c)
	end

	--	print("onChildren_CheckBox(" .. name .. ", " .. tostring(opts[name]) .. ")")
	return true
end

function _M:handleOpts_CheckBox(obj)
	self:handleOpts_Node(obj)

	local opts = self.opts

	if opts.NormalBackFileData then
		self:writef("	self.%s:loadTextureBackGround(\"%s\", _L.getPicType(\"%s\"))\n",opts.Name, tostring(opts.NormalBackFileData[1]), tostring(opts.NormalBackFileData[1]))
	end

	if opts.PressedBackFileData then
		self:writef("	self.%s:loadTextureBackGroundSelected(\"%s\", _L.getPicType(\"%s\"))\n",opts.Name, tostring(opts.PressedBackFileData[1]), tostring(opts.PressedBackFileData[1]))
	end

	if opts.DisableBackFileData then
		self:writef("	self.%s:loadTextureBackGroundDisabled(\"%s\", _L.getPicType(\"%s\"))\n",opts.Name, tostring(opts.DisableBackFileData[1]), tostring(opts.DisableBackFileData[1]))
	end

	if opts.NodeNormalFileData then
		self:writef("	self.%s:loadTextureFrontCross(\"%s\", _L.getPicType(\"%s\"))\n",opts.Name, tostring(opts.NodeNormalFileData[1]), tostring(opts.NodeNormalFileData[1]))
	end

	if opts.NodeDisableFileData then
		self:writef("	self.%s:loadTextureFrontCrossDisabled(\"%s\", _L.getPicType(\"%s\"))\n",opts.Name, tostring(opts.NodeDisableFileData[1]), tostring(opts.NodeDisableFileData[1]))
	end

	if nil ~= opts.CheckedState and obj:isSelected() ~= opts.CheckedState then
		self:writef("	self.%s:setSelected(%s)\n",opts.Name, tostring(opts.CheckedState))
	end

	if nil ~= opts.DisplayState then
		if obj:isBright() ~= opts.DisplayState then
			self:writef("	self.%s:setBright(%s)\n",opts.Name, tostring(opts.DisplayState))
		end

		if obj:isEnabled() ~= opts.DisplayState then
			self:writef("	self.%s:setEnabled(%s)\n",opts.Name, tostring(opts.DisplayState))
		end
	end
	if nil == opts.TouchEnable then
		self:writef("	self.%s:setEnabled(false)\n",opts.Name)
	end

	self:write("	_L.setCheckBoxHandler(self, self.".. opts.Name .. [[, "]] .. opts.Name .. [[")]] .. "\n")
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_Sprite(obj, name, value)
	-- nothing to do
	return self:onProperty_Node(obj, name, value)
end

function _M:onChildren_Sprite(obj, name, c)
	local opts = self.opts

	if name == "BlendFunc" then
		opts[name] = { tonumber(c["@Src"]) or 0, tonumber(c["@Dst"]) or 0 }
	else
		return self:onChildren_Node(obj, name, c)
	end

	--	print("onChildren_Sprite(" .. name .. ", " .. tostring(opts[name]) .. ")")
	return true
end

function _M:handleOpts_Sprite(obj)
	self:handleOpts_Node(obj)
	local opts = self.opts

	if opts.FileData then
		print("opts.FileData[3]", opts.FileData[3], type(opts.FileData[3]))
		self:writef("	Util:loadTextureForSprite(self.%s, \"%s\")\n", opts.Name, opts.FileData[1])
	end

	if opts.BlendFunc then
		-- TODO
		if not(opts.BlendFunc[1] == 1 and opts.BlendFunc[2] == 771) then

			self:writef("	self.%s:setBlendFunc({src = %d, dst = %d})\n", opts.Name, opts.BlendFunc[1], opts.BlendFunc[2])
		end
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_Particle(obj, name, value)
	-- nothing to do
	return self:onProperty_Node(obj, name, value)
end

function _M:onChildren_Particle(obj, name, c)
	local opts = self.opts

	if name == "FileData" then
		-- nothing to do(done in objScriptOf())
	elseif name == "BlendFunc" then
		opts[name] = { tonumber(c["@Src"]) or 0, tonumber(c["@Dst"]) or 0 }
	else
		return self:onChildren_Node(obj, name, c)
	end

	--	print("onChildren_Particle(" .. name .. ", " .. tostring(opts[name]) .. ")")
	return true
end

function _M:handleOpts_Particle(obj)
	self:handleOpts_Node(obj)

	local opts = self.opts

	if opts.FileData then
		-- nothing to do(done in objScriptOf())
	end

	if opts.BlendFunc then
		-- TODO
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_TMXTiledMap(obj, name, value)
	-- nothing to do
	return self:onProperty_Node(obj, name, value)
end

function _M:onChildren_TMXTiledMap(obj, name, c)
	local opts = self.opts

	if name == "FileData" then
		-- nothing to do(done in objScriptOf())
	else
		return self:onChildren_Node(obj, name, c)
	end

	--	print("onChildren_TMXTiledMap(" .. name .. ", " .. tostring(opts[name]) .. ")")
	return true
end

function _M:handleOpts_TMXTiledMap(obj)
	self:handleOpts_Node(obj)

	local opts = self.opts

	if opts.FileData then
		-- nothing to do(done in objScriptOf())
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_ProjectNode(obj, name, value)
	-- nothing to do
	return self:onProperty_Node(obj, name, value)
end

function _M:onChildren_ProjectNode(obj, name, c)
	local opts = self.opts

	if name == "FileData" then
		-- nothing to do(done in objScriptOf())
	else
		return self:onChildren_Node(obj, name, c)
	end

	--	print("onChildren_ProjectNode(" .. name .. ", " .. tostring(opts[name]) .. ")")
	return true
end

function _M:handleOpts_ProjectNode(obj)
	self:handleOpts_Node(obj)

	local opts = self.opts

	if opts.FileData then
		-- nothing to do(done in objScriptOf())
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_Armature(obj, name, value)
	local opts = self.opts

	if name == "IsLoop" or name == "IsAutoPlay" then
		opts[name] = (value == "True")
	elseif name == "CurrentAnimationName" then
		opts[name] = value
	else
		return self:onProperty_Node(obj, name, value)
	end

	--	print("onProperty_Armature(" .. name .. ", " .. tostring(value) .. ")")
	return true
end

function _M:onChildren_Armature(obj, name, c)
	local opts = self.opts

	if name == "FileData" then
		opts["ArmatureFileInfo"] = c["@Path"]
	else
		return self:onChildren_Node(obj, name, c)
	end

	--	print("onChildren_Armature(" .. name .. ", " .. tostring(opts[name]) .. ")")
	return true
end

function _M:handleOpts_Armature(obj)
	self:handleOpts_Node(obj)

	local opts = self.opts

	if opts.ArmatureFileInfo then
		self:writef("	ccsam:addArmatureFileInfo(\"%s\")\n", opts.ArmatureFileInfo)
	end

	self:write("	self.".. opts.Name .. ":init(\"DemoPlayer\")\n")

	if opts.CurrentAnimationName then
		local loop = 0
		if opts.IsLoop then loop = 1 end
		if opts.IsAutoPlay then
			self:writef("	self.".. opts.Name .. ":getAnimation():play(\"%s\", -1, %d)\n", opts.CurrentAnimationName, loop)
		else
			self:writef("	self.".. opts.Name .. ":getAnimation():play(\"%s\")\n", opts.CurrentAnimationName)
			self:write("	self.".. opts.Name .. ":getAnimation():gotoAndPause(0)\n")
		end
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_Slider(obj, name, value)
	local opts = self.opts

	if name == "PercentInfo" then
		opts["Percent"] = tonumber(value) or 0
	else
		return self:onProperty_Node(obj, name, value)
	end

	--	print("onProperty_Slider(" .. name .. ", " .. tostring(value) .. ")")
	return true
end

function _M:onChildren_Slider(obj, name, c)
	local opts = self.opts

	if name == "BackGroundData" or name == "ProgressBarData" or
			name == "BallNormalData" or name == "BallPressedData" or name == "BallDisabledData" then
		local f, t, p = c["@Path"] or "", resourceType(c["@Type"]), c["@Plist"] or ""
		if #p > 0 then
			self:addTexture(t, p)
		else
			self:addTexture(t, f)
		end
		opts[name] = { f, t, p }
	else
		return self:onChildren_Node(obj, name, c)
	end

	--	print("onChildren_Slider(" .. name .. ", " .. tostring(opts[name]) .. ")")
	return true
end

function _M:handleOpts_Slider(obj)
	self:handleOpts_Node(obj)

	local opts = self.opts

	self:writef("	self.%s:ignoreContentAdaptWithSize(false)\n", opts.Name)

	if opts.Percent and obj:getPercent() ~= opts.Percent then
		self:writef("	self.%s:setPercent(%s)\n",opts.Name, tostring(opts.Percent))
	end

	if opts.BackGroundData then
		self:writef("	self.%s:loadBarTexture(\"%s\", _L.getPicType(\"%s\"))\n",opts.Name, tostring(opts.BackGroundData[1]), tostring(opts.BackGroundData[1]))
	end

	if opts.BallNormalData then
		self:writef("	self.%s:loadSlidBallTextureNormal(\"%s\", _L.getPicType(\"%s\"))\n",opts.Name, tostring(opts.BallNormalData[1]), tostring(opts.BallNormalData[1]))
	end

	if opts.BallPressedData then
		self:writef("	self.%s:loadSlidBallTexturePressed(\"%s\", _L.getPicType(\"%s\"))\n",opts.Name, tostring(opts.BallPressedData[1]), tostring(opts.BallPressedData[1]))
	end

	if opts.BallDisabledData then
		self:writef("	self.%s:loadSlidBallTextureDisabled(\"%s\", _L.getPicType(\"%s\"))\n",opts.Name, tostring(opts.BallDisabledData[1]), tostring(opts.BallDisabledData[1]))
	end

	if opts.ProgressBarData then
		self:writef("	self.%s:loadProgressBarTexture(\"%s\", _L.getPicType(\"%s\"))\n",opts.Name, tostring(opts.ProgressBarData[1]), tostring(opts.ProgressBarData[1]))
	end

	if nil ~= opts.DisplayState then
		if obj:isBright() ~= opts.DisplayState then
			self:writef("	self.%s:setBright(%s)\n",opts.Name, tostring(opts.DisplayState))
		end

		if obj:isEnabled() ~= opts.DisplayState then
			self:writef("	self.%s:setEnabled(%s)\n",opts.Name, tostring(opts.DisplayState))
		end
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_LoadingBar(obj, name, value)
	local opts = self.opts

	if name == "ProgressInfo" then
		opts["Percent"] = tonumber(value) or 0
	elseif name == "ProgressType" then
		if value == "Left_To_Right" then
			opts["Direction"] = 0
		else
			opts["Direction"] = 1
		end
	else
		return self:onProperty_Node(obj, name, value)
	end

	--	print("onProperty_Slider(" .. name .. ", " .. tostring(value) .. ")")
	return true
end

function _M:onChildren_LoadingBar(obj, name, c)
	local opts = self.opts

	if name == "ImageFileData" then
		local f, t, p = c["@Path"] or "", resourceType(c["@Type"]), c["@Plist"] or ""
		if #p > 0 then
			self:addTexture(t, p)
		else
			self:addTexture(t, f)
		end
		local resType = 0
		if c["@Plist"] and c["@Plist"] ~= "" then resType = 1 end
		opts[name] = { f, t, resType }
	else
		return self:onChildren_Node(obj, name, c)
	end

	return true
end

function _M:handleOpts_LoadingBar(obj)
	self:handleOpts_Node(obj)

	local opts = self.opts

	if opts.Percent and obj:getPercent() ~= opts.Percent then
		self:writef("	self.%s:setPercent(%s)\n", opts.Name, tostring(opts.Percent))
	end

	if opts.Direction and obj:getDirection() ~= opts.Direction then
		self:writef("	self.%s:setDirection(%s)\n", opts.Name, tostring(opts.Direction))
	end
	self:writef("	self.%s:ignoreContentAdaptWithSize(false)\n", opts.Name)
	if opts.ImageFileData then
		self:writef("	self.%s:loadTexture(\"%s\", _L.getPicType(\"%s\"))\n", opts.Name, tostring(opts.ImageFileData[1]), tostring(opts.ImageFileData[1]))
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_Layout(obj, name, value)
	local opts = self.opts

	if name == "ClipAble" then
		opts["ClippingEnabled"] = (value == "True")
	elseif name == "ComboBoxIndex" then
		opts["BackGroundColorType"] = tonumber(value) or 0
	elseif name == "BackColorAlpha" then
		opts["BackGroundColorOpacity"] = tonumber(value) or 255
	else
		return self:onProperty_Node(obj, name, value)
	end

	--	print("onProperty_Layout(" .. name .. ", " .. value .. ")")
	return true
end

function _M:onChildren_Layout(obj, name, c)
	local opts = self.opts

	if name == "SingleColor" or name == "FirstColor" or name == "EndColor" then
		opts[name] = {
			tonumber(c["@R"]) or 0, tonumber(c["@G"]) or 0,
			tonumber(c["@B"]) or 0, tonumber(c["@A"])
		}
	elseif name == "ColorVector" then
		opts[name] = { tonumber(c["@ScaleX"]) or 0, tonumber(c["@ScaleY"]) or 1 }
	elseif name == "Size" and opts.Scale9Enabled then
		opts["Scale9Size"] = { tonumber(c["@X"]) or 0, tonumber(c["@Y"]) or 0 }
		opts["Size"] = { tonumber(c["@X"]) or 0, tonumber(c["@Y"]) or 0 }
	else
		return self:onChildren_Node(obj, name, c)
	end

	return true
end

function _M:handleOpts_Layout(obj)
	self:handleOpts_Node(obj)

	local opts = self.opts

	if opts.FileData then
		if opts.Scale9Enabled then
			print("find layout has Scale9Enabled", opts.Name)
			local capInsets = string.format("cc.rect(%s, %s, %s, %s)",
				tostring(opts.Scale9OriginX or 0), tostring(opts.Scale9OriginY or 0),
				tostring(opts.Scale9Width or 0), tostring(opts.Scale9Height or 0))
			local imgType = 1
			if opts.FileData[3] == "" then
				imgType = 0
			end
			self:writef("	setBgImage(self.%s, \"%s\", %s, true, %s)\n", opts.Name, tostring(opts.FileData[1]), imgType, capInsets)

			if opts.Scale9Size then
				self:writef("	self.%s:setContentSize(%s)\n", opts.Name, util:formatSize(opts.Scale9Size))
			end
		else
			if opts.FileData[3] == "" then
				self:writef("	self.%s:setBackGroundImage(\"%s\", %s)\n", opts.Name, tostring(opts.FileData[1]), 0)
			else
				self:writef("	self.%s:setBackGroundImage(\"%s\", %s)\n", opts.Name, tostring(opts.FileData[1]), 1)
			end

		end
	end
	print("对于scrollview",opts.ClippingEnabled, obj:isClippingEnabled())
	if nil ~= opts.ClippingEnabled and obj:isClippingEnabled() ~= opts.ClippingEnabled then
		self:write("	self.".. opts.Name .. ":setClippingEnabled(" .. tostring(opts.ClippingEnabled) .. ")\n")
	end

	if nil ~= opts.BackGroundColorType and opts.BackGroundColorType ~= 0 then
		local bgType, bgOpacity, bgColor, startColor, endColor, colorVec

		-- if obj:getBackGroundColorType() ~= opts.BackGroundColorType then
			bgType = opts.BackGroundColorType
		-- end

		if opts.BackGroundColorType == 1 and opts.SingleColor and
			not util:isColorEqual(obj:getBackGroundColor(), opts.SingleColor) then
			bgColor = opts.SingleColor
		end

		if opts.BackGroundColorType == 2 and opts.FirstColor and opts.EndColor then
			startColor = opts.FirstColor
			endColor = opts.EndColor
		end

		if opts.BackGroundColorType == 2 and opts.ColorVector then
			colorVec = opts.ColorVector
		end

		if opts.BackGroundColorOpacity then
			bgOpacity = opts.BackGroundColorOpacity
		end

		self:writef("	setBgColor(self.%s, %s, %s, %s, %s, %s, %s)\n",
			opts.Name, tostring(bgType), tostring(bgOpacity), util:formatColor(bgColor), util:formatColor(startColor), util:formatColor(endColor), util:formatPoint(colorVec))
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_ScrollView(obj, name, value)
	local opts = self.opts

	if name == "ScrollDirectionType" then
		if value == "Vertical" then
			opts["ScrollDirection"] = 1
		elseif value == "Horizontal" then
			opts["ScrollDirection"] = 2
		elseif value == "Vertical_Horizontal" then
			opts["ScrollDirection"] = 3
		else
			opts["ScrollDirection"] = tonumber(value) or 0
		end
	elseif name == "IsBounceEnabled" then
		opts["BounceEnabled"] = (value == "True")
	else
		return self:onProperty_Layout(obj, name, value)
	end

	--	print("onProperty_ScrollView(" .. name .. ", " .. value .. ")")
	return true
end

function _M:onChildren_ScrollView(obj, name, c)
	local opts = self.opts

	if name == "InnerNodeSize" then
		opts["InnerContainerSize"] = { tonumber(c["@Width"]) or 0, tonumber(c["@Height"]) or 0 }
	else
		return self:onChildren_Layout(obj, name, c)
	end

	return true
end

function _M:handleOpts_ScrollView(obj)
	if not self.opts.ClippingEnabled then self.opts.ClippingEnabled = false end
	self:handleOpts_Layout(obj)

	local opts = self.opts

	if opts.InnerContainerSize and not util:isSizeEqual(obj:getInnerContainerSize(), opts.InnerContainerSize) then
		self:writef("	self.%s:setInnerContainerSize(%s)\n", opts.Name, util:formatSize(opts.InnerContainerSize))
	end

	if opts.ScrollDirection and obj:getDirection() ~= opts.ScrollDirection then
		self:writef("	self.%s:setDirection(%s)\n", opts.Name, tostring(opts.ScrollDirection))
	end

	if nil ~= opts.BounceEnabled and obj:isBounceEnabled() ~= opts.BounceEnabled then
		self:writef("	self.%s:setBounceEnabled(%s)\n", opts.Name, tostring(opts.BounceEnabled))
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_ListView(obj, name, value)
	local opts = self.opts

	if name == "ItemMargin" then
		opts["ItemsMargin"] = tonumber(value) or 0
	elseif name == "DirectionType" then
		opts["Gravity"] = value
	elseif name == "VerticalType" then
		if value == "" then
			opts[name] = 3
		elseif value == "Align_Bottom" then
			opts[name] = 4
		elseif value == "Align_VerticalCenter" then
			opts[name] = 5
		else
			opts[name] = tonumber(value) or 3
		end
	elseif name == "HorizontalType" then
		if value == "" then
			opts[name] = 0
		elseif value == "Align_Right" then
			opts[name] = 1
		elseif value == "Align_HorizontalCenter" then
			opts[name] = 2
		else
			opts[name] = tonumber(value) or 0
		end
	else
		return self:onProperty_ScrollView(obj, name, value)
	end

	--	print("onProperty_ListView(" .. name .. ", " .. value .. ")")
	return true
end

function _M:onChildren_ListView(obj, name, c)
	-- nothing to do
	return self:onChildren_ScrollView(obj, name, c)
end

function _M:handleOpts_ListView(obj)
	local opts = self.opts
	opts.ScrollDirection = nil

	self:handleOpts_ScrollView(obj)

	if opts.ItemsMargin and obj:getItemsMargin() ~= opts.ItemsMargin then
		self:writef("	self.".. opts.Name .. ":setItemsMargin(%d)\n", tonumber(opts.ItemsMargin) or 0)
	end

	if opts.VerticalType or opts.HorizontalType then
		if nil == opts.Gravity or opts.Gravity == "" then
			self:write("	self.".. opts.Name .. ":setDirection(2)\n")
			self:writef("	self.".. opts.Name .. ":setGravity(%d)\n", tonumber(opts.VerticalType) or 0)
		elseif opts.Gravity == "Vertical" then
			self:write("	self.".. opts.Name .. ":setDirection(1)\n")
			self:writef("	self.".. opts.Name .. ":setGravity(%d)\n", tonumber(opts.HorizontalType) or 0)
		end
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:onProperty_PageView(obj, name, value)
	local opts = self.opts

	if name == "ScrollDirectionType" then
		-- nothing to do
	else
		return self:onProperty_Layout(obj, name, value)
	end

	--	print("onProperty_PageView(" .. name .. ", " .. value .. ")")
	return true
end

function _M:onChildren_PageView(obj, name, c)
	-- nothing to do
	return self:onChildren_Layout(obj, name, c)
end

function _M:handleOpts_PageView(obj)
	self:handleOpts_Layout(obj)
	-- nothing to do
end

--/////////////////////////////////////////////////////////////////////////////
function _M:readNodeProperties(root, obj, className)
	--	print("readNodeProperties(" .. className .. ")")

	local opts = self.opts
	local lays = self.lays

	local onProperty = self["onProperty_" .. className] or self.onProperty_Node

	for _, p in pairs(root:properties()) do
		local name = p.name
		local value = p.value

		if not onProperty(self, obj, name, value) then
			if name ~= "IconVisible" and name ~= "ctype" and name ~= "ActionTag" and name ~= "ColorAngle" and name ~= "CanEdit" and
					name ~= "LeftEage" and name ~= "TopEage" and name ~= "RightEage" and name ~= "BottomEage" then
				print("@@ Nothing to do: readNodeProperties(" .. name .. " @" .. className .. ")")
			end
		end
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:readNodeChildren(root, obj, className)
	local onChildren = self["onChildren_" .. className] or self.onChildren_Node

	for _, c in pairs(root:children()) do
		local name = c:name()

		if not onChildren(self, obj, name, c) then
			if name ~= "Children" then
				print("@@ Nothing to do: readNodeChildren(" .. name .. " @" .. className .. ")")
			end
		end
	end
end

--/////////////////////////////////////////////////////////////////////////////
function _M:handleNodeOpts(root, obj, className)
	local handleOpts = self["handleOpts_" .. className] or self.handleOpts_Node

	local opts = self.opts
	local lays = self.lays

	if type(obj.ignoreContentAdaptWithSize) == "function" then
		if (opts.IsCustomSize or lays.PercentWidthEnabled or lays.PercentHeightEnabled or opts.Scale9Enabled)
				and obj:isIgnoreContentAdaptWithSize() then
			opts["IgnoreContentAdaptWithSize"] = false
		end
	end

	handleOpts(self, obj)
end

--/////////////////////////////////////////////////////////////////////////////
function _M:handleNodeLays(root, obj, className)
	local lays = self.lays

	local lay = obj:getComponent("__ui_layout") or ccui.Layout:create()

	for name, value in pairs(lays) do
		if ((type(lay["get" .. name]) == "function" and lay["get" .. name](lay) == value) or
				(type(lay["is" .. name]) == "function" and lay["is" .. name](lay) == value)) then
			lays[name] = nil
		end
	end

	local margins, sizes, positions, stretchs, edges = "", "", "", "", ""
	if nil ~= lays.LeftMargin or nil ~= lays.TopMargin or
			nil ~= lays.RightMargin or nil ~= lays.BottomMargin then
		margins = string.format(".setMargin(%s, %s, %s, %s)",
			tostring(lays.LeftMargin), tostring(lays.TopMargin),
			tostring(lays.RightMargin), tostring(lays.BottomMargin))
	end
	if (nil ~= lays.PercentWidth or nil ~= lays.PercentHeight) and
			(nil ~= lays.PercentWidthEnabled or nil ~= lays.PercentHeightEnabled) then
		sizes = string.format(".setSize(%s, %s, %s, %s)",
			tostring(lays.PercentWidth), tostring(lays.PercentHeight),
			tostring(lays.PercentWidthEnabled), tostring(lays.PercentHeightEnabled))
	end
	if (nil ~= lays.PositionPercentX or nil ~= lays.PositionPercentY) and
			(nil ~= lays.PositionPercentXEnabled or nil ~= lays.PositionPercentYEnabled) then
		positions = string.format(".setPosition(%s, %s, %s, %s)",
			tostring(lays.PositionPercentX), tostring(lays.PositionPercentY),
			tostring(lays.PositionPercentXEnabled), tostring(lays.PositionPercentYEnabled))
	end
	if nil ~= lays.StretchWidthEnable or nil ~= lays.StretchHeightEnable then
		stretchs = string.format(".setStretch(%s, %s)",
			tostring(lays.StretchWidthEnable), tostring(lays.StretchHeightEnable))
	end
	if nil ~= lays.HorizontalEdge or nil ~= lays.VerticalEdge then
		edges = string.format(".setEdge(%s, %s)",
			tostring(lays.HorizontalEdge), tostring(lays.VerticalEdge))
	end

	-- if #margins > 0 or #sizes > 0 or #positions > 0 or #stretchs > 0 or #edges > 0 then
	-- 	self:writef("	bind(obj)%s%s%s%s%s\n", margins, sizes, positions, stretchs, edges)
	-- end
end

-- 解析一个节点的各个属性
function _M:parseNodeXml(root, obj, className)

	self.opts = {}
	self.lays = {}

	self:readNodeProperties(root, obj, className)
	self:readNodeChildren(root, obj, className)

	self:handleNodeOpts(root, obj, className)
	self:handleNodeLays(root, obj, className)
end

--/////////////////////////////////////////////////////////////////////////////
local _createNodeTree = nil
_createNodeTree = function(self, root, classType, rootName, rootClassName)
	local pos = string.find(classType, "ObjectData")
	if pos then
		classType = string.sub(classType, 1, pos - 1)
	end

	local obj, script, className = NodeGenerater:gen(classType, root)
	print("script 1:", script)
	if not obj or not script then return end

	if root["@ActionTag"] then
		self.actionTagTable[root["@ActionTag"]] = root["@Name"]
	end
	-- 写入生成脚本
	self:write(script)
	-- 解析所有属性
	self:parseNodeXml(root, obj, className)
	-- 不同的父节点有不同的添加方式，普通node就是addchild
	if rootName then
		if rootClassName == "PageView" and className == "Layout" then
			self:write("	" .. rootName .. ":addPage(obj)\n")
		else
			self:write("	addChildForPre(self." .. rootName .. ", self." .. root["@Name"] .. ", self)\n")
		end
	else
		self:write("	self:addChild(self." .. root["@Name"] .. ")\n 	self.uiRootNode = self.".. root["@Name"] .. "\n")
	end

	-- 本节点的类名就是下层节点的父节点类名
	rootClassName = className

	-- 处理下层子节点
	if root.Children then
		local nextSiblingNode = nextSiblingIter(root.Children)
		local node, udata = nextSiblingNode()

		while node do
			className = node["@ctype"] or "NodeObjectData"
			udata = node["@UserData"]
			if udata then
				local pos = string.find(udata, "@class_", 1, true)
				if pos then
					className = string.sub(udata, pos + 7) -- .. "ObjectData"
				end
			end
			_createNodeTree(self, node, className, root["@Name"], rootClassName)
			node = nextSiblingNode()
		end
	else
		self:write("\n")
	end
end

-- 创建节点树
function _M:createNodeTree(root, classType)
	self.actionTagTable = {}
	return _createNodeTree(self, root, classType)
end

-- 写文件 普通字符串
function _M:write(s)
	self._file:write(s)
end

-- 写文件 带格式的
function _M:writef(fmt, ...)
	self:write(string.format(fmt, ...))
end

--/////////////////////////////////////////////////////////////////////////////
function _M:addTexture(t, texture)
	if not _ADD_TEXTURES_PLIST then
		return
	end

	if not self._textures then
		self._textures = {}
	end
	for _, value in pairs(self._textures) do
		if value == texture then return end
	end
	-- table.insert(self._textures, texture)
	-- if t == 1 then
	-- 	self:write("	ccspc:addSpriteFrames(\"" .. texture .. "\")\n")
	-- end

	-- add plist file @alter sheng.guo
	local needCheckName = {"ccs/animation/", "ccs/uiPic/", "ccs/batPic/", "ccs/battlePic/"}
	for i,v in ipairs(needCheckName) do
		if string.find(texture, v) == 1 then
	        local startIdx, endIdx, keyName = string.find(texture, "(.-/.-/.-)/")
	        local plistName = keyName .. ".plist"
	        for ii,vv in ipairs(self._textures) do
	        	if plistName == vv then
	        		return
	        	end
	        end

	        table.insert(self._textures, plistName)
			return
		end
	end
end
function _M:createAnimationList( node, tblAni )
	print("_M:createAnimationList")
	local nextSiblingNode = nextSiblingIter(node)
	local animationListNode = nextSiblingNode()
	-- 遍历所有的timeline
	while animationListNode do
		print("animationListNode", animationListNode:name())
		table.insert(tblAni, "	self.animation:addAnimationInfo({name=\"" .. animationListNode["@Name"] .. "\", startIndex=" .. animationListNode["@StartIndex"] .. ", endIndex=" .. animationListNode["@EndIndex"] .. "})\n")
		animationListNode = nextSiblingNode()
	end
end
-- 创建ccs动画 总Animation
-- @param node <Animation>节点
function _M:createAnimation(node, tblAni)
	print("_M:createAnimation")
	local nextSiblingNode = nextSiblingIter(node)
	local timeLineNode = nextSiblingNode()
	-- 遍历所有的timeline
	while timeLineNode do
		table.insert(tblAni, "	timeLine = ccs.Timeline:create()\n")
		table.insert(tblAni, "	self.animation:addTimeline(timeLine)\n")
		self:createTimeline(timeLineNode, tblAni)
		table.insert(tblAni, "	timeLine:setNode(<ActionTag>".. timeLineNode["@ActionTag"] .. "</ActionTag>)\n")
		timeLineNode = nextSiblingNode()
	end
end
-- 创建ccs动画 一个timeline
-- @param node <Timeline>节点
function _M:createTimeline(node, tblAni)
	print("_M:createTimeline")
	local nextSiblingNode = nextSiblingIter(node)
	local frameNode = nextSiblingNode()
	-- 遍历所有的frame
	while frameNode do
		print(node["@Property"],node["@Property"],self["createFrame_".. node["@Property"]])
		table.insert(tblAni, "	timeLine:addFrame(" .. self["createFrame_".. node["@Property"]](self, frameNode) .. ")\n")

		-- print(node["@Property"])
		frameNode = nextSiblingNode()
	end
end
-- 创建一个ccs动画，一个PositionFrame
function _M:createFrame_Position(node)
	return string.format("CreatePositionFrame(%s, %s, %s, %s, nil)", node["@FrameIndex"], string.lower(node["@Tween"] or "true"), node["@X"], node["@Y"])
end
-- 创建一个ccs动画，一个VisibleFrame
function _M:createFrame_VisibleForFrame(node)
	return string.format("CreateVisibleFrame(%s, %s, %s, nil)", node["@FrameIndex"], string.lower(node["@Tween"] or "true"), string.lower(node["@Value"]))
end
-- 创建一个ccs动画，一个ColorFrame
function _M:createFrame_CColor(node)
	return string.format("CreateColorFrame(%s, %s, cc.c3b(%s,%s,%s, %s), nil)", node["@FrameIndex"], string.lower(node["@Tween"] or "true"), node.Color["@R"], node.Color["@G"], node.Color["@B"], node["@Alpha"])
end
-- 创建一个ccs动画，一个FrameEvent
function _M:createFrame_FrameEvent(node)
	return string.format("CreateEventFrame(%s, %s, \"%s\", nil)", node["@FrameIndex"], string.lower(node["@Tween"] or "true"), node["@Value"])
end
-- 创建一个ccs动画，一个ScaleFrame
function _M:createFrame_Scale(node)
	return string.format("CreateScaleFrame(%s, %s, %s, %s, nil)", node["@FrameIndex"], string.lower(node["@Tween"] or "true"), node["@X"], node["@Y"])
end
-- 创建一个ccs动画，一个RotationSkewFrame
function _M:createFrame_RotationSkew(node)
	return string.format("CreateRotationSkewFrame(%s, %s, %s, %s, nil)", node["@FrameIndex"], string.lower(node["@Tween"] or "true"), node["@X"], node["@Y"])
end
-- 创建一个ccs动画，一个TextureFrame
function _M:createFrame_FileData(node)
	return string.format("CreateTextureFrame(%s, %s, \"%s\", nil)", node["@FrameIndex"], string.lower(node["@Tween"] or "true"), node.TextureFile["@Path"])
end
-- 创建一个ccs动画，一个AlphaFrame
function _M:createFrame_Alpha(node)
	return string.format("_L.CreateAlphaFrame(%s, %s, \"%s\", nil)", node["@FrameIndex"], string.lower(node["@Tween"] or "true"), node["@Value"])
end
--/////////////////////////////////////////////////////////////////////////////
function _M:csd2lua(csdFile, luaFile)

	-- 存放节点名字的table(用来检测重名)
	nameTable = {}
	currentCsd = csdFile

	local xml = require("ccext.XmlParser").newParser():loadFile(csdFile)

	if not xml or xml:numChildren() ~= 1 then
		error("XmlParser:loadFile(" .. csdFile .. ") bad XML.")
		return
	end

	local nextSiblingNode = nextSiblingIter(xml:children()[1])
	local node, name, serializeEnabled = nextSiblingNode(), nil, false
	while node do
		name = node:name()
		if name == "PropertyGroup" then
			self._csdVersion = node["@Version"] or "2.1.0.0"
		elseif name == "Content" and node:numProperties() == 0 then
			serializeEnabled = true
			break
		end

		if node:numChildren() > 0 then
			nextSiblingNode = nextSiblingIter(node)
			node = nextSiblingNode()
		else
			node = nextSiblingNode()
		end
	end

	if not serializeEnabled then
		error("serializeEnabled == false")
		return
	end
	local file, err = io.open(luaFile, "w+");

	if file and not err then
		self._file = file
	else
		print(err)
		return
	end

	self:write(_SCRIPT_HELPER)
	self:write(string.format(_SCRIPT_HEAD, self._csdVersion or ""))
	self:write(_CREATE_FUNC_HEAD)

	local tblAni = {}
	print("node name = ", node:name())
	nextSiblingNode = nextSiblingIter(node)
	node = nextSiblingNode()
	while node do
		name = node:name()
		print("zzz2", name)
		if name == "Animation" then
			table.insert(tblAni, "	self.animation = ccs.ActionTimeline:create()\n")
			table.insert(tblAni, string.format("	self.animation:setDuration(%d)\n", tonumber(node["@Duration"]) or 0))
			-- print([[tonumber(node["@Speed"])]], tonumber(node["@Speed"]))
			table.insert(tblAni, "	self.animation:setTimeSpeed(" .. util:fixFloat(tonumber(node["@Speed"]) or 1) .. ")\n")
			table.insert(tblAni, "	local timeLine\n")
			-- 创建动画
			self:createAnimation(node, tblAni)
		elseif name == "ObjectData" then
			self:createNodeTree(node, "NodeObjectData")
		elseif name == "AnimationList" then
			self:createAnimationList(node, tblAni)
		end

		node = nextSiblingNode()
	end

	if #tblAni > 0 then
		for i=1,#tblAni do
			local startActionTagIndex = string.find(tblAni[i], "<ActionTag>")
			local endActionTagIndex = string.find(tblAni[i], "</ActionTag>")
			if startActionTagIndex and endActionTagIndex then
				local actionTag = string.sub(tblAni[i], startActionTagIndex +11, endActionTagIndex -1)
				print("find actionTag", actionTag)
				tblAni[i] = string.sub(tblAni[i], 1, startActionTagIndex - 1)
					.. "self."
					.. self.actionTagTable[actionTag]
					.. string.sub(tblAni[i], endActionTagIndex + 12)
				print(tblAni[i])
			end
		end
		self:write(table.concat(tblAni))
	end

	self:write(_CREATE_FUNC_FOOT)

	if _ADD_TEXTURES_PLIST then
		self:write("\n")
		self:write("_M.textures = {\n")
		for _, v in pairs(self._textures or {}) do
			self:write("	\"" .. v .. "\",\n")
		end
		self:write("}\n")
	end

	self:write(_SCRIPT_FOOT)

	io.close(file)
end

--/////////////////////////////////////////////////////////////////////////////

return _M
