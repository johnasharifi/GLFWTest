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
  
