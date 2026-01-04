local safeCall = require("../../../util/safeCall")

local VirtualCorners = require("../Virtuals/Corners")
local VirtualScale = require("../Virtuals/Scale")
local VirtualPadding = require("../Virtuals/Padding")

local OnEvent = require("../Funcs/OnEvent")

local ImageButton = {}

ImageButton.rblxClass = "ImageButton"
ImageButton.initParams = { "Image" }

ImageButton.create = function(self)
	self._instance.Interactable = false
	self._instance.AutoButtonColor = false
end

ImageButton.properties = {
	readable = {
		"HoverImage",
		"HoverImageContent",
		"Image",
		"ImageColor3",
		"ImageContent",
		"ImageRectOffset",
		"ImageRectSize",
		"ImageTransparency",
		"IsLoaded",
		"PressedImage",
		"PressedImageContent",
		"ResampleMode",
		"ScaleType",
		"SliceCenter",
		"SliceScale",
		"TileSize",
		"AutoButtonColor",
		"HoverHapticEffect",
		"Modal",
		"PressHapticEffect",
		"Selected",
		"Style",
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
		"HoverImage",
		"HoverImageContent",
		"Image",
		"ImageColor3",
		"ImageContent",
		"ImageRectOffset",
		"ImageRectSize",
		"ImageTransparency",
		"PressedImage",
		"PressedImageContent",
		"ResampleMode",
		"ScaleType",
		"SliceCenter",
		"SliceScale",
		"TileSize",
		"AutoButtonColor",
		"HoverHapticEffect",
		"Modal",
		"PressHapticEffect",
		"Selected",
		"Style",
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

ImageButton.funcs = {
	onEvent = OnEvent,
	click = function(self)
		safeCall(self, "onClicked")
	end,
}

return ImageButton
