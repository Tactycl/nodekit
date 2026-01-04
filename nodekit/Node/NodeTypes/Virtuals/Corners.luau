local Corners = {}

local function destroyConstraint(self)
	if self._uiCorner then
		self._uiCorner:Destroy()
		self._uiCorner = nil
	end
end

local function ensureConstraint(self)
	if not self._uiCorner then
		self._uiCorner = Instance.new("UICorner")
		self._uiCorner.Parent = self._instance
	end
	return self._uiCorner
end

Corners.getVirtual = function(self)
	local c = self._uiCorner
	if c then
		return c.CornerRadius
	end
	return UDim.new()
end

Corners.setVirtual = function(self, v)
	if v == nil then
		destroyConstraint(self)
	elseif typeof(v) == "UDim" then
		if v.Offset == 0 and v.Scale == 0 then
			destroyConstraint(self)
			return
		end

		local c = ensureConstraint(self)
		c.CornerRadius = v
	end
end

return Corners
