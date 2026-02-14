local Action = {}
Action.__index = Action

local function assertNotPlayed(self)
	if self._rec.played then
		error("Action already played; create a new action for a new run", 3)
	end
end

local function fireCompleted(self)
	if self._rec.cancelled then
		return
	end
	for _, cb in self._rec.completed do
		task.spawn(cb)
	end
end

local function untrack(self)
	local node = self._node
	if node and node._untrackAction then
		node:_untrackAction(self)
	end
end

function Action:_baseCreate(node)
	local inst = setmetatable({}, Action)
	inst._node = node
	inst._rec = {
		completed = {},
		played = false,
		cancelled = false,
	}
	return inst
end

function Action:onComplete(cb)
	table.insert(self._rec.completed, cb)
	return self
end

function Action:cancel()
	self._rec.cancelled = true
	untrack(self)
	return self
end

function Action:play()
	assertNotPlayed(self)
	self._rec.played = true
	fireCompleted(self)
	untrack(self)
	return self
end

function Action.delay(node, t)
	local inst = Action:_baseCreate(node)
	inst._type = "delay"
	inst._t = t or 0
	inst._thread = nil

	function inst:cancel()
		self._rec.cancelled = true
		untrack(self)
		return self
	end

	function inst:play()
		assertNotPlayed(self)
		self._rec.played = true

		local dt = self._t
		if not dt or dt <= 0 then
			fireCompleted(self)
			untrack(self)
			return self
		end

		task.delay(dt, function()
			if self._rec.cancelled then
				return
			end
			fireCompleted(self)
			untrack(self)
		end)

		return self
	end

	return inst
end

function Action.call(node, fn)
	local inst = Action:_baseCreate(node)
	inst._type = "call"
	inst._fn = fn

	function inst:play()
		assertNotPlayed(self)
		self._rec.played = true

		if not self._rec.cancelled then
			local ok, err = pcall(self._fn)
			if not ok then
				warn(err)
			end
		end

		fireCompleted(self)
		untrack(self)
		return self
	end

	return inst
end

function Action.sequence(node, ...)
	local inst = Action:_baseCreate(node)
	inst._type = "sequence"
	inst._steps = { ... }
	inst._index = 0
	inst._current = nil

	function inst:cancel()
		self._rec.cancelled = true
		if self._current and self._current.cancel then
			self._current:cancel()
		end
		untrack(self)
		return self
	end

	local function playNext(self)
		if self._rec.cancelled then
			return
		end

		self._index += 1
		local step = self._steps[self._index]
		self._current = step

		if not step then
			fireCompleted(self)
			untrack(self)
			return
		end

		if step.onComplete then
			step:onComplete(function()
				playNext(self)
			end)
		else
			error("sequence(...) expects steps with :onComplete(cb) + :play()", 3)
		end

		if step.play then
			step:play()
		else
			error("sequence(...) expects steps with :play()", 3)
		end
	end

	function inst:play()
		assertNotPlayed(self)
		self._rec.played = true
		playNext(self)
		return self
	end

	return inst
end

function Action.parallel(node, ...)
	local inst = Action:_baseCreate(node)
	inst._type = "parallel"
	inst._steps = { ... }
	inst._remaining = 0

	function inst:cancel()
		self._rec.cancelled = true
		for _, step in self._steps do
			if step and step.cancel then
				step:cancel()
			end
		end
		untrack(self)
		return self
	end

	function inst:play()
		assertNotPlayed(self)
		self._rec.played = true

		local remaining = 0
		for _, step in self._steps do
			if step then
				remaining += 1
			end
		end
		self._remaining = remaining

		if remaining == 0 then
			fireCompleted(self)
			untrack(self)
			return self
		end

		local function oneDone()
			if self._rec.cancelled then
				return
			end
			self._remaining -= 1
			if self._remaining <= 0 then
				fireCompleted(self)
				untrack(self)
			end
		end

		for _, step in self._steps do
			if step then
				if not step.onComplete or not step.play then
					error("parallel(...) expects steps with :onComplete(cb) + :play()", 3)
				end
				step:onComplete(oneDone)
				step:play()
			end
		end

		return self
	end

	return inst
end

return Action
