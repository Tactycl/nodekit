local safeCall = require("../util/safeCall")

local NodeTypes = {}
NodeTypes.classes = {}

local function initNodeType(fnNewNode: (rblxClass: string) -> (any), mod: ModuleScript)
	NodeTypes.classes[mod.Name] = {
		create = function(self, ...)
			local t = require(mod)

			local properties = t.properties

			local params = { ... }
			local node = fnNewNode(t.rblxClass)
			if t.create and typeof(t.create) == "function" then
				t.create(node)
			end

			node._metaReadable = {}
			node._metaWriteable = {}
			node._metaVirtualReadable = {}
			node._metaVirtualWriteable = {}

			for _, prop in (properties.readable or {}) do
				node._metaReadable[prop] = true
			end

			for _, prop in (properties.writeable or {}) do
				node._metaWriteable[prop] = true
			end

			for _, prop in (properties.virtualReadable or {}) do
				node._metaVirtualReadable[prop.name] = prop.fn
			end

			for _, prop in (properties.virtualWriteable or {}) do
				node._metaVirtualWriteable[prop.name] = prop.fn
			end

			for i, prop in (t.initParams or {}) do
				local v = params[i]
				if v == nil then
					continue
				end

				node["set" .. prop](node, v)
			end

			for funcName, func in (t.funcs or {}) do
				node[funcName] = func
			end

			node._instance.Changed:Connect(function(propertyName)
				safeCall(node, "onChanged", propertyName, node._instance[propertyName])
				safeCall(node, ("on%sChanged"):format(propertyName), node._instance[propertyName])

				-- Internal Use
				safeCall(node, "_onChanged", propertyName, node._instance[propertyName])
				safeCall(node, ("_on%sChanged"):format(propertyName), node._instance[propertyName])
			end)

			return node
		end,
	}
end

function NodeTypes:init(fnNewNode)
	for _, t in script:WaitForChild("Nodes"):GetChildren() do
		if t:IsA("ModuleScript") then
			initNodeType(fnNewNode, t)
		end
	end
end

return NodeTypes
