local Event = {}
Event.__index = Event

function Event:create(type, payload)
	local inst = setmetatable({}, Event)

	inst.type = type
	inst.payload = payload
	inst._isConsumed = false

	return inst
end

function Event:consume()
	self._isConsumed = true
end

function Event:isConsumed()
	return self._isConsumed == true
end

return Event
