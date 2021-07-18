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

// ray-sphere intersection result
Intersect intersect(Ray ray, Sphere sphere) {
	// Check for a Negative Square Root
	vec3 oc = sphere.position - ray.origin;
	float l = dot(ray.direction, oc);
	float det = pow(l, 2.0) - dot(oc, oc) + pow(sphere.radius, 2.0);
	if (det < 0.0) return miss;

	// Find the Closer of Two Solutions
	float len = l - sqrt(det);
	if (len < 0.0) len = l + sqrt(det);
	if (len < 0.0) return miss;
	return Intersect(len, (ray.origin + len * ray.direction - sphere.position) / sphere.radius, sphere.material);
}

// ray-plane intersection result
Intersect intersect(Ray ray, Plane plane) {
	float len = -dot(ray.origin, plane.normal) / dot(ray.direction, plane.normal);
	if (len < 0.0) return miss;
	return Intersect(len, plane.normal, plane.material);
}

// trace a ray through a scene. sets up some spheres and planes in a scene, computes intersections with geometry given ray
Intersect trace(Ray ray) {
	const int num_spheres = 3;
	Sphere spheres[num_spheres];

	// no iTime in this GL framework. TODO later support passing in iTime for parity with shadertoy
	const float iTime = 0.0;
	spheres[0] = Sphere(2.0, vec3(-4.0, 3.0 + sin(iTime), 0), Material(vec3(1.0, 0.0, 0.2), 1.0, 0.001));
	spheres[1] = Sphere(3.0, vec3(4.0 + cos(iTime), 3.0, 0), Material(vec3(0.0, 0.2, 1.0), 1.0, 0.0));
	spheres[2] = Sphere(1.0, vec3(0.5, 1.0, 6.0), Material(vec3(1.0, 1.0, 1.0), 0.5, 0.25));

	Intersect intersection = miss;
	Intersect plane = intersect(ray, Plane(vec3(0, 1, 0), Material(vec3(1.0, 1.0, 1.0), 1.0, 0.0)));
	if (plane.material.diffuse > 0.0 || plane.material.specular > 0.0) { intersection = plane; }
	for (int i = 0; i < num_spheres; i++) {
		Intersect sphere = intersect(ray, spheres[i]);
		if (sphere.material.diffuse > 0.0 || sphere.material.specular > 0.0)
			intersection = sphere;
	}
	return intersection;
}

// fire a series of rays through the scene. when we have bounce events, bounce the ray
vec3 radiance(Ray ray) {
	vec3 color = vec3(0.0), fresnel = vec3(0.0);
	vec3 mask = vec3(1.0);
	for (int i = 0; i <= iterations; ++i) {
		Intersect hit = trace(ray);

		if (hit.material.diffuse > 0.0 || hit.material.specular > 0.0) {
			vec3 r0 = hit.material.color.rgb * hit.material.specular;
			float hv = clamp(dot(hit.normal, -ray.direction), 0.0, 1.0);
			fresnel = r0 + (1.0 - r0) * pow(1.0 - hv, 5.0);
			mask *= fresnel;

			if (trace(Ray(ray.origin + hit.len * ray.direction + epsilon * light.direction, light.direction)) == miss) {
				color += clamp(dot(hit.normal, light.direction), 0.0, 1.0) * light.color
					* hit.material.color.rgb * hit.material.diffuse
					* (1.0 - fresnel) * mask / fresnel;
			}

			vec3 reflection = reflect(ray.direction, hit.normal);
			ray = Ray(ray.origin + hit.len * ray.direction + epsilon * reflection, reflection);

		}
		else {
			vec3 spotlight = vec3(1e6) * pow(abs(dot(ray.direction, light.direction)), 250.0);
			color += mask * (ambient + spotlight); break;
		}
	}
	return color;
}

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
