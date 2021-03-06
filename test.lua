local get = require("get")
local S = require("shaders")
print("hmm")
gl = require("webglContext")
print(gl)
gl = require("webglContext")("Canvas") or {}

glutil = require("webglUtil")
local vec3, mat4, Float32Array, setUniformMatrix4, setUniformFloat = glutil.vec3, glutil.mat4, glutil.Float32Array, glutil.setUniformMatrix4, glutil.setUniformFloat

gl.disable(gl.DEPTH_TEST)
--gl.depthFunc(gl.LEQUAL)
gl.clearColor(1,0,0,1)

local vsrc = get("slm.vs") --sync. get request
local fsrc = get("slm.fs")

local program = S.loadShaders(vsrc, fsrc)
local mvMatrix, pMatrix = mat4(), mat4()
gl.useProgram(program)
gl.enableVertexAttribArray( gl.getAttribLocation(program, "position"))
--more higher level util functions
function setUniforms()
	local parameters = js.global.parameters
	print("settting uniforms", parameters, parameters.vlens.radius)
	-- lens parameters
	print("vlens_uniform:", gl.getUniformLocation(program, "vlens_radius"))
	setUniformFloat(program, "hlens_radius", parameters.hlens.radius)
	setUniformFloat(program, "vlens_radius", parameters.vlens.radius)
	setUniformFloat(program, "lens_xoffset", parameters.hlens.lens_offset)
	setUniformFloat(program, "lens_yoffset", parameters.vlens.lens_offset)
	setUniformFloat(program, "vlens_radius", parameters.vlens.radius)

	setUniformFloat(program, "array_radius", parameters.hlens.array_radius)
	setUniformFloat(program, "array_xoffset", parameters.hlens.array_offset)
	setUniformFloat(program, "array_pitch", parameters.hlens.pitch)
	-- global parameters
	setUniformFloat(program, "wavelength", parameters.laser.wavelength*0.000001) --calculation done in mm
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

	gl.clear(gl.COLOR_BUFFER_BIT + gl.DEPTH_BUFFER_BIT)
	js.global.mat4:identity(mvMatrix)
	js.global.mat4:identity(pMatrix)
	
	gl.bindBuffer(gl.ARRAY_BUFFER, verts)
	gl.vertexAttribPointer(gl.getAttribLocation(program, "position"), verts.size, gl.FLOAT, false, 0, 0)
	setUniforms()
	gl.drawArrays(gl.TRIANGLE_STRIP, 0, verts.n)
	--js.global:jsTestDraw(gl.context)
end

local quad
-- setup a resize handler setup from js
gl.resize = function(width, height)
	local canvas = js.global.document:getElementById("Canvas")
	print("resize event thrown!")
	print(canvas.clientWidth, canvas.clientHeight)
	canvas.width = width or canvas.clientWidth
	canvas.height = height or canvas.clientHeight
	gl.viewport(0, 0, canvas.width, canvas.height)
	drawShape(quad)
end
gl.resize = function(width, height)
	js.global.gl = gl.context
	js.global:requestAnimationFrame(js.global.jsRender)
end
gl.redraw = function()
	drawShape(quad)
end
quad = makeQuad()
drawShape(quad)
