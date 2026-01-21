local Padding = {}

local function destroyPadding(self)
	if self._uiPadding then
		self._uiPadding:Destroy()
		self._uiPadding = nil
	end
end

local function ensurePadding(self)
	if not self._uiPadding then
		self._uiPadding = Instance.new("UIPadding")
		self._uiPadding.Parent = self._instance
	end
	return self._uiPadding
end

local function isZeroUDim(u)
	return u.Scale == 0 and u.Offset == 0
end

local function allZero(c)
	return isZeroUDim(c.PaddingLeft)
		and isZeroUDim(c.PaddingRight)
		and isZeroUDim(c.PaddingTop)
		and isZeroUDim(c.PaddingBottom)
end

Padding.getVirtualLeft = function(self)
	local c = self._uiPadding
	if c then
		return c.PaddingLeft
	end
	return UDim.new(0, 0)
end

Padding.getVirtualRight = function(self)
	local c = self._uiPadding
	if c then
		return c.PaddingRight
	end
	return UDim.new(0, 0)
end

Padding.getVirtualTop = function(self)
	local c = self._uiPadding
	if c then
		return c.PaddingTop
	end
	return UDim.new(0, 0)
end

Padding.getVirtualBottom = function(self)
	local c = self._uiPadding
	if c then
		return c.PaddingBottom
	end
	return UDim.new(0, 0)
end

Padding.setVirtualLeft = function(self, v)
	if v == nil then
		if not self._uiPadding then
			return
		end
		self._uiPadding.PaddingLeft = UDim.new(0, 0)
		if allZero(self._uiPadding) then
			destroyPadding(self)
		end
		return
	end

	if typeof(v) ~= "UDim" then
		return
	end

	local c = ensurePadding(self)
	c.PaddingLeft = v
	if allZero(c) then
		destroyPadding(self)
	end
end

Padding.setVirtualRight = function(self, v)
	if v == nil then
		if not self._uiPadding then
			return
		end
		self._uiPadding.PaddingRight = UDim.new(0, 0)
		if allZero(self._uiPadding) then
			destroyPadding(self)
		end
		return
	end

	if typeof(v) ~= "UDim" then
		return
	end

	local c = ensurePadding(self)
	c.PaddingRight = v
	if allZero(c) then
		destroyPadding(self)
	end
end

Padding.setVirtualTop = function(self, v)
	if v == nil then
		if not self._uiPadding then
			return
		end
		self._uiPadding.PaddingTop = UDim.new(0, 0)
		if allZero(self._uiPadding) then
			destroyPadding(self)
		end
		return
	end

	if typeof(v) ~= "UDim" then
		return
	end

	local c = ensurePadding(self)
	c.PaddingTop = v
	if allZero(c) then
		destroyPadding(self)
	end
end

Padding.setVirtualBottom = function(self, v)
	if v == nil then
		if not self._uiPadding then
			return
		end
		self._uiPadding.PaddingBottom = UDim.new(0, 0)
		if allZero(self._uiPadding) then
			destroyPadding(self)
		end
		return
	end

	if typeof(v) ~= "UDim" then
		return
	end

	local c = ensurePadding(self)
	c.PaddingBottom = v
	if allZero(c) then
		destroyPadding(self)
	end
end

Padding.setVirtualHorizontal = function(self, v)
	if v == nil then
		destroyPadding(self)
		return
	end

	if typeof(v) ~= "UDim" then
		return
	end

	Padding.setVirtualLeft(self, v)
	Padding.setVirtualRight(self, v)
end

Padding.setVirtualVertical = function(self, v)
	if v == nil then
		destroyPadding(self)
		return
	end

	if typeof(v) ~= "UDim" then
		return
	end

	Padding.setVirtualTop(self, v)
	Padding.setVirtualBottom(self, v)
end

Padding.setVirtualAll = function(self, v)
	if v == nil then
		destroyPadding(self)
		return
	end

	if typeof(v) ~= "UDim" then
		return
	end

	Padding.setVirtualLeft(self, v)
	Padding.setVirtualRight(self, v)
	Padding.setVirtualTop(self, v)
	Padding.setVirtualBottom(self, v)
end

return Padding
