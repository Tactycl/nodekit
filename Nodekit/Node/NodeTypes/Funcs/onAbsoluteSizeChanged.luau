return function(self)
  -- Refresh the text sizes
  if typeof(self._minTextSize) == "number" then
    self:setMinTextSize(self._minTextSize)
  end
  if typeof(self._maxTextSize) == "number" then
    self:setMaxTextSize(self._maxTextSize)
  end
end
