--!strict

--------------------------------------------------------------------------
-- This is a lightweight function wrapper that mimics BindableFunctions --
--------------------------------------------------------------------------
--                   Feel free to use for any purpose                   --
--------------------------------------------------------------------------
--                          Author: orange451                           --
--------------------------------------------------------------------------

export type Function = {
	Invoke: (self: Function, ...any)->(...any),
	SetOnInvoke: (self: Function, callback: (...any)->(...any))->(),

	_callback: (...any)->(...any),
	_destroyed: boolean,
}

local module = {}

local func = {
	_callback = (nil::any) :: (...any)->(...any),
	_destroyed = false,
}

function func.Invoke(self: Function, ...)
	while not self._callback and not self._destroyed do
		task.wait()
	end

	if ( self._destroyed ) then
		return
	end

	local results = {pcall(self._callback, ...)}
	if results[1] then
		return table.unpack(results, 2)
	else
		task.spawn(error, `{results[2]}\n{debug.traceback()}`)
		return nil
	end
end

function func.SetOnInvoke(self: Function, callback: (...any)->(...any))
	assert(self._destroyed == false)
	assert(type(callback) == "function")

	self._callback = callback
end

function func.Destroy(self: Function)
	self._callback = nil :: any
	self._destroyed = true
	table.freeze(self)
end

function module.new() : Function
	local self = setmetatable({}, {__index = func})

	return self :: any
end

return module
