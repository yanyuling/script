local util = require("ccext.util")
--[[
节点生成器
用来生成节点，以及产生生成节点的脚本
@author 赵占涛
]]
local NodeGenerater = {}
function NodeGenerater:gen(className, root)
		local obj, script = nil, nil
	local nodeName = root["@Name"]
	if className == "ProjectNode" then
		local fileData = root["FileData"]
		if fileData and fileData["@Path"] then
			local path = string.gsub(fileData["@Path"], ".csd", ".lua")
			local tmpSplit = util:Split(path, "/")
			local uiClassName = tmpSplit[#tmpSplit]
			uiClassName = string.gsub(uiClassName, ".lua", "")
			obj = cc.Node:create()
			script = string.format("	if "..uiClassName.." then \n 		self."..nodeName.." = "..uiClassName..".new() \n 	else \n		self."..nodeName.." = BaseUi.new(\"%s\")\n 	end \n", path, path)
		end
	elseif className == "GameNode" or className == "SingleNode" or className == "Node" then
		obj = cc.Node:create()
		script = "	self."..nodeName.." = cc.Node:create()\n"
	elseif className == "Panel" or className == "Layout" then
		className = "Layout"
		obj = ccui.Layout:create()
		script = "	self."..nodeName.." = ccui.Layout:create()\n"
		-- script = "	obj = cc.Node:create()\n"
	elseif className == "TextButton" or className == "Button" then
		className = "Button"
		obj = ccui.Button:create()
		script = "	self."..nodeName.." = ccui.Button:create()\n"
	elseif className == "TextArea" or className == "Text" or className == "Label" then
		className = "Text"
		obj = ccui.Text:create()
		script = "	self."..nodeName.." = ccui.Text:create()\n"
	elseif className == "ImageView" then
		obj = ccui.ImageView:create()
		script = "	self."..nodeName.." = ccui.ImageView:create()\n"
	elseif className == "EditBox" then
		local c, siz = root["Size"], { 100, 32 }
		if c then
			siz = { tonumber(c["@X"]) or 0, tonumber(c["@Y"]) or 0 }
		end

		obj = ccui.EditBox:create(cc.size(siz[1], siz[2]), cc.Scale9Sprite:create())
		script = "	self."..nodeName.." = ccui.EditBox:create(" .. util:formatSize(siz) .. ", cc.Scale9Sprite:create())\n"
	elseif className == "TextField" then
		obj = ccui.TextField:create()
		script = "	self."..nodeName.." = ccui.TextField:create()\n"
	elseif className == "LabelAtlas" or className == "TextAtlas" then
		className = "TextAtlas"
		obj = ccui.TextAtlas:create()
		script = "	self."..nodeName.." = ccui.TextAtlas:create()\n"
	elseif className == "LabelBMFont" or className == "TextBMFont" then
		className = "TextBMFont"
		obj = ccui.TextBMFont:create()
		script = "	self."..nodeName.." = ccui.TextBMFont:create()\n"
	elseif className == "Slider" then
		obj = ccui.Slider:create()
		script = "	self."..nodeName.." = ccui.Slider:create()\n"
	elseif className == "LoadingBar" then
		obj = ccui.LoadingBar:create()
		script = "	self."..nodeName.." = ccui.LoadingBar:create()\n"
	elseif className == "Sprite" then
		obj = cc.Sprite:create()
		script = "	self."..nodeName.." = cc.Sprite:create()\n"
	elseif className == "CheckBox" then
		obj = ccui.CheckBox:create()
		script = "	self."..nodeName.." = ccui.CheckBox:create()\n"
	elseif className == "ScrollView" then
		obj = ccui.ScrollView:create()
		script = "	self."..nodeName.." = ccui.ScrollView:create()\n"
	elseif className == "ListView" then
		obj = ccui.ListView:create()
		script = "	self."..nodeName.." = ccui.ListView:create()\n"
	elseif className == "PageView" then
		obj = ccui.PageView:create()
		script = "	self."..nodeName.." = ccui.PageView:create()\n"
	elseif className == "Particle" then
		local fileData = root["FileData"]
		if fileData and fileData["@Path"] then
			obj = cc.ParticleSystemQuad:create()
			script = string.format("	self."..nodeName.." = cc.ParticleSystemQuad:create(\"%s\")\n 	self."..nodeName..":setPositionType(2) \n", fileData["@Path"])
		end
	elseif className == "ArmatureNode" then
		className = "Armature"
		obj = ccs.Armature:create()
		script = "	self."..nodeName.." = ccs.Armature:create()\n"
	else
		error("暂不支持的节点类型(如果需要请找赵占涛添加):", className)
	end

	return obj, script, className
end

return NodeGenerater