Add notes on the shader that we sourced from user "Polytonic" on Shadertoy https://www.shadertoy.com/view/4ljGRd.

# Overview

This file documents the general behavior of ray-tracing in pure GLSL as implemented in BasicFragmentShader.shader.

# The process for computing the albedo result of a ray trace

	vec3 radiance(Ray ray) {
		vec3 color = vec3(0.0), fresnel = vec3(0.0);
		vec3 mask = vec3(1.0);
		// for n ray-trace steps:
		for (int i = 0; i <= iterations; ++i) {
			Intersect hit = trace(ray);

			// func "trace" fires a ray. if "trace" returns a ray which hit something: then continue process
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
				// advance the ray along the ray's path. due to for loop, we will re-run raytracing
				ray = Ray(ray.origin + hit.len * ray.direction + epsilon * reflection, reflection);

			}
			else {
				vec3 spotlight = vec3(1e6) * pow(abs(dot(ray.direction, light.direction)), 250.0);
				color += mask * (ambient + spotlight); break;
        // else: did not hit an object. in which case, we break out of for loop and return an ambient color with some minor light effect
			}
		}
		return color;
	}
  
  # The process for computing the result of a single ray-trace
  
  	// this process recruits mathematical properties of spheres and planes to compute ray TRACING results with faster processes than ray MARCHING.
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
