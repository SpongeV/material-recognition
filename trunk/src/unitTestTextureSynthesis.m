function unitTestTextureSynthesis(angle, azimuth)
% example: unitTestTextureSynthesis(angle, azimuth)
% 	close all;
	im = {};

% 	angle	= 60;
% 	azimuth = 300;
	no = 4;

%% TARGHI PHOTEX DATABASE EXAMPLES	
	directory = '../photex/'

% 	im{1} = '0.aaa.0.30.0.bmp'
% 	im{2} = '0.aaa.0.30.90.bmp'
% 	im{3} = '0.aaa.0.30.180.bmp'
% 	im{4} = '0.aaa.0.30.270.bmp'

	im{1} = '0.aab.0.30.0.bmp'
	im{2} = '0.aab.0.30.90.bmp'
	im{3} = '0.aab.0.30.180.bmp'
	im{4} = '0.aab.0.30.270.bmp'

% 	im{1} = '1.acd.0.75.30.bmp'
% 	im{2} = '1.acd.0.75.120.bmp'
% 	im{3} = '1.acd.0.75.210.bmp'
% 	im{4} = '1.acd.0.75.300.bmp'

% 	im{1} = '2.adg.0.30.0.bmp'
% 	im{2} = '2.adg.0.30.90.bmp'
% 	im{3} = '2.adg.0.30.180.bmp'
% 	im{4} = '2.adg.0.30.270.bmp'

% 	im{1} = '0.aar.0.30.0.bmp'
% 	im{2} = '0.aar.0.30.90.bmp'
% 	im{3} = '0.aar.0.30.180.bmp'
% 	im{4} = '0.aar.0.30.270.bmp'


%% FULL PHOTEX DATABASE EXAMPLES
% 	directory = '../DATABASE_PHOTEX/';

% 	im{1} = '3.vm32.0.75.0.bmp'
% 	im{2} = '3.vm32.0.75.90.bmp'
% 	im{3} = '3.vm32.0.75.180.bmp'
% 	im{4} = '3.vm32.0.75.270.bmp'

% 	im{1} = '3.vm63.0.75.0.bmp'
% 	im{2} = '3.vm63.0.75.90.bmp'
% 	im{3} = '3.vm63.0.75.180.bmp'
% 	im{4} = '3.vm63.0.75.270.bmp'
% 
	[albedo, normals] = PhotometricStereo(im, directory, 0, 0);
	
	for n=angle
		for m=azimuth

			parts = strsplit('.',im{3});
			original_image = imcrop(imread(strcat(directory,parts{2},'/', ... 
									parts{1},'.',parts{2},'.',parts{3},'.',int2str(n),'.',int2str(m),'.',parts{6})), ... 
									[156 156 200 200]);
			original_image = im2double(original_image(:,:,1));
			
			synthesized_img1 = zeros(size(albedo));
			synthesized_img2 = zeros(size(albedo));
			synthesized_img3 = zeros(size(albedo));

			for i=1:size(albedo,1)
				for j=1:size(albedo,2)
					irr1 = reflectance_Lambertian(	normals(i,j,:), albedo(i,j), [n m]);
					irr3 = reflectance_Phong(		normals(i,j,:), albedo(i,j), [n m], [0 0], parts{2});
% 					irr3 = reflectance_OrenNayar(	normals(i,j,:), albedo(i,j), [n m], [0 0]);
					synthesized_img1(i,j) = irr1;
% 					synthesized_img2(i,j) = irr2;
					synthesized_img3(i,j) = irr3;
				end
			end

% 			synthesized_img1 = synthesized_img1 / max(synthesized_img1(:));
% 			synthesized_img2 = synthesized_img2 / max(synthesized_img2(:));
% 			synthesized_img3 = synthesized_img3 / max(synthesized_img3(:));

			img_combined = (synthesized_img1 + synthesized_img3) / 2.0;

			img_diff1 = (im2double(original_image) - im2double(synthesized_img1))^2;
			img_diff2 = (im2double(original_image) - im2double(synthesized_img3))^2;
			img_diff3 = (im2double(original_image) - im2double(img_combined))^2;
			error1 = sum(img_diff1(:));
			error2 = sum(img_diff2(:));
			error3 = sum(img_diff2(:));
			
			error1 > error2
% 			error1 > error3
			
			figure; 
			subplot(2,3,1); imshow(original_image);
			subplot(2,3,2); imshow(synthesized_img1,[]);
%			subplot(2,3,3); imshow(synthesized_img2,[]);
			subplot(2,3,3); imshow(synthesized_img3,[]);
			subplot(2,3,4); imshow(img_diff1,[]);
			subplot(2,3,5); imshow(img_diff2,[]);
			subplot(2,3,6); imshow(img_combined,[]);
		end
	end
end

% shafer reflection model