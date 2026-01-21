local AspectRatio = {}

local function destroyConstraint(self)
	if self._aspectRatio then
		self._aspectRatio:Destroy()
		self._aspectRatio = nil
	end
end

local function ensureConstraint(self)
	if not self._aspectRatio then
		self._aspectRatio = Instance.new("UIAspectRatioConstraint")
		self._aspectRatio.Parent = self._instance
	end
	return self._aspectRatio
end

AspectRatio.setVirtualEnabled = function(self, enabled)
	if enabled == true then
		ensureConstraint(self)
	else
		destroyConstraint(self)
	end
end

AspectRatio.getVirtualEnabled = function(self)
	return self._aspectRatio ~= nil
end

AspectRatio.setVirtualAspectRatio = function(self, aspectRatio)
  if typeof(aspectRatio) == "number" then
    local c = ensureConstraint(self)
    c.AspectRatio = aspectRatio
  end
end

AspectRatio.getVirtualAspectRatio = function(self)
  if self._aspectRatio then
    return self._aspectRatio.AspectRatio
  end
  return 1
end

AspectRatio.setVirtualAspectType = function(self, aspectType)
  if typeof(aspectType) == "EnumItem" and aspectType.EnumType == Enum.AspectType then
    local c = ensureConstraint(self)
    c.AspectType = aspectType
  end
end

AspectRatio.getVirtualAspectType = function(self)
  if self._aspectRatio then
    return self._aspectRatio.AspectType
  end
  return Enum.AspectType.FitWithinMaxSize
end

AspectRatio.setVirtualDominantAxis = function(self, dominantAxis)
  if typeof(dominantAxis) == "EnumItem" and dominantAxis.EnumType == Enum.DominantAxis then
    local c = ensureConstraint(self)
    c.DominantAxis = dominantAxis
  end
end

AspectRatio.getVirtualDominantAxis = function(self)
  if self._aspectRatio then
    return self._aspectRatio.DominantAxis
  end
  return Enum.DominantAxis.Width
end

return AspectRatio