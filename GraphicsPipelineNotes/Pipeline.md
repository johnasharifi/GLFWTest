# Overview

Discuss vertices, rasterization, shading.

# Vertices

https://learnopengl.com/Getting-started/Coordinate-Systems

- Model step projects vertices into world space: vertices are computed in world space with model's translation, rotation, scale effects

- View step projects vertices into camera space: vertices in the world are computed as if rendered from a camera

- Clip space: at end of vertex shader execution, vertices are automatically converted from near/far plane span (e.g. -1000 to +1000) to span from [-1 to +1].

# Rasterization

https://www.khronos.org/opengl/wiki/Rendering_Pipeline_Overview#Rasterization

Given vertices, convert to fragments. Fragments which are intermediate between two vertices may be interpolated.

# Shading

A fragment shader defines shading which is applied on a per-pixel basis.

# Depth testing

https://learnopengl.com/Advanced-OpenGL/Depth-testing

Two buffers: a color buffer, and a depth buffer. The color buffer stores latest fragment data per UV, the depth buffer stores latest depth data per UV.

The graphics API can receive a ZTest command which will tell us whether the ZTest will always pass, always fail, or whether a new Z coordinate must be higher than or lower than the old one, etc.

The depth buffer will typically have data in a nonlinear span of (0 to 1) so we must transform to NDC = (-1 to +1) then move into a linear depth space:

    float LinearizeDepth(float depth) 
    {
        float z = depth * 2.0 - 1.0; // back to NDC 
        return (2.0 * near * far) / (far + near - z * (far - near));	
    }
    
ZTest / depth buffer precision can be modified by

- storing inverse of depth, rather than depth
- moving near plane as far away as possible. Values which are close to the near plane but on the positive side, will have better float precision
- using more bits in depth buffer

# Culling
