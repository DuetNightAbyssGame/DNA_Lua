

local GlobalFunction = {
	print2 = function( ... )
		print('p2'..tostring(...))
	end
}

local Test2 = require "Test2"

for k,v in pairs(Test2) do
	if type(v) == 'function' then
		debug.setupvalue(v, 1, GlobalFunction)
	end
end

Test2:F1()
Test2:F2()
