function unitTestTextureSynthesis(angle, azimuth, verbose)
% example: unitTestTextureSynthesis(angle, azimuth)
	close all;
	im = {};

% 	angle	= 60;
% 	azimuth = 300;
	no = 4;

%% TARGHI PHOTEX DATABASE EXAMPLES	
	directory = '../photex/';

	% due to the enormous variation in how to test the data, I consider
	% only a part of the data, and perform PS on the most desirable angles
	% unitTestTextureSynthesis([30 45 60 75], [0 90 180 270],0);
	
	% PHONG: 8 / 16
% 	im{1} = '0.aaa.0.30.0.bmp'
% 	im{2} = '0.aaa.0.30.90.bmp'
% 	im{3} = '0.aaa.0.30.180.bmp'
% 	im{4} = '0.aaa.0.30.270.bmp'

	% PHONG: 10 / 16
% 	im{1} = '0.aab.0.30.0.bmp'
% 	im{2} = '0.aab.0.30.90.bmp'
% 	im{3} = '0.aab.0.30.180.bmp'
% 	im{4} = '0.aab.0.30.270.bmp'

	% PHONG: 4 / 16
% 	im{1} = '0.aaj.0.30.0.bmp'
% 	im{2} = '0.aaj.0.30.90.bmp'
% 	im{3} = '0.aaj.0.30.180.bmp'
% 	im{4} = '0.aaj.0.30.270.bmp'
	
	% PHONG: 8 / 16
% 	im{1} = '0.aam.0.30.0.bmp'
% 	im{2} = '0.aam.0.30.90.bmp'
% 	im{3} = '0.aam.0.30.180.bmp'
% 	im{4} = '0.aam.0.30.270.bmp'

	% PHONG: 11 / 16
% 	im{1} = '0.aan.0.30.0.bmp'
% 	im{2} = '0.aan.0.30.90.bmp'
% 	im{3} = '0.aan.0.30.180.bmp'
% 	im{4} = '0.aan.0.30.270.bmp'

	% PHONG: 8 / 16
% 	im{1} = '0.aao.0.30.0.bmp'
% 	im{2} = '0.aao.0.30.90.bmp'
% 	im{3} = '0.aao.0.30.180.bmp'
% 	im{4} = '0.aao.0.30.270.bmp'

	% PHONG: 8 / 16
% 	im{1} = '0.aar.0.30.0.bmp'
% 	im{2} = '0.aar.0.30.90.bmp'
% 	im{3} = '0.aar.0.30.180.bmp'
% 	im{4} = '0.aar.0.30.270.bmp'

	% PHONG: 10 / 16
% 	im{1} = '0.aas.0.30.0.bmp'
% 	im{2} = '0.aas.0.30.90.bmp'
% 	im{3} = '0.aas.0.30.180.bmp'
% 	im{4} = '0.aas.0.30.270.bmp'

	% PHONG: 9 / 16
% 	im{1} = '0.aba.0.30.0.bmp'
% 	im{2} = '0.aba.0.30.90.bmp'
% 	im{3} = '0.aba.0.30.180.bmp'
% 	im{4} = '0.aba.0.30.270.bmp'

	% PHONG: 10 / 16
% 	im{1} = '0.abj.0.30.0.bmp'
% 	im{2} = '0.abj.0.30.90.bmp'
% 	im{3} = '0.abj.0.30.180.bmp'
% 	im{4} = '0.abj.0.30.270.bmp'

	% PHONG: 12 / 16
% 	im{1} = '0.abk.0.30.0.bmp'
% 	im{2} = '0.abk.0.30.90.bmp'
% 	im{3} = '0.abk.0.30.180.bmp'
% 	im{4} = '0.abk.0.30.270.bmp'
	
	% PHONG: 13 / 16
% 	im{1} = '1.acc.0.30.0.bmp'
% 	im{2} = '1.acc.0.30.90.bmp'
% 	im{3} = '1.acc.0.30.180.bmp'
% 	im{4} = '1.acc.0.30.270.bmp'

	% PHONG: 8 / 16
% 	im{1} = '1.acd.0.30.0.bmp'
% 	im{2} = '1.acd.0.30.90.bmp'
% 	im{3} = '1.acd.0.30.180.bmp'
% 	im{4} = '1.acd.0.30.270.bmp'

	% PHONG: 8 / 16
% 	im{1} = '1.ace.0.30.0.bmp'
% 	im{2} = '1.ace.0.30.90.bmp'
% 	im{3} = '1.ace.0.30.180.bmp'
% 	im{4} = '1.ace.0.30.270.bmp'

	% PHONG: 8 / 16
% 	im{1} = '1.adb.0.30.0.bmp'
% 	im{2} = '1.adb.0.30.90.bmp'
% 	im{3} = '1.adb.0.30.180.bmp'
% 	im{4} = '1.adb.0.30.270.bmp'


	% PHONG: 12 / 16
% 	im{1} = '1.adc.0.30.0.bmp'
% 	im{2} = '1.adc.0.30.90.bmp'
% 	im{3} = '1.adc.0.30.180.bmp'
% 	im{4} = '1.adc.0.30.270.bmp'

	% PHONG: 10 / 16
% 	im{1} = '1.add.0.30.0.bmp'
% 	im{2} = '1.add.0.30.90.bmp'
% 	im{3} = '1.add.0.30.180.bmp'
% 	im{4} = '1.add.0.30.270.bmp'

	% PHONG: 10 / 16
% 	im{1} = '1.ade.0.30.0.bmp'
% 	im{2} = '1.ade.0.30.90.bmp'
% 	im{3} = '1.ade.0.30.180.bmp'
% 	im{4} = '1.ade.0.30.270.bmp'
	
	% PHONG: 11 / 16
% 	im{1} = '2.adg.0.30.0.bmp'
% 	im{2} = '2.adg.0.30.90.bmp'
% 	im{3} = '2.adg.0.30.180.bmp'
% 	im{4} = '2.adg.0.30.270.bmp'

	% PHONG: 7 / 16
	im{1} = '2.adh.0.30.0.bmp'
	im{2} = '2.adh.0.30.90.bmp'
	im{3} = '2.adh.0.30.180.bmp'
	im{4} = '2.adh.0.30.270.bmp'


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
	[albedo, normals] = photometricStereo(im, directory, 0, 0);

	improved = 0;
	total = 0;
	for n=angle
		for m=azimuth

			parts = strsplit('.',im{3});
			original_image = imcrop(imread(strcat(directory,parts{2},'/', ... 
									parts{1},'.',parts{2},'.',parts{3},'.',int2str(n),'.',int2str(m),'.',parts{6})), ... 
									[156 156 200 200]);
			original_image = im2double(original_image(:,:,1));
			original_image = (original_image-mean(original_image(:)))/var(original_image(:));

			
			synthesized_img1 = zeros(size(albedo));
			synthesized_img2 = zeros(size(albedo));
% 			synthesized_img3 = zeros(size(albedo));

			for i=1:size(albedo,1)
				for j=1:size(albedo,2)
					irr1 = reflectance_Lambertian(	normals(i,j,:), albedo(i,j), [n m]);
					irr2 = reflectance_Phong(		normals(i,j,:), albedo(i,j), [n m], [0 0], parts{2});
% 					irr2 = reflectance_BlinnPhong(	normals(i,j,:), albedo(i,j), [n m], [0 0], parts{2});
% 					irr3 = reflectance_OrenNayar(	normals(i,j,:), albedo(i,j), [n m], [0 0]);
					synthesized_img1(i,j) = irr1;
					synthesized_img2(i,j) = irr2;
% 					synthesized_img3(i,j) = irr3;
				end
			end

% 			synthesized_img1 = synthesized_img1 / max(synthesized_img1(:));
% 			synthesized_img2 = synthesized_img2 / max(synthesized_img2(:));
% 			synthesized_img3 = synthesized_img3 / max(synthesized_img3(:));

% 			img_combined = (synthesized_img1 + synthesized_img3) / 2.0;

			synthesized_img1 = (synthesized_img1-mean(synthesized_img1(:)))/std(synthesized_img1(:));
			synthesized_img2 = (synthesized_img2-mean(synthesized_img2(:)))/std(synthesized_img2(:));
% 			synthesized_img3 = (synthesized_img3-mean(synthesized_img3(:)))/std(synthesized_img3(:));

			img_diff1 = (im2double(original_image) - im2double(synthesized_img1)).^2;
			img_diff2 = (im2double(original_image) - im2double(synthesized_img2)).^2;
% 			img_diff3 = (im2double(original_image) - im2double(synthesized_img3)).^2;
% 			img_diff4 = (im2double(original_image) - im2double(img_combined)).^2;
			error1 = sum(img_diff1(:));
			error2 = sum(img_diff2(:));
% 			error3 = sum(img_diff3(:));
% 			error4 = sum(img_diff4(:));

			fprintf('\tError_Lambertian: \t%d\n', error1);
			fprintf('\tError_Phong: \t%d\n', error2);
% 			fprintf('\tError_OrenNayar: \t%d\n', error3);
% 			fprintf('\tError_Combined: \t%d\n', error4);
			fprintf('\tError_Lambertian > Error_Phong %d\n', error1 > error2);
			
			if error1 > error2
				improved = improved + 1;
			end
			total = total + 1;
% 			fprintf('\tError_Lambertian > Error_OrenNayar %d\n', error1 > error3);
% 			fprintf('\tError_Lambertian > Error_Combined %d\n', error1 > error4);

			if verbose == 1
				figure; 
				subplot(2,4,1); imshow(synthesized_img1,[]);
				subplot(2,4,2); imshow(synthesized_img2,[]);
% 				subplot(2,4,3); imshow(synthesized_img3,[]);
% 				subplot(2,4,4); imshow(img_combined,[]);
				subplot(2,4,5); imshow(img_diff1,[]);
				subplot(2,4,6); imshow(img_diff2,[]);
% 				subplot(2,4,7); imshow(img_diff3,[]);
% 				subplot(2,4,8); imshow(img_diff4,[]);
			end
		end
	end
	
	fprintf('Improved: %d / %d\n', improved, total);
end