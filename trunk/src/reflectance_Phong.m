function ill = reflectance_Phong(normal, albedo, light_dir, view_dir, material)
	% PhongShading - derived from Computer Graphics: Principle & Practice
	% (p. 729)
	% normal   - normal of the surface at intersection point
	% albedo   - the reflectance of the texture at intersection point
	% lightDir - the direction of the light source
	% viewDir  - the direction of the viewer

	
	light_dir	= deg2rad(light_dir);
	view_dir	= deg2rad(view_dir);
	
	lightDir	= [cos(double(light_dir(2)))*sin(double(light_dir(1))), ...
				   sin(double(light_dir(2)))*sin(double(light_dir(1))), ...
				   cos(double(light_dir(1)))];	

	viewDir		= [cos(double(view_dir(2)))*sin(double(view_dir(1))), ...
				   sin(double(view_dir(2)))*sin(double(view_dir(1))), ...
				   cos(double(view_dir(1)))];		
	viewDir = viewDir/norm(viewDir);
	
	normal = normal(:)';
	N = normal/norm(normal);
	L = lightDir/norm(lightDir);
	V = viewDir/norm(viewDir);

	ambient_coeff = 0.0;
	diffuse_coeff = 1.0;
	
	lightColor = 1.0;
	coeff = material_coefficients(material);
	alpha = coeff(1);
	
	d1 = dot(L,N);

	ill = (albedo * diffuse_coeff * lightColor * min(1.0, max(0.0, d1)));
	
	R = 2 .* N .* d1 - L;
	d2 = dot(R,V);
	
	specularReflectionCoeff = coeff(2);
	specularColor = 1.0;
	if (specularReflectionCoeff > 0.0)
		if (d2 > 0.0)
			ill = ill + (specularColor*specularReflectionCoeff) * (lightColor * d2^alpha);
		end
	end
	
end

function coeff = material_coefficients(material)
	% define a lookup table for the specular reflection coefficient for the 20 materials
	coeff(1) = 0.0;
	coeff(2) = 0.0;
	if material == 'aaa'
		coeff(1) = 0.010;
		coeff(2) = 0.001;
	elseif material == 'aab'
		coeff(1) = 0.010;
		coeff(2) = 0.001;
	elseif material == 'aaj'
		coeff(1) = 0.010;
		coeff(2) = 0.001;
	elseif material == 'aam'
		coeff(1) = 0.020;
		coeff(2) = 0.001;
	elseif material == 'aan'
		coeff(1) = 10.0;
		coeff(2) = 0.001;
	elseif material == 'aao'
		coeff(1) = 0.01;
		coeff(2) = 0.001;
	elseif material == 'aar'
		coeff(1) = 10.0;
		coeff(2) = 0.001;
	elseif material == 'aas'
		coeff(1) = 0.010;
		coeff(2) = 0.001;
	elseif material == 'aba'
		coeff(1) = 10.010;
		coeff(2) = 0.001;
	elseif material == 'abj'
		coeff(1) = 10.0;
		coeff(2) = 0.001;
	elseif material == 'abk'
		coeff(1) = 0.010;
		coeff(2) = 0.001;
	elseif material == 'acc'
		coeff(1) = 10.0;
		coeff(2) = 0.001;
	elseif material == 'acd'
		coeff(1) = 10.0;
		coeff(2) = 0.001;
	elseif material == 'ace'
		coeff(1) = 0.010;
		coeff(2) = 0.001;
	elseif material == 'adb'
		coeff(1) = 40.0;
		coeff(2) = 0.001;
	elseif material == 'adc'
		coeff(1) = 40.0;
		coeff(2) = 0.001;
	elseif material == 'add'
		coeff(1) = 50.0;
		coeff(2) = 0.001;
	elseif material == 'ade'
		coeff(1) = 40.0;
		coeff(2) = 0.001;
	elseif material == 'adg'
		coeff(1) = 40.0;
		coeff(2) = 0.001;
	elseif material == 'adh'
		coeff(1) = 40.0;
		coeff(2) = 0.001;
	end
end


