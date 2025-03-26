# MiniFunction
Lightweight BindableFunction replacement

Usage:
```lua
local Function = require(script.Parent.Function)

local test_func = Function.new()

test_func:SetOnInvoke(function()
  task.wait(0.5)
  return "Hello World"
end)

print(test_func:Invoke())
```
