function irr = reflectance_OrenNayar(normal, albedo, light_dir, view_dir)
	% Oren-Nayar reflectance - source: Physically Based Rendering
	% (p. 449)
	% normal   - normal of the surface at intersection point
	% albedo   - the reflectance of the texture at intersection point
	% light_dir - the direction of the light source 
	%				[slant tilt] or [polar_angle azimuth]
	% viewDir  - the direction of the viewer
	%				[slant tilt] or [polar_angle azimuth]

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
	

	cos_theta_i = lightDir(1)*normal(1) + lightDir(2)*normal(2) + lightDir(3)*normal(3);

	L_i = 1.0;

	albedo = albedo / pi;

	% convert to radians
	light_dir = light_dir * (pi/180);
	view_dir = view_dir * (pi/180);



	% sigma is the parameter to control the roughness of the surface; 0 is
	% a flat surface (converging to Lambertian), 1 is for a very rough
	% surface.
	sigma = 0.3;
	A = 1 - (sigma^2 / (2 * (sigma^2 + 0.33)));
	B = (0.45 * sigma^2) / (sigma^2 + 0.09);

	alpha = max(view_dir(1), light_dir(1));
	beta  = min(view_dir(1), light_dir(1));

% 	irr = albedo * (A + B * max(0, cos(rad_i - rad_o))*sin(alpha)*tan(beta'));

% 	irr = albedo * cos(light_dir(1)) * (A + B * max(0, cos(light_dir(2) - view_dir(2)))*sin(alpha)*tan(beta')) * L_i;
	irr = albedo * cos_theta_i * (A + B * max(0, cos(light_dir(2) - view_dir(2)))*sin(alpha)*tan(beta')) * L_i;

end