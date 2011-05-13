function ill = reflectance_BlinnPhong(normal, albedo, light_dir, view_dir, material)
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
	
	
	H = (L + V) / norm(L + V);
	d2 = dot(H, N);
% 	R = 2 .* N .* d1 - L;
% 	d2 = dot(R,V);

	
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
		coeff = 0.10;
	elseif material == 'aan'
		coeff = 0.10;
	elseif material == 'aao'
		coeff = 0.10;
	elseif material == 'aar'
		coeff = 0.10;
	elseif material == 'aas'
		coeff = 0.10;
	elseif material == 'aba'
		coeff = 0.05;
	elseif material == 'abj'
		coeff = 0.05;
	elseif material == 'abk'
		coeff = 0.05;
	elseif material == 'acc'
		coeff = 0.05;
	elseif material == 'acd'
		coeff = 0.05;
	elseif material == 'ace'
		coeff = 0.05;
	elseif material == 'adb'
		coeff = 0.05;
	elseif material == 'adc'
		coeff = 0.05;
	elseif material == 'add'
		coeff = 0.05;
	elseif material == 'ade'
		coeff = 0.0;
	elseif material == 'adg'
		coeff = 0.05;
	elseif material == 'adh'
		coeff = 0.03;
	end
end


