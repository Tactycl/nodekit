local VirtualCorners = require("../Virtuals/Corners")
local VirtualTextSize = require("../Virtuals/TextSize")
local VirtualScale = require("../Virtuals/Scale")
local VirtualPadding = require("../Virtuals/Padding")
local VirtualAspectRatio = require("../Virtuals/AspectRatio")
local VirtualFlexItem = require("../Virtuals/FlexItem")
local VirtualGradient = require("../Virtuals/Gradient")
local VirtualSizeConstraint = require("../Virtuals/SizeConstraint")

local OnEvent = require("../Funcs/OnEvent")

local Label = {}

Label.rblxClass = "TextLabel"
Label.initParams = { "Text" }

Label.properties = {
	readable = {
		"ContentText",
		"Font",
		"FontFace",
		"LineHeight",
		"LocalizedText",
		"MaxVisibleGraphemes",
		"OpenTypeFeatures",
		"OpenTypeFeaturesError",
		"RichText",
		"Text",
		"TextBounds",
		"TextColor",
		"TextColor3",
		"TextDirection",
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
		"Font",
		"FontFace",
		"LineHeight",
		"MaxVisibleGraphemes",
		"OpenTypeFeatures",
		"RichText",
		"Text",
		"TextColor",
		"TextColor3",
		"TextDirection",
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

		{ name = "MaxTextSize", fn = VirtualTextSize.getVirtualMax },
		{ name = "MinTextSize", fn = VirtualTextSize.getVirtualMin },

		{ name = "Scale", fn = VirtualScale.getVirtual },

		{ name = "PaddingLeft", fn = VirtualPadding.getVirtualLeft },
		{ name = "PaddingRight", fn = VirtualPadding.getVirtualRight },
		{ name = "PaddingTop", fn = VirtualPadding.getVirtualTop },
		{ name = "PaddingBottom", fn = VirtualPadding.getVirtualBottom },
		
		{ name = "AspectRatioEnabled", fn = VirtualAspectRatio.getVirtualEnabled },
		{ name = "AspectRatio", fn = VirtualAspectRatio.getVirtualAspectRatio },
		{ name = "AspectRatioType", fn = VirtualAspectRatio.getVirtualAspectType },
		{ name = "AspectRatioDominantAxis", fn = VirtualAspectRatio.getVirtualDominantAxis },

		{ name = "FlexItemEnabled", fn = VirtualFlexItem.getVirtualEnabled },
		{ name = "FlexMode", fn = VirtualFlexItem.getVirtualFlexMode },
		{ name = "FlexItemLineAlignment", fn = VirtualFlexItem.getVirtualItemLineAlignment },

		{ name = "GradientEnabled", fn = VirtualGradient.getVirtualEnabled },
		{ name = "GradientColor", fn = VirtualGradient.getVirtualColor },
		{ name = "GradientTransparency", fn = VirtualGradient.getVirtualTransparency },
		{ name = "GradientOffset", fn = VirtualGradient.getVirtualOffset },
		{ name = "GradientRotation", fn = VirtualGradient.getVirtualRotation },

		{ name = "MinSize", fn = VirtualSizeConstraint.getVirtualMinSize },
		{ name = "MaxSize", fn = VirtualSizeConstraint.getVirtualMaxSize },
	},
	virtualWriteable = {
		{ name = "CornerRadius", fn = VirtualCorners.setVirtual },

		{ name = "MaxTextSize", fn = VirtualTextSize.setVirtualMax },
		{ name = "MinTextSize", fn = VirtualTextSize.setVirtualMin },

		{ name = "Scale", fn = VirtualScale.setVirtual },

		{ name = "PaddingLeft", fn = VirtualPadding.setVirtualLeft },
		{ name = "PaddingRight", fn = VirtualPadding.setVirtualRight },
		{ name = "PaddingTop", fn = VirtualPadding.setVirtualTop },
		{ name = "PaddingBottom", fn = VirtualPadding.setVirtualBottom },
		{ name = "Padding", fn = VirtualPadding.setVirtualAll },
		
		{ name = "AspectRatioEnabled", fn = VirtualAspectRatio.setVirtualEnabled },
		{ name = "AspectRatio", fn = VirtualAspectRatio.setVirtualAspectRatio },
		{ name = "AspectRatioType", fn = VirtualAspectRatio.setVirtualAspectType },
		{ name = "AspectRatioDominantAxis", fn = VirtualAspectRatio.setVirtualDominantAxis },

		{ name = "FlexItemEnabled", fn = VirtualFlexItem.setVirtualEnabled },
		{ name = "FlexMode", fn = VirtualFlexItem.setVirtualFlexMode },
		{ name = "FlexItemLineAlignment", fn = VirtualFlexItem.setVirtualItemLineAlignment },

		{ name = "GradientEnabled", fn = VirtualGradient.setVirtualEnabled },
		{ name = "GradientColor", fn = VirtualGradient.setVirtualColor },
		{ name = "GradientTransparency", fn = VirtualGradient.setVirtualTransparency },
		{ name = "GradientOffset", fn = VirtualGradient.setVirtualOffset },
		{ name = "GradientRotation", fn = VirtualGradient.setVirtualRotation },

		{ name = "MinSize", fn = VirtualSizeConstraint.setVirtualMinSize },
		{ name = "MaxSize", fn = VirtualSizeConstraint.setVirtualMaxSize },
	},
}

Label.funcs = {
	_onEvent = OnEvent,
}

return Label
