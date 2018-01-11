
--[[
各种节点默认值
@author 赵占涛
]]
cc = {}
ccui = {}

cc.Node = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0, y=0}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
	}
}
ccui.Layout = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0, y=0}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
		{"getBackGroundColorType",nil},
		{"getBackGroundColor",{r=255, g=255, b=255, a=255}},
		{"getBackGroundColorOpacity",255},
	}
}
ccui.Button = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
		{"getTitleText", ""},
		{"getTitleColor", {r=255, g=255, b=255}},
		{"getTitleFontSize", 0},
		{"getTitleFontName", nil},
		{"ignoreContentAdaptWithSize", nil},
		{"isIgnoreContentAdaptWithSize", true},
	}
}
ccui.Text = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
		{"getTextColor", {r=255, g=255, b=255, a=255}},
		{"ignoreContentAdaptWithSize", nil},
		{"isIgnoreContentAdaptWithSize", true},
		{"getTextVerticalAlignment", 0},
		{"getTextHorizontalAlignment", 0},

	}
}
ccui.ImageView = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
	}
}
ccui.EditBox = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
	}
}
ccui.TextField = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
		{"ignoreContentAdaptWithSize", nil},
		{"isIgnoreContentAdaptWithSize", true},
	}
}
ccui.TextAtlas = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
		{"isIgnoreContentAdaptWithSize", true},
	}
}
ccui.TextBMFont = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
		{"isIgnoreContentAdaptWithSize", true},
	}
}
ccui.Slider = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
		{"getPercent",100},
	}
}
ccui.LoadingBar = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
		{"getPercent",100},
		{"getDirection",0},
	}
}
cc.Sprite = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
	}
}
ccui.CheckBox = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
		{"isSelected",false},
	}
}
ccui.ScrollView = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0, y=0}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",true},
		{"getFontSize",0},
		{"getInnerContainerSize",{width=0, height=0}},
		{"getBackGroundColor",{r=255, g=255, b=255, a=255}},
		{"getDirection",nil},
		{"isBounceEnabled", true}
	}
}
ccui.ListView = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
	}
}
ccui.PageView = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getBackGroundColor",{r=255, g=255, b=255, a=255}},
		{"getFontSize",0},
	}
}
cc.ParticleSystemQuad = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0, y=0}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
	}
}
ccui.Armature = {
	p={
		{"getContentSize",{width=0, height=0}},
		{"getRotationSkewX",0},
		{"getRotationSkewY",0},
		{"isFlippedX",false},
		{"isFlippedY",false},
		{"isVisible",true},
		{"getAnchorPoint",{x=0.5, y=0.5}},
		{"getPosition",{x=0, y=0}},
		{"getColor",{r=255, g=255, b=255, a=255}},
		{"getPositionX",0},
		{"getPositionY",0},
		{"getScaleX",1},
		{"getScaleY",1},
		{"getComponent",nil},
		{"getTag",nil},
		{"getLocalZOrder",nil},
		{"getOpacity",255},
		{"isClippingEnabled",false},
		{"getFontSize",0},
	}
}

for i1,packageName in ipairs({cc, ccui}) do
	for k,v in pairs(packageName) do
		function v:create()
			local obj = {}
			for i2,v2 in ipairs(v.p) do
				obj[v2[1]] = function () return v2[2] end
			end
			return obj
		end
	end
end
