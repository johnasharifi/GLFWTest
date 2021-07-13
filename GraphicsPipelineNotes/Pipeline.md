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