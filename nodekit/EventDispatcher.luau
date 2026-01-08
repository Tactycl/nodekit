local UserInputService = game:GetService("UserInputService")

local Event = require("./Event")

local EventDispatcher = {}
EventDispatcher.__index = EventDispatcher

local function isPointerTarget(inst)
	if not inst then
		return false
	end
	if not inst:IsA("GuiObject") then
		return false
	end
	if inst.Visible ~= true then
		return false
	end
	if inst.Active ~= true then
		return false
	end
	return true
end

local function pointInGui(inst, p)
	local pos = inst.AbsolutePosition
	local size = inst.AbsoluteSize
	return p.X >= pos.X and p.Y >= pos.Y and p.X <= pos.X + size.X and p.Y <= pos.Y + size.Y
end

local function isPointerEventType(eventType: string)
	return eventType == "PointerBegan"
		or eventType == "PointerEnded"
		or eventType == "PointerMoved"
		or eventType == "PointerChanged"
		or eventType == "InputBegan"
		or eventType == "InputEnded"
		or eventType == "InputChanged"
end

local function isPressInput(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function isBlockingLayer(node)
	return node
		and node.isBlockingEventPropagation
		and typeof(node.isBlockingEventPropagation) == "function"
		and node:isBlockingEventPropagation() == true
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

function EventDispatcher:setEnabled(enabled: boolean)
	self._enabled = enabled and true or false
	return self
end

function EventDispatcher:isEnabled()
	return self._enabled == true
end

function EventDispatcher:_getRunningScene()
	local director = self._director
	return director and director.getRunningScene and director:getRunningScene()
end

function EventDispatcher:_handleNode(node, event)
	if node._dispatchEvent then
		node:_dispatchEvent(event)
		return
	end
	if typeof(node._onEvent) == "function" then
		node:_onEvent(event)
	end
	if typeof(node.onEvent) == "function" then
		node:onEvent(event)
		return
	end
end

function EventDispatcher:_findTopmostAt(root, pointerPos)
	local function walk(node)
		local children = node._children
		if children then
			for i = #children, 1, -1 do
				local child = children[i]
				local inst = child and child._instance

				local hit = nil

				if inst and inst:IsA("GuiObject") then
					if pointInGui(inst, pointerPos) then
						hit = walk(child)
						if hit then
							return hit
						end
					end
				else
					hit = walk(child)
					if hit then
						return hit
					end
				end

				if isBlockingLayer(child) then
					return nil
				end
			end
		end

		local inst = node._instance
		if isPointerTarget(inst) and pointInGui(inst, pointerPos) then
			return node
		end

		return nil
	end

	return walk(root)
end

function EventDispatcher:_dispatchDirect(node, event)
	if not node then
		return event
	end
	self:_handleNode(node, event)
	return event
end

function EventDispatcher:_clearFocus()
	if self._focusLostConn then
		self._focusLostConn:Disconnect()
		self._focusLostConn = nil
	end

	local n = self._focusedNode
	self._focusedNode = nil

	if n and n.releaseFocus then
		n:releaseFocus()
	elseif n and n.onFocusLost then
		n:onFocusLost()
	end
	n._instance.Interactable = false
end

function EventDispatcher:_setFocus(node)
	if self._focusedNode == node then
		return
	end

	if self._focusedNode then
		self:_clearFocus()
	end

	if not node then
		return
	end

	if node.captureFocus then
		node:captureFocus()
	elseif node.onFocused then
		node:onFocused()
	end
	node._instance.Interactable = true

	self._focusedNode = node

	local inst = node._instance
	if inst and inst:IsA("TextBox") then
		self._focusLostConn = inst.FocusLost:Connect(function(...)
			if self._focusedNode ~= node then
				return
			end
			node._instance.Interactable = false
			if self._focusLostConn then
				self._focusLostConn:Disconnect()
				self._focusLostConn = nil
			end
			self._focusedNode = nil
			if node.onFocusLost then
				node:onFocusLost(...)
			end
		end)
	end
end

function EventDispatcher:_updateHover(pointerPos)
	local scene = self:_getRunningScene()
	if not scene then
		return
	end

	local hit = self:_findTopmostAt(scene, pointerPos)
	if hit == self._hoverNode then
		if hit then
			self:_dispatchDirect(hit, Event:create("MouseMoved", { position = pointerPos }))
		end
		return
	end

	local prev = self._hoverNode
	self._hoverNode = hit

	if prev then
		self:_dispatchDirect(prev, Event:create("MouseLeave", { position = pointerPos }))
	end

	if hit then
		self:_dispatchDirect(hit, Event:create("MouseEnter", { position = pointerPos }))
		self:_dispatchDirect(hit, Event:create("MouseMoved", { position = pointerPos }))
	end
end

function EventDispatcher:_dispatchWheel(pointerPos, wheelDelta)
	local scene = self:_getRunningScene()
	if not scene then
		return
	end

	local hit = self:_findTopmostAt(scene, pointerPos)
	if not hit then
		return
	end

	local t = wheelDelta > 0 and "MouseWheelForward" or "MouseWheelBackward"
	self:_dispatchDirect(hit, Event:create(t, { position = pointerPos, delta = wheelDelta }))
end

function EventDispatcher:dispatch(event)
	if not self._enabled then
		return event
	end

	local scene = self:_getRunningScene()
	if not scene then
		return event
	end

	local pointerPos = nil
	if isPointerEventType(event.type) then
		local payload = event.payload
		if payload and payload.position then
			pointerPos = payload.position
		else
			pointerPos = UserInputService:GetMouseLocation()
		end
	end

	local function walk(node)
		if event:isConsumed() then
			return true
		end

		local children = node._children
		if children then
			for i = #children, 1, -1 do
				local child = children[i]

				if pointerPos then
					local inst = child and child._instance
					if inst and inst:IsA("GuiObject") then
						if pointInGui(inst, pointerPos) then
							if walk(child) then
								return true
							end
						end
					else
						if walk(child) then
							return true
						end
					end
				else
					if walk(child) then
						return true
					end
				end

				if isBlockingLayer(child) then
					return true
				end
			end
		end

		if pointerPos then
			local inst = node._instance
			if isPointerTarget(inst) and pointInGui(inst, pointerPos) then
				self:_handleNode(node, event)
			end
		else
			self:_handleNode(node, event)
		end

		return event:isConsumed()
	end

	walk(scene)
	return event
end

function EventDispatcher:dispatchToSubtree(root, event)
	if not self._enabled then
		return event
	end
	if not root then
		return event
	end

	local function walk(node)
		if event:isConsumed() then
			return true
		end

		self:_handleNode(node, event)

		local children = node._children
		if children then
			for _, child in children do
				if walk(child) then
					return true
				end
			end
		end

		return event:isConsumed()
	end

	walk(root)
	return event
end

function EventDispatcher:dispatchBroadcast(event)
	local scene = self:_getRunningScene()
	return self:dispatchToSubtree(scene, event)
end

function EventDispatcher:bindUserInput()
	self._conns[#self._conns + 1] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not self._enabled then
			return
		end

		local pos = UserInputService:GetMouseLocation()
		local payload = {
			input = input,
			gameProcessed = gameProcessed,
			position = (input.Position ~= nil and Vector2.new(input.Position.X, input.Position.Y)) or pos,
		}

		self:_updateHover(payload.position)

		local scene = self:_getRunningScene()
		local hit = scene and self:_findTopmostAt(scene, payload.position) or nil

		if hit and isPressInput(input) then
			self._pressNode = hit
			if hit.captureFocus then
				self:_setFocus(hit)
			else
				if self._focusedNode then
					self:_clearFocus()
				end
			end
		elseif isPressInput(input) then
			if self._focusedNode then
				self:_clearFocus()
			end
			self._pressNode = nil
		end

		self:dispatch(Event:create("InputBegan", payload))
	end)

	self._conns[#self._conns + 1] = UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if not self._enabled then
			return
		end

		local pos = UserInputService:GetMouseLocation()
		local payload = {
			input = input,
			gameProcessed = gameProcessed,
			position = (input.Position ~= nil and Vector2.new(input.Position.X, input.Position.Y)) or pos,
		}

		if input.UserInputType == Enum.UserInputType.MouseMovement then
			self:_updateHover(payload.position)
		elseif input.UserInputType == Enum.UserInputType.MouseWheel then
			local d = input.Position and input.Position.Z or 0
			if d ~= 0 then
				self:_dispatchWheel(payload.position, d)
			end
		else
			self:_updateHover(payload.position)
		end

		self:dispatch(Event:create("InputChanged", payload))
	end)

	self._conns[#self._conns + 1] = UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if not self._enabled then
			return
		end

		local pos = UserInputService:GetMouseLocation()
		local payload = {
			input = input,
			gameProcessed = gameProcessed,
			position = (input.Position ~= nil and Vector2.new(input.Position.X, input.Position.Y)) or pos,
		}

		self:_updateHover(payload.position)

		local scene = self:_getRunningScene()
		local hit = scene and self:_findTopmostAt(scene, payload.position) or nil
		payload.isOver = (hit ~= nil)

		if isPressInput(input) and self._pressNode then
			payload.isOver = (hit == self._pressNode)
			self:dispatchToSubtree(self._pressNode, Event:create("InputEnded", payload))
			self._pressNode = nil
			return
		end

		self:dispatch(Event:create("InputEnded", payload))
	end)

	return self
end

function EventDispatcher:destroy()
	for _, c in self._conns do
		if typeof(c) == "RBXScriptConnection" then
			c:Disconnect()
		end
	end
	self._conns = {}
	self._director = nil
	self._hoverNode = nil
	self._pressNode = nil
	self:_clearFocus()
end

return EventDispatcher
