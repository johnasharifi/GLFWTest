#version 330 core

in vec2 texCoordUV;

out vec4 color;

void main()
{
	color = vec4(1.0, texCoordUV.x, texCoordUV.y, 1.0);
}
