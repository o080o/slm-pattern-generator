return function(canvas)
	print("viola!")
	if type(canvas) == "string" then
		canvas = js.global.document:getElementById(canvas)
		if not canvas then error("can not find canvas element:"..canvas) end
	end

	local glObj = canvas:getContext("webgl") or canvas:getContext("experimental-webgl")

	-- make a thin proxy table for the gl object to abstract some things away,
	-- like using ":" for all the js calls. we will just wrap a function around
	-- them...
	local mt = {}
	mt.__index = function(t,k)
		local obj = glObj[k]
		if type(obj)=="userdata" and getmetatable(obj) then
			t[k] = function(...)
				return obj(glObj, ...)
			end
			return t[k]
		end
		return glObj[k]
	end

	mt.__newindex = function(t,k,v)
		glObj[k] = v
	end
	return setmetatable({context=glObj}, mt), canvas
end



