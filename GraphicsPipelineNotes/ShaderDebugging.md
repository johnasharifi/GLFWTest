# Overview

# Graphics Diagnostics - Windows 

https://docs.microsoft.com/en-us/visualstudio/debugger/graphics/walkthrough-using-graphics-diagnostics-to-debug-a-compute-shader?view=vs-2019

Use Visual Studio Graphics Diagnostics to debug a compute shader written in HLSL (for Direct3D?).

# RenderDoc

https://renderdoc.org/docs/how/how_debug_shader.html

Shader debugging is currently only supported on D3D11, D3D12, and Vulkan.

- debugging a vertex is possible by selecting a mesh viewer and then selecting a vertex to debug
- debugging a pixel is possible by selecting that pixel's history
- debugging a compute thread can be possible by going to the pipeline state viewer

# Other strategies

- compile shader, check compiled shader's instructions
