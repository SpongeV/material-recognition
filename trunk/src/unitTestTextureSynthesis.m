function unitTestTextureSynthesis()
	im = {};
	directory = '../Photex/';
	im{1} = '1.acd.0.30.0.bmp'
	im{2} = '1.acd.0.30.90.bmp'
	im{3} = '1.acd.0.30.180.bmp'
	im{4} = '1.acd.0.30.270.bmp'
	
	[albedo, normals] = PhotometricStereo(im, directory, 0, 1);
	
	synthesized_img1 = zeros(size(albedo));
	synthesized_img2 = zeros(size(albedo));

	for i=1:size(albedo,1)
		for j=1:size(albedo,2)
			irr1 = lambertShading(normals(i,j,:), albedo(i,j), [0,10,10]);
			irr2 = phongShading(normals(i,j,:), albedo(i,j),[0,10,10],[0,0,10000]);
			synthesized_img1(i,j) = irr1;
			synthesized_img2(i,j) = irr2;
		end
	end
	
	figure; imshow(synthesized_img1,[]);
	figure; imshow(synthesized_img2,[]);

end

% shafer reflection model