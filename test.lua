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
gl.enableVertexAttribArray( gl.getAttribLocation(program, "position"))
local parameters = js.global.parameters
--more higher level util functions
function setUniforms()
	setUniformMatrix4(program, "pMatrix", pMatrix)
	setUniformMatrix4(program, "mvMatrix", mvMatrix)
	-- lens parameters
	setUniformFloat(program, "vlens_radius", parameters.vlens.radius)
	setUniformFloat(program, "hlens_radius", parameters.hlens.radius)
	setUniformFloat(program, "lens_xoffset", parameters.hlens.lens_offset)
	setUniformFloat(program, "lens_yoffset", 0)

	setUniformFloat(program, "array_radius", parameters.hlens.array_radius)
	setUniformFloat(program, "array_xoffset", parameters.hlens.array_offset)
	setUniformFloat(program, "array_pitch", parameters.hlens.pitch)
	-- global parameters
	setUniformFloat(program, "wavelength", parameters.laser.wavelength*0.000001) --calculation done in mm
	setUniformFloat(program, "uscale", parameters.laser.uscale)
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
end
local quad = makeQuad()
drawShape(quad)

-- setup a resize handler setup from js
gl.resize = function()
	local canvas = js.global.document:getElementById("Canvas")
	local rect = canvas:getClientRects()[0] --gets the size of the *window*
	--local container = js.global.document:getElementById("canvas-container")
	print("resize event thrown!", canvas.width, rect.width, rect.height)
	canvas.width = rect.width
	canvas.height = rect.height
	gl.viewport(0, 0, canvas.width, canvas.height)
	print(canvas.width, canvas.height)
	drawShape(quad)
end
gl.redraw = function()
	drawShape(quad)
end
