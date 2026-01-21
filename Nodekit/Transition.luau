local Transition = {}
Transition.__index = Transition

function Transition:inherit()
	local newClass = {}
	newClass.__index = newClass
	setmetatable(newClass, self)
	return newClass
end

function Transition:create()
	local inst = setmetatable({}, Transition)
	return inst
end

function Transition:run(duration, incoming, outgoing, finish)
	finish()
end

function Transition._getRootGuiParent(incoming, outgoing)
	return (incoming and incoming._parent) or (outgoing and outgoing._parent)
end

return Transition
