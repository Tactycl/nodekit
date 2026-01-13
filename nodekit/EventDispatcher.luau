local UserInputService = game:GetService("UserInputService")
local Event = require("./Event")

local EventDispatcher = {}
EventDispatcher.__index = EventDispatcher

local function isGuiObject(inst)
	return inst ~= nil and inst:IsA("GuiObject")
end

local function isVisibleInHierarchy(node)
	while node do
		local inst = node._instance
		if inst and inst:IsA("GuiObject") then
			if inst.Visible ~= true then
				return false
			end
		end
		node = node._parent
	end
	return true
end

local function isPointerTarget(node)
	local inst = node and node._instance
	if not isGuiObject(inst) then
		return false
	end
	if inst.Active ~= true then
		return false
	end
	if not isVisibleInHierarchy(node) then
		return false
	end
	return true
end

local function pointInGui(inst, p)
	local pos = inst.AbsolutePosition
	local size = inst.AbsoluteSize
	return p.X >= pos.X and p.Y >= pos.Y and p.X <= pos.X + size.X and p.Y <= pos.Y + size.Y
end

local function isPressInput(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function isPointerEventType(t)
	return t == "PointerEnter"
		or t == "PointerLeave"
		or t == "PointerMoved"
		or t == "PointerWheel"
		or t == "PointerBegan"
		or t == "PointerEnded"
		or t == "PointerChanged"
		or t == "PointerClick"
end

local function isBlockingLayer(node)
	return node
		and node.isBlockingEventPropagation
		and typeof(node.isBlockingEventPropagation) == "function"
		and node:isBlockingEventPropagation() == true
end

local function canCullByParentBounds(node)
	local inst = node and node._instance
	return inst and inst:IsA("GuiObject") and inst.ClipsDescendants == true
end

function EventDispatcher:create(director)
	local inst = setmetatable({}, EventDispatcher)
	inst._director = director
	inst._enabled = true
	inst._conns = {}
	inst._hoverNode = nil
	inst._pressNode = nil
	inst._focusedNode = nil
	inst._focusLostConn = nil
	return inst
end

function EventDispatcher:_getRunningScene()
	local d = self._director
	return d and d.getRunningScene and d:getRunningScene()
end

function EventDispatcher:_handleNode(node, event)
	if isPointerEventType(event.type) then
		if typeof(node._onPointerEvent) == "function" then
			node:_onPointerEvent(event)
		end
		return
	end

	if node._dispatchEvent then
		node:_dispatchEvent(event)
	elseif typeof(node.onEvent) == "function" then
		node:onEvent(event)
	end
end

function EventDispatcher:_dispatchDirect(node, event)
	if node then
		self:_handleNode(node, event)
	end
	return event
end

function EventDispatcher:_findTopmostAt(root, pos)
	local function walk(node)
		local children = node._children
		if children then
			if canCullByParentBounds(node) then
				local inst = node._instance
				if inst and inst:IsA("GuiObject") and not pointInGui(inst, pos) then
					return nil
				end
			end

			for i = #children, 1, -1 do
				local child = children[i]
				local hit = walk(child)
				if hit then
					return hit
				end
				if isBlockingLayer(child) then
					return nil
				end
			end
		end

		if isPointerTarget(node) and pointInGui(node._instance, pos) then
			return node
		end

		return nil
	end

	return root and walk(root) or nil
end

function EventDispatcher:_updateHover(pos)
	local scene = self:_getRunningScene()
	if not scene then
		return
	end

	local hit = self:_findTopmostAt(scene, pos)

	if hit == self._hoverNode then
		if hit then
			self:_dispatchDirect(hit, Event:create("PointerMoved", { position = pos }))
		end
		return
	end

	local prev = self._hoverNode
	self._hoverNode = hit

	if prev then
		self:_dispatchDirect(prev, Event:create("PointerLeave", { position = pos }))
	end

	if hit then
		self:_dispatchDirect(hit, Event:create("PointerEnter", { position = pos }))
		self:_dispatchDirect(hit, Event:create("PointerMoved", { position = pos }))
	end
end

function EventDispatcher:_dispatchWheel(pos, delta)
	local scene = self:_getRunningScene()
	if not scene then
		return
	end

	local hit = self:_findTopmostAt(scene, pos)
	if hit then
		self:_dispatchDirect(
			hit,
			Event:create("PointerWheel", {
				position = pos,
				delta = delta,
			})
		)
	end
end

function EventDispatcher:_resolveInputPosition(input)
	if input.Position then
		return Vector2.new(input.Position.X, input.Position.Y)
	end
	return UserInputService:GetMouseLocation()
end

function EventDispatcher:_makePayload(input, processed, pos)
	return {
		input = input,
		gameProcessed = processed,
		position = pos,
	}
end

function EventDispatcher:bindUserInput()
	self._conns[#self._conns + 1] = UserInputService.InputBegan:Connect(function(input, gp)
		if not self._enabled then
			return
		end

		local pos = self:_resolveInputPosition(input)
		local payload = self:_makePayload(input, gp, pos)

		self:_updateHover(pos)

		local scene = self:_getRunningScene()
		local hit = scene and self:_findTopmostAt(scene, pos)

		if isPressInput(input) then
			self._pressNode = hit
			if hit then
				self:_dispatchDirect(hit, Event:create("PointerBegan", payload))
			end
		end

		self:_handleNode(scene, Event:create("InputBegan", payload))
	end)

	self._conns[#self._conns + 1] = UserInputService.InputChanged:Connect(function(input, gp)
		if not self._enabled then
			return
		end

		local pos = self:_resolveInputPosition(input)
		local payload = self:_makePayload(input, gp, pos)

		if input.UserInputType == Enum.UserInputType.MouseWheel then
			local d = input.Position and input.Position.Z or 0
			if d ~= 0 then
				self:_dispatchWheel(pos, d)
			end
		else
			self:_updateHover(pos)
		end

		local scene = self:_getRunningScene()
		local hit = scene and self:_findTopmostAt(scene, pos)
		if hit then
			self:_dispatchDirect(hit, Event:create("PointerChanged", payload))
		end

		self:_handleNode(scene, Event:create("InputChanged", payload))
	end)

	self._conns[#self._conns + 1] = UserInputService.InputEnded:Connect(function(input, gp)
		if not self._enabled then
			return
		end

		local scene = self:_getRunningScene()
		local pos = self:_resolveInputPosition(input)
		local payload = self:_makePayload(input, gp, pos)

		self:_updateHover(pos)

		if isPressInput(input) then
			local hit = scene and self:_findTopmostAt(scene, pos)

			if hit then
				self:_dispatchDirect(hit, Event:create("PointerEnded", payload))
			end

			if hit and hit == self._pressNode then
				self:_dispatchDirect(hit, Event:create("PointerClick", payload))
			end

			self._pressNode = nil
		end

		self:_handleNode(scene, Event:create("InputEnded", payload))
	end)

	return self
end

function EventDispatcher:destroy()
	for _, c in self._conns do
		c:Disconnect()
	end
	self._conns = {}
	self._hoverNode = nil
	self._pressNode = nil
	self._director = nil
end

return EventDispatcher
