function irr = reflectance_OrenNayar(normal, albedo, light_dir, view_dir)
	% Oren-Nayar reflectance - source: Physically Based Rendering
	% (p. 449)
	% normal   - normal of the surface at intersection point
	% albedo   - the reflectance of the texture at intersection point
	% light_dir - the direction of the light source 
	%				[slant tilt] or [polar_angle azimuth]
	% viewDir  - the direction of the viewer
	%				[slant tilt] or [polar_angle azimuth]

	% convert to radians
	light_dir = deg2rad(light_dir);
	view_dir = deg2rad(view_dir);

	lightDir = [cos(double(light_dir(2)))*sin(double(light_dir(1))), ...
				sin(double(light_dir(2)))*sin(double(light_dir(1))), ...
				cos(double(light_dir(1)))];	
	lightDir = lightDir/norm(lightDir);

	viewDir	 = [cos(double(view_dir(2)))*sin(double(view_dir(1))), ...
				sin(double(view_dir(2)))*sin(double(view_dir(1))), ...
				cos(double(view_dir(1)))];		
	viewDir  = viewDir/norm(viewDir);
	

	normal = normal(:)';
	cos_theta_i = dot(lightDir, normal);
	cos_theta_r = dot(viewDir, normal);


	
	alpha = max(view_dir(1), light_dir(1));
	beta  = min(view_dir(1), light_dir(1));

	L_i		= 0.5;
	sigma	= 0.5;
	sigma_sqr = sigma^2;
	albedo = albedo;
	
	% Shadowing and Masking
	C1 = 1 - 0.5 * (sigma_sqr / ((sigma_sqr + 0.33)));

	C2 = 0;
	if (cos(viewDir(2) - lightDir(2)) >= 0)
		C2 = 0.45 *(sigma_sqr / (sigma_sqr + 0.09)) * sin(alpha);
	else
		C2 = 0.45 * (sigma_sqr / (sigma_sqr + 0.09)) * (sin(alpha) - ((2*beta) / pi)^3);
	end
	C3 = 0.125 * (sigma_sqr / (sigma_sqr + 0.09)) * ((4 * alpha * beta) / (pi^2))^2;
	
	L_r1 = (albedo/pi) * L_i * cos_theta_i * ...
					(C1 + (cos(viewDir(2) - lightDir(2)) * C2 * tan(beta)) + ... 
					(1 - abs(cos(viewDir(2) - lightDir(2)))) * C3 * tan((alpha+beta)/2));
	
	L_r2 = 0.17 * (albedo^2/pi) * L_i * cos_theta_i * (sigma^2 / (sigma_sqr + 0.13)) * (1 - cos(viewDir(2) - lightDir(2))*((2*beta)/ pi)^2);
	
	
	irr = L_r1 + L_r2;
	
% 	% L_i represents the intensity of the light source. For generating data
% 	% however, this parameter only needs to be > 0; all images are
% 	% preprocessed to have zero mean and unit variance.
% 	L_i = 6.0;
% 
% 	albedo = albedo / pi;
% 
% 
% 	% sigma is the parameter to control the roughness of the surface; 0 is
% 	% a flat surface (converging to Lambertian), 1 is for a very rough
% 	% surface.
% 	sigma = 1.0;
% 	A = 1 - (sigma^2 / (2 * (sigma^2 + 0.33)));
% 	B = (0.45 * sigma^2) / (sigma^2 + 0.09);
% 
% 	alpha = max(view_dir(1), light_dir(1));
% 	beta  = min(view_dir(1), light_dir(1));
% 
% % 	irr = albedo * (A + B * max(0, cos(rad_i - rad_o))*sin(alpha)*tan(beta'));
% 
% 
% 	irr = albedo * cos_theta_i * (A + B * max(0, cos(light_dir(2) - view_dir(2)))*sin(alpha)*tan(beta)) * L_i;

end

function sigma = material_sigma(material)
	% define a lookup table for sigma for the 20 materials
	sigma = 0.0;
	if material == 'aam'
		sigma = 0.4;
	elseif material == 'adg'
		sigma = 0.0;
	end
end
