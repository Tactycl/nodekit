local VirtualCorners = require("../Virtuals/Corners")
local VirtualScale = require("../Virtuals/Scale")
local VirtualPadding = require("../Virtuals/Padding")

local OnEvent = require("../Funcs/OnEvent")

local Frame = {}

Frame.rblxClass = "Frame"
Frame.initParams = {}

Frame.properties = {
	readable = {
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
		"Interactable",
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
		"Interactable",
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

Frame.funcs = {
	onEvent = OnEvent,
}

return Frame
