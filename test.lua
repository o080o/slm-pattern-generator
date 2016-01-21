local get = require("get")
local S = require("shaders")
gl = require("webglContext")("Canvas")
glutil = require("webglUtil")
local vec3, mat4, Float32Array, setUniformMatrix4, setUniformFloat = glutil.vec3, glutil.mat4, glutil.Float32Array, glutil.setUniformMatrix4, glutil.setUniformFloat

local vsrc = get("slm.vs") --sync. get request
local fsrc = get("slm.fs")

local program = S.loadShaders(vsrc, fsrc)
local mvMatrix, pMatrix = mat4(), mat4()
gl.useProgram(program)
gl.enableVertexAttribArray( gl.getAttribLocation(program, "aVertexPosition"))
local parameters = js.global.parameters
--more higher level util functions
function setUniforms()
	setUniformMatrix4(program, "uPMatrix", pMatrix)
	setUniformMatrix4(program, "uMVMatrix", mvMatrix)
	setUniformFloat(program, "red", parameters.hlens.radius)
end
function makeQuad()
	local verts = {
		-1,1,0,
		1,1,0,
		-1,-1,0,
		1,-1,0
	}
	local quadVerts = gl.createBuffer()
	gl.bindBuffer(gl.ARRAY_BUFFER, quadVerts)
	gl.bufferData(gl.ARRAY_BUFFER, Float32Array(verts), gl.STATIC_DRAW)
	quadVerts.n = 4
	quadVerts.size = 3
	return quadVerts
end
function drawShape(verts)
	gl.viewport(0, 0, gl.viewportWidth, gl.viewportHeight)
	gl.clear(gl.COLOR_BUFFER_BIT + gl.DEPTH_BUFFER_BIT)

	js.global.mat4:identity(mvMatrix)
	js.global.mat4:identity(pMatrix)
	
	gl.bindBuffer(gl.ARRAY_BUFFER, verts)
	gl.vertexAttribPointer(gl.getAttribLocation(program, "aVertexPosition"), verts.size, gl.FLOAT, false, 0, 0)
	setUniforms()
	gl.drawArrays(gl.TRIANGLE_STRIP, 0, verts.n)
end
local quad = makeQuad()
drawShape(quad)

-- setup resize handler
js.global:getElementById("Canvas"):addEventListener("resize", function()
print("canvas resized from Lua!")
end)
-- setup a resize handler setup from js
gl.resize = function()
	print("canvas resized from JS handler...")
	local canvas = js.global:getElementById("Canvas")
	gl.viewportWidth = canvas.width
	gl.viewportHeight = canvas.heigt
end
