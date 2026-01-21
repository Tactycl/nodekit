local safeCall = require("../../../util/safeCall")

return function(self, event)
	local t = event.type
	local p = event.payload

	if t == "PointerEnter" then
		self._hovered = true
		if self._instance:IsA("TextBox") then
			self._instance.Interactable = true
		end
		safeCall(self, "onMouseEnter", p)
		return
	end

	if t == "PointerLeave" then
		self._hovered = false
		if self._instance:IsA("TextBox") and not self:isFocused() then
			self._instance.Interactable = false
		end
		safeCall(self, "onMouseLeave", p)
		return
	end

	if t == "PointerMoved" then
		safeCall(self, "onMouseMoved", p)
		return
	end

	if t == "PointerWheel" then
		local d = p and p.delta or 0
		if d > 0 then
			safeCall(self, "onMouseWheelForward", p)
		elseif d < 0 then
			safeCall(self, "onMouseWheelBackward", p)
		end
		return
	end

	if t == "PointerBegan" then
		local input = p and p.input
		if not input then
			return
		end

		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			self._pressed = true
			safeCall(self, "onPress", p)
			event:consume()
			return
		end
		return
	end

	if t == "PointerEnded" then
		local input = p and p.input
		if not input then
			return
		end

		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			self._pressed = false
			safeCall(self, "onRelease", p)
			event:consume()
			return
		end
		return
	end

	if t == "PointerClick" then
		safeCall(self, "onClick", p)
		event:consume()
		return
	end
end
