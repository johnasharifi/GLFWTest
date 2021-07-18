#version 330 core

// interpolated in frag shader
in vec2 texCoordUV;

out vec4 color;

// structs

struct Ray {
	vec3 origin;
	vec3 direction;
};

struct Light {
	vec3 color;
	vec3 direction;
};

struct Material {
	vec3 color;
	float diffuse;
	float specular;
};

struct Intersect {
	float len;
	vec3 normal;
	Material material;
};

struct Sphere {
	float radius;
	vec3 position;
	Material material;
};

struct Plane {
	vec3 normal;
	Material material;
};

// constants
const float epsilon = 1e-3;
const int iterations = 16;
const float exposure = 1e-2;
const float gamma = 2.2;
const float intensity = 100.0;
const vec3 ambient = vec3(0.6, 0.8, 1.0) * intensity / gamma;

// static light
Light light = Light(vec3(1.0) * intensity, normalize(vec3(-1.0, 0.75, 1.0)));
// worst-case intersection result
const Intersect miss = Intersect(0.0, vec3(0.0), Material(vec3(0.0), 0.0, 0.0));
// write a sphere intersection process
float iSphere4(in vec3 rOrigin, in float radiusScreen) {
	// don't even do light position yet, just direction
	vec3 lightDirection = vec3(0, 0, 1);

	// computes sphere surface intersection
	float f = clamp(radiusScreen - length(rOrigin), 0.0, 1.0);

	const float specThreshold = 0.1;
	// light intensity is based on alignment between viewer's viewDirection, and surface normal. for a sphere, the normal is probably fine to assume monotone and proportional to distance
	
	f = f + (f > 0? 1.0: 0.0) * pow(f - specThreshold, 2.0);
	f = clamp(f, 0.0, 1.0);

	return f;
}

void main()
{
	const float uvThreshold = 0.3;

	if (length(texCoordUV.xy - 0.5) > uvThreshold) {
		// regular red-green-yellow UV painting
		color = vec4(texCoordUV.xy, 0.0, 1.0);
	}
	else {
		float dist = iSphere4(vec3(texCoordUV.xy - 0.5, 0.0), 0.5);

		// draw a really bad sphere
		color = vec4(mod(dist, 1.0), 0.0, 0.0, 1.0);
	}
}
