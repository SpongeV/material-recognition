function irr = lambertShading(normal, albedo, light)

	irr = 0;
	ambient_coeff = 0;
	diffuse_coeff = 1;
	shade = light(1)*normal(1) + light(2)*normal(2) + light(3)*normal(3);
	if (shade < 0.0) 
		shade = 0;
	end
	
	irr = (ambient_coeff + diffuse_coeff * shade) * albedo;
		
end