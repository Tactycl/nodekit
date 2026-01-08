local FlexItem = {}

local function destroyConstraint(self)
	if self._flexItem then
		self._flexItem:Destroy()
		self._flexItem = nil
	end
end

local function ensureConstraint(self)
	if not self._flexItem then
		self._flexItem = Instance.new("UIFlexItem")
		self._flexItem.Parent = self._instance
	end
	return self._flexItem
end

FlexItem.setVirtualEnabled = function(self, enabled)
	if enabled == true then
		ensureConstraint(self)
		
	else
		destroyConstraint(self)
	end
end

FlexItem.getVirtualEnabled = function(self)
	return self._flexItem ~= nil
end

FlexItem.setVirtualFlexMode = function(self, flexMode)
	if typeof(flexMode) == "EnumItem" and flexMode.EnumType == Enum.UIFlexMode then
		local c = ensureConstraint(self)
		c.FlexMode = flexMode
	end
end

FlexItem.getVirtualFlexMode = function(self)
	if self._flexItem then
		return self._flexItem.FlexMode
	end
	return Enum.UIFlexMode.None
end

FlexItem.setVirtualItemLineAlignment = function(self, itemLineAlignment)
	if typeof(itemLineAlignment) == "EnumItem" and itemLineAlignment.EnumType == Enum.ItemLineAlignment then
		local c = ensureConstraint(self)
		c.ItemLineAlignment = itemLineAlignment
	end
end

FlexItem.getVirtualItemLineAlignment = function(self)
	if self._flexItem then
		return self._flexItem.ItemLineAlignment
	end
	return Enum.ItemLineAlignment.Automatic
end

return FlexItem