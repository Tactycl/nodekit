local Scale = {}

local function destroyConstraint(self)
	if self._uiScale then
		self._uiScale:Destroy()
		self._uiScale = nil
	end
end

local function ensureConstraint(self)
	if not self._uiScale then
		self._uiScale = Instance.new("UIScale")
		self._uiScale.Parent = self._instance
	end
	return self._uiScale
end

Scale.getVirtual = function(self)
	local c = self._uiScale
	if c then
		return c.Scale
	end
	return 1
end

Scale.setVirtual = function(self, v)
	if v == nil then
		destroyConstraint(self)
	elseif typeof(v) == "number" then
		if v == 1 then
			destroyConstraint(self)
			return
		end

		local c = ensureConstraint(self)
		c.Scale = v
	end
end

return Scale
