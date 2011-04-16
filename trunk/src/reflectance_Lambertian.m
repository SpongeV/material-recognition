function irr = reflectance_Lambertian(normal, albedo, light_dir)


	light_dir(1) = deg2rad(light_dir(1));
	light_dir(2) = deg2rad(light_dir(2));

	light = [cos(double(light_dir(2)))*sin(double(light_dir(1))), ...
			 sin(double(light_dir(2)))*sin(double(light_dir(1))), ...
			 cos(double(light_dir(1)))];
		
	light = light / norm(light);

	I_l = 1.0;
	
	
% 	albedo
	normal = normal(:)';
	
	ambient_coeff = 0.0;
	diffuse_coeff = 1.0;
% 	shade = light(1)*normal(1) + light(2)*normal(2) + light(3)*normal(3);

	shade = dot(light, normal);
	
	
	if (shade < 0.0) 
		shade = 0;
	end
	
	
	irr = (ambient_coeff + diffuse_coeff * shade) * albedo * I_l;
end
