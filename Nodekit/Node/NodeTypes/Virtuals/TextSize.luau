local TextSize = {}

local function destroyConstraint(self)
	if self._textSizeConstraint then
		self._textSizeConstraint:Destroy()
		self._textSizeConstraint = nil
	end
end

local function ensureConstraint(self)
	if not self._textSizeConstraint then
		self._textSizeConstraint = Instance.new("UITextSizeConstraint")
		self._textSizeConstraint.Parent = self._instance
	end
	return self._textSizeConstraint
end

TextSize.getVirtualMax = function(self)
	local c = self._textSizeConstraint
	if c then
		return c.MaxTextSize
	end
	return math.huge
end

TextSize.getVirtualMin = function(self)
	local c = self._textSizeConstraint
	if c then
		return c.MinTextSize
	end
	return 0
end

TextSize.setVirtualMax = function(self, v)
	if v == nil then
		if TextSize.getVirtualMin(self) == 0 then
			destroyConstraint(self)
			return
		end

		v = math.huge
	end

	if typeof(v) ~= "number" then
		return
	end

	if v < 0 then
		v = 0
	end

	local c = ensureConstraint(self)
	c.MaxTextSize = v

	if c.MinTextSize == 0 and c.MaxTextSize == math.huge then
		destroyConstraint(self)
	end
end

TextSize.setVirtualMin = function(self, v)
	if v == nil then
		if TextSize.getVirtualMax(self) == math.huge then
			destroyConstraint(self)
			return
		end
		v = 0
	end

	if typeof(v) ~= "number" then
		return
	end

	if v < 0 then
		v = 0
	end

	local c = ensureConstraint(self)
	c.MinTextSize = v

	if c.MaxTextSize < c.MinTextSize then
		c.MaxTextSize = c.MinTextSize
	end

	if c.MinTextSize == 0 and c.MaxTextSize == math.huge then
		destroyConstraint(self)
	end
end

return TextSize
