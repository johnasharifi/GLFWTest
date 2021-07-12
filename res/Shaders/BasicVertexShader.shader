#version 330 core

layout(location = 0) in vec4 position;
out vec2 texCoordUV;

void main()
{
	// variable for easily selecting combos of -1, +1, 0
	vec4 signSwizzler = vec4(+1.0, -1.0, 0, 0);

	const int vertCount = 3;
	// create these vars in shader since the verts in Application cpp aren't that important. focus on shader work
	
	vec4 vertsInShader[vertCount] = { 
		signSwizzler.yyzz, 
		signSwizzler.zxzz,
		signSwizzler.xyzz
	};

	// gl_VertexID is populated by GL https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/gl_VertexID.xhtml
	// map values in span (-1, +1) to span (0,1)
	texCoordUV = vertsInShader[gl_VertexID].xy * 0.5 + 0.5;
	gl_Position = position;
}
