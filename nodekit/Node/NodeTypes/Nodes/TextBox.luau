local VirtualCorners = require("../Virtuals/Corners")
local VirtualScale = require("../Virtuals/Scale")
local VirtualPadding = require("../Virtuals/Padding")

local OnEvent = require("../Funcs/OnEvent")

local TextBox = {}

TextBox.rblxClass = "TextBox"
TextBox.initParams = { "Text" }

TextBox.create = function(self)
	self._instance.Interactable = false
	self._instance.ClearTextOnFocus = false
	self._instance.Text = ""
end

TextBox.properties = {
	readable = {
		"ClearTextOnFocus",
		"ContentText",
		"CursorPosition",
		"Font",
		"FontFace",
		"LineHeight",
		"MaxVisibleGraphemes",
		"MultiLine",
		"OpenTypeFeatures",
		"OpenTypeFeaturesError",
		"PlaceholderColor3",
		"PlaceholderText",
		"RichText",
		"SelectionStart",
		"ShowNativeInput",
		"Text",
		"TextBounds",
		"TextColor",
		"TextColor3",
		"TextDirection",
		"TextEditable",
		"TextFits",
		"TextScaled",
		"TextSize",
		"TextStrokeColor3",
		"TextStrokeTransparency",
		"TextTransparency",
		"TextTruncate",
		"TextWrapped",
		"TextXAlignment",
		"TextYAlignment",
		"Active",
		"AnchorPoint",
		"AutomaticSize",
		"BackgroundColor",
		"BackgroundColor3",
		"BackgroundTransparency",
		"BorderColor",
		"BorderColor3",
		"BorderMode",
		"BorderSizePixel",
		"ClipsDescendants",
		"GuiState",
		"NextSelectionDown",
		"NextSelectionLeft",
		"NextSelectionRight",
		"NextSelectionUp",
		"Position",
		"Rotation",
		"Selectable",
		"SelectionImageObject",
		"SelectionOrder",
		"Size",
		"SizeConstraint",
		"Transparency",
		"Visible",
		"AbsolutePosition",
		"AbsoluteRotation",
		"AbsoluteSize",
		"AutoLocalize",
		"RootLocalizationTable",
		"SelectionBehaviorDown",
		"SelectionBehaviorLeft",
		"SelectionBehaviorRight",
		"SelectionBehaviorUp",
		"SelectionGroup",
	},
	writeable = {
		"ClearTextOnFocus",
		"CursorPosition",
		"Font",
		"FontFace",
		"LineHeight",
		"MaxVisibleGraphemes",
		"MultiLine",
		"OpenTypeFeatures",
		"PlaceholderColor3",
		"PlaceholderText",
		"RichText",
		"SelectionStart",
		"ShowNativeInput",
		"Text",
		"TextColor",
		"TextColor3",
		"TextDirection",
		"TextEditable",
		"TextScaled",
		"TextSize",
		"TextStrokeColor3",
		"TextStrokeTransparency",
		"TextTransparency",
		"TextTruncate",
		"TextWrapped",
		"TextXAlignment",
		"TextYAlignment",
		"Active",
		"AnchorPoint",
		"AutomaticSize",
		"BackgroundColor",
		"BackgroundColor3",
		"BackgroundTransparency",
		"BorderColor",
		"BorderColor3",
		"BorderMode",
		"BorderSizePixel",
		"ClipsDescendants",
		"NextSelectionDown",
		"NextSelectionLeft",
		"NextSelectionRight",
		"NextSelectionUp",
		"Position",
		"Rotation",
		"Selectable",
		"SelectionImageObject",
		"SelectionOrder",
		"Size",
		"SizeConstraint",
		"Transparency",
		"Visible",
		"AutoLocalize",
		"RootLocalizationTable",
		"SelectionBehaviorDown",
		"SelectionBehaviorLeft",
		"SelectionBehaviorRight",
		"SelectionBehaviorUp",
		"SelectionGroup",
	},

	virtualReadable = {
		{ name = "CornerRadius", fn = VirtualCorners.getVirtual },
		{ name = "Scale", fn = VirtualScale.getVirtual },
		{ name = "PaddingLeft", fn = VirtualPadding.getVirtualLeft },
		{ name = "PaddingRight", fn = VirtualPadding.getVirtualRight },
		{ name = "PaddingTop", fn = VirtualPadding.getVirtualTop },
		{ name = "PaddingBottom", fn = VirtualPadding.getVirtualBottom },
	},
	virtualWriteable = {
		{ name = "CornerRadius", fn = VirtualCorners.setVirtual },
		{ name = "Scale", fn = VirtualScale.setVirtual },
		{ name = "PaddingLeft", fn = VirtualPadding.setVirtualLeft },
		{ name = "PaddingRight", fn = VirtualPadding.setVirtualRight },
		{ name = "PaddingTop", fn = VirtualPadding.setVirtualTop },
		{ name = "PaddingBottom", fn = VirtualPadding.setVirtualBottom },
		{ name = "Padding", fn = VirtualPadding.setVirtualAll },
	},
}

TextBox.funcs = {
	onEvent = OnEvent,
	captureFocus = function(self)
		self._instance:CaptureFocus()
		self:onFocused()
	end,
	releaseFocus = function(self)
		self._instance:ReleaseFocus()
		self:onFocusLost()
	end,
	isFocused = function(self)
		return self._instance:IsFocused()
	end,
}

return TextBox
