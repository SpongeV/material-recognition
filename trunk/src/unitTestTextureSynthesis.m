function unitTestTextureSynthesis()
% 	close all;
	im = {};

	angle = 30;
	
% 	directory = '../Photex/';
% 	im{1} = '0.aaa.0.30.0.bmp'
% 	im{2} = '0.aaa.0.30.90.bmp'
% 	im{3} = '0.aaa.0.30.180.bmp'
% 	im{4} = '0.aaa.0.30.270.bmp'

% 	directory = '../Photex/';
% 	im{1} = '1.acd.0.75.0.bmp'
% 	im{2} = '1.acd.0.75.90.bmp'
% 	im{3} = '1.acd.0.75.180.bmp'
% 	im{4} = '1.acd.0.75.270.bmp'

% 	directory = '../DB_PHOTEX/';
% 	im{1} = '3.vm32.0.75.0.bmp'
% 	im{2} = '3.vm32.0.75.90.bmp'
% 	im{3} = '3.vm32.0.75.180.bmp'
% 	im{4} = '3.vm32.0.75.270.bmp'

	directory = '../Photex/';
	im{1} = '2.adg.0.30.0.bmp'
	im{2} = '2.adg.0.30.90.bmp'
	im{3} = '2.adg.0.30.180.bmp'
	im{4} = '2.adg.0.30.270.bmp'



	[albedo, normals] = PhotometricStereo(im, directory, 0, 0);
	
	parts = strsplit('.',im{3});
	original_image = imcrop(imread(strcat(directory,parts{2},'/',im{3})), [156 156 200 200]);
% 	original_image = imread(strcat(directory,parts{2},'/',im{3}));
	
	synthesized_img1 = zeros(size(albedo));
	synthesized_img2 = zeros(size(albedo));
	synthesized_img3 = zeros(size(albedo));

	for i=1:size(albedo,1)
		for j=1:size(albedo,2)
			irr1 = reflectance_Lambertian(normals(i,j,:), albedo(i,j), [angle 180]);
			irr2 = reflectance_Phong(normals(i,j,:), albedo(i,j), [angle 180], [0 0]);
			irr3 = reflectance_OrenNayar(normals(i,j,:), albedo(i,j), [angle 180], [0 0]);
			synthesized_img1(i,j) = irr1;
			synthesized_img2(i,j) = irr2;
			synthesized_img3(i,j) = irr3;
		end
	end
	
	synthesized_img1 = synthesized_img1 / max(synthesized_img1(:));
	synthesized_img2 = synthesized_img2 / max(synthesized_img2(:));
	synthesized_img3 = synthesized_img3 / max(synthesized_img3(:));
	
	figure; 
	subplot(2,2,1); imshow(original_image);
	subplot(2,2,2); imshow(synthesized_img1);
	subplot(2,2,3); imshow(synthesized_img2);
	subplot(2,2,4); imshow(synthesized_img3);
end

% shafer reflection model