function ill = PhongShading(normal, albedo, lightDir, viewDir)
	% PhongShading - derived from Computer Graphics: Principle & Practice
	% (p. 729)
	% normal   - normal of the surface at intersection point
	% albedo   - the reflectance of the texture at intersection point
	% lightDir - the direction of the light source
	% viewDir  - the direction of the viewer

	normal = normal(:)';
	N = normal/norm(normal);
	L = lightDir/norm(lightDir);
	V = viewDir/norm(viewDir);

	ambient_coeff = 0.0;
	diffuse_coeff = 1.0;
	
	lightColor = 1.0;
	alpha = 1;
	
	d1 = dot(L,N);

	ill = (albedo*diffuse_coeff * lightColor * min(1.0, max(0.0, d1)));
	
	R = 2 .* N .* d1 - L;
	d2 = dot(R,V);
	
	specularReflectionCoeff = 1.0;
	specularColor = 1.0;
	if (specularReflectionCoeff > 0.0)
		if (d2 > 0.0)
			ill = ill + (specularColor*specularReflectionCoeff) * (lightColor * d2^alpha);
		end
	end
	
end