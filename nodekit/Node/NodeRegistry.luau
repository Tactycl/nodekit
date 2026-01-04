local NodeRegistry = {}
local instanceToNode = setmetatable({}, { __mode = "k" })

function NodeRegistry.register(node)
	local inst = node and node._instance
	if inst then
		instanceToNode[inst] = node
	end
end

function NodeRegistry.unregister(node)
	local inst = node and node._instance
	if inst and instanceToNode[inst] == node then
		instanceToNode[inst] = nil
	end
end

function NodeRegistry.fromInstance(inst: Instance)
	return instanceToNode[inst]
end

return NodeRegistry
