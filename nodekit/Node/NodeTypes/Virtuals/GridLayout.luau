local GridLayout = {}

local function destroyConstraint(self)
	if self._gridLayout then
		self._gridLayout:Destroy()
		self._gridLayout = nil
	end
end

local function ensureConstraint(self)
	if not self._gridLayout then
		self._gridLayout = Instance.new("UIGridLayout")
		self._gridLayout.Parent = self._instance
	end
	return self._gridLayout
end

GridLayout.setVirtualEnabled = function(self, enabled)
	if enabled == true then
		ensureConstraint(self)
	else
		destroyConstraint(self)
	end
end

GridLayout.getVirtualEnabled = function(self)
	return self._gridLayout ~= nil
end

GridLayout.setVirtualCellPadding = function(self, cellPadding)
	if typeof(cellPadding) == "UDim2" then
		local c = ensureConstraint(self)
		c.CellPadding = cellPadding
	end
end

GridLayout.getVirtualCellPadding = function(self)
	if self._gridLayout then
		return self._gridLayout.CellPadding
	end
	return UDim2.new(0, 0, 0, 0)
end

GridLayout.setVirtualCellSize = function(self, cellSize)
	if typeof(cellSize) == "UDim2" then
		local c = ensureConstraint(self)
		c.CellSize = cellSize
	end
end

GridLayout.getVirtualCellSize = function(self)
	if self._gridLayout then
		return self._gridLayout.CellSize
	end
	return UDim2.new(0, 100, 0, 100)
end

GridLayout.setVirtualFillDirection = function(self, fillDirection)
	if typeof(fillDirection) == "EnumItem" and fillDirection.EnumType == Enum.FillDirection then
		local c = ensureConstraint(self)
		c.FillDirection = fillDirection
	end
end

GridLayout.getVirtualFillDirection = function(self)
	if self._gridLayout then
		return self._gridLayout.FillDirection
	end
	return Enum.FillDirection.Horizontal
end

GridLayout.setVirtualFillDirectionMaxCells = function(self, maxCells)
	if typeof(maxCells) == "number" then
		local c = ensureConstraint(self)
		c.FillDirectionMaxCells = maxCells
	end
end

GridLayout.getVirtualFillDirectionMaxCells = function(self)
	if self._gridLayout then
		return self._gridLayout.FillDirectionMaxCells
	end
	return 0
end

GridLayout.setVirtualSortOrder = function(self, sortOrder)
	if typeof(sortOrder) == "EnumItem" and sortOrder.EnumType == Enum.SortOrder then
		local c = ensureConstraint(self)
		c.SortOrder = sortOrder
	end
end

GridLayout.getVirtualSortOrder = function(self)
	if self._gridLayout then
		return self._gridLayout.SortOrder
	end
	return Enum.SortOrder.LayoutOrder
end

GridLayout.setVirtualStartCorner = function(self, startCorner)
	if typeof(startCorner) == "EnumItem" and startCorner.EnumType == Enum.StartCorner then
		local c = ensureConstraint(self)
		c.StartCorner = startCorner
	end
end

GridLayout.getVirtualStartCorner = function(self)
	if self._gridLayout then
		return self._gridLayout.StartCorner
	end
	return Enum.StartCorner.TopLeft
end

GridLayout.setVirtualHorizontalAlignment = function(self, horizontalAlignment)
	if typeof(horizontalAlignment) == "EnumItem" and horizontalAlignment.EnumType == Enum.HorizontalAlignment then
		local c = ensureConstraint(self)
		c.HorizontalAlignment = horizontalAlignment
	end
end

GridLayout.getVirtualHorizontalAlignment = function(self)
	if self._gridLayout then
		return self._gridLayout.HorizontalAlignment
	end
	return Enum.HorizontalAlignment.Center
end

GridLayout.setVirtualVerticalAlignment = function(self, verticalAlignment)
	if typeof(verticalAlignment) == "EnumItem" and verticalAlignment.EnumType == Enum.VerticalAlignment then
		local c = ensureConstraint(self)
		c.VerticalAlignment = verticalAlignment
	end
end

GridLayout.getVirtualVerticalAlignment = function(self)
	if self._gridLayout then
		return self._gridLayout.VerticalAlignment
	end
	return Enum.VerticalAlignment.Center
end

return GridLayout
