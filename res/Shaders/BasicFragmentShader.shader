#version 330 core

// interpolated in frag shader
in vec2 texCoordUV;

out vec4 color;

// yoinked from https://www.shadertoy.com/view/tl23Rm by Inigo Quilez and Reinder Nijhoff
// Ray Tracing - Primitives. Created by Reinder Nijhoff 2019
// The MIT License
// @reindernijhoff
//
// https://www.shadertoy.com/view/tl23Rm
//
// I wanted to create a reference shader similar to "Raymarching - Primitives" 
// (https://www.shadertoy.com/view/Xds3zN), but with ray-primitive intersection 
// routines instead of sdf routines.
// 
// Sphere4:         https://www.shadertoy.com/view/3tj3DW

#define MAX_DIST 1e10
float dot2(in vec3 v) { return dot(v, v); }

// Sphere4:         https://www.shadertoy.com/view/3tj3DW
float iSphere4(in vec3 ro, in vec3 rd, in vec2 distBound, inout vec3 normal,
	in float ra) {
	// -----------------------------
	// solve quartic equation
	// -----------------------------

	float r2 = ra * ra;

	vec3 d2 = rd * rd; vec3 d3 = d2 * rd;
	vec3 o2 = ro * ro; vec3 o3 = o2 * ro;

	float ka = 1.0 / dot(d2, d2);

	float k0 = ka * dot(ro, d3);
	float k1 = ka * dot(o2, d2);
	float k2 = ka * dot(o3, rd);
	float k3 = ka * (dot(o2, o2) - r2 * r2);

	// -----------------------------
	// solve cubic
	// -----------------------------

	float c0 = k1 - k0 * k0;
	float c1 = k2 + 2.0*k0*(k0*k0 - (3.0 / 2.0)*k1);
	float c2 = k3 - 3.0*k0*(k0*(k0*k0 - 2.0*k1) + (4.0 / 3.0)*k2);

	float p = c0 * c0*3.0 + c2;
	float q = c0 * c0*c0 - c0 * c2 + c1 * c1;
	float h = q * q - p * p*p*(1.0 / 27.0);

	// -----------------------------
	// skip the case of 3 real solutions for the cubic, which involves 
	// 4 complex solutions for the quartic, since we know this objcet is 
	// convex
	// -----------------------------
	if (h < 0.0) {
		return MAX_DIST;
	}

	// one real solution, two complex (conjugated)
	h = sqrt(h);

	float s = sign(q + h)*pow(abs(q + h), 1.0 / 3.0); // cuberoot
	float t = sign(q - h)*pow(abs(q - h), 1.0 / 3.0); // cuberoot

	vec2 v = vec2((s + t) + c0 * 4.0, (s - t)*sqrt(3.0))*0.5;

	// -----------------------------
	// the quartic will have two real solutions and two complex solutions.
	// we only want the real ones
	// -----------------------------

	float r = length(v);
	float d = -abs(v.y) / sqrt(r + v.x) - c1 / r - k0;

	if (d >= distBound.x && d <= distBound.y) {
		vec3 pos = ro + rd * d;
		normal = normalize(pos*pos*pos);
		return d;
	}
	else {
		return MAX_DIST;
	}
}

void main()
{
	// float dist = iSphere4()
	color = vec4(1.0, texCoordUV.x, texCoordUV.y, 1.0);
}
