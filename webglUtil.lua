local U = {}
--some utility functions
function U.vec3(x,y,z)
	return js.global.vec3:fromValues(x or 0,y or 0,z or 0)
end
function U.mat4()
	return js.global.mat4:create()
end
function U.setUniform(program, name, elem)
	error("NYI")
end
function U.setUniformMatrix4(program, name, matrix)
	gl.uniformMatrix4fv( gl.getUniformLocation(program, name), false, matrix)
end
function U.setUniformFloat(program, name, val)
	gl.uniform1f(gl.getUniformLocation(program, name), val)
end
function U.Float32Array(arr)
	return js.global:jsFloat32Array(arr)
end

return U
