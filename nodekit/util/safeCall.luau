return function(self, fnName, ...)
	if typeof(self) ~= "table" then
		return
	end
	if typeof(self[fnName]) ~= "function" then
		return
	end
	self[fnName](self, ...)
end
