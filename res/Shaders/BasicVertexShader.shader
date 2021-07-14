#version 330 core

layout(location = 0) in vec4 position;
out vec2 texCoordUV;

void main()
{
	// for a fullscreen screen space two-triangle-quad,
	// the "position" vertex is easily linearly related to the desired texCoordUV value

	// map values in span (-1, +1) to span (0,1)
	texCoordUV = position.xy * 0.5 + 0.5;
	gl_Position = position;
}
