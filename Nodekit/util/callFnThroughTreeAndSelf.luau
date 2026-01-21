return function(self, fnName, cb, ...)
	local packet = { ... }
	local function stepNode(node)
		if node[fnName] and typeof(node[fnName]) == "function" then
			node[fnName](node, unpack(packet))
		end
		if cb and typeof(cb) == "function" then
			cb(node, unpack(packet))
		end
	end

	local function walk(node)
		if not node._children then
			return
		end
		for _, childNode in node._children do
			stepNode(childNode)
			walk(childNode)
		end
	end

	stepNode(self)
	walk(self)
end
