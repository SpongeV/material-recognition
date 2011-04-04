function irr = reflectance_Lambertian(normal, albedo, light_dir)

	light = [cos(double(light_dir(2)))*sin(double(light_dir(1))), ...
			sin(double(light_dir(2)))*cos(double(light_dir(1))), ...
			cos(double(light_dir(1)))];
	light = light/norm(light);

	ambient_coeff = 0;
	diffuse_coeff = 1;
	shade = light(1)*normal(1) + light(2)*normal(2) + light(3)*normal(3);

	if (shade < 0.0) 
		shade = 0;
	end
	
	irr = (ambient_coeff + diffuse_coeff * shade) * albedo;
	
end