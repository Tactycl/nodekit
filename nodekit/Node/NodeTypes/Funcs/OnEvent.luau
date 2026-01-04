local safeCall = require("../../../util/safeCall")

return function(self, event)
	local t = event.type
	local p = event.payload

	if t == "MouseEnter" then
		self._hovered = true
		if self._instance:IsA("TextBox") then
			self._instance.Interactable = true
		end
		safeCall(self, "onMouseEnter", p)
		return
	end

	if t == "MouseLeave" then
		self._hovered = false
		if self._instance:IsA("TextBox") and not self:isFocused() then
			self._instance.Interactable = false
		end
		safeCall(self, "onMouseLeave", p)
		return
	end

	if t == "MouseMoved" then
		safeCall(self, "onMouseMoved", p)
		return
	end

	if t == "MouseWheelForward" then
		safeCall(self, "onMouseWheelForward", p)
		return
	end

	if t == "MouseWheelBackward" then
		safeCall(self, "onMouseWheelBackward", p)
		return
	end

	if t == "InputBegan" then
		local input = p and p.input
		if not input then
			return
		end

		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			self._pressed = true
			safeCall(self, "onPressed")
			event:consume()
			return
		end

		return
	end

	if t == "InputEnded" then
		local input = p and p.input
		if not input then
			return
		end

		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			local wasPressed = self._pressed == true
			self._pressed = false

			safeCall(self, "onReleased")

			local canClick = (self._hovered == true) or (p and p.isOver == true)
			if wasPressed and canClick then
				safeCall(self, "onClicked")
			end

			event:consume()
			return
		end

		return
	end
end
