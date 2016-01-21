local S = {}

function S.validateShader(shader)
	local status = gl.getShaderParameter(shader, gl.COMPILE_STATUS)
	return status
end
function S.validateProgram(program)
	local status = gl.getProgramParameter(program, gl.LINK_STATUS)
	return status
end
function S.shaderLog(shader)
	return gl.getShaderInfoLog(shader)
end
function S.compileShader(src, type)
	local shader = gl.createShader(type)
	gl.shaderSource(shader, src)
	gl.compileShader(shader)

	assert(S.validateShader(shader), tostring(type).."| Shader compilation failed! :"..S.shaderLog(shader))
	return shader
end
function S.loadShaders(vSrc, fSrc)
	local vShader = S.compileShader(vSrc, gl.VERTEX_SHADER)
	local fShader = S.compileShader(fSrc, gl.FRAGMENT_SHADER)
	local program = gl.createProgram()
	gl.attachShader(program, vShader)
	gl.attachShader(program, fShader)
	gl.linkProgram(program)
	assert(S.validateProgram(program), "linking program failed!")
	gl.deleteShader(vShader)
	gl.deleteShader(fShader)
	return program
end

return S
