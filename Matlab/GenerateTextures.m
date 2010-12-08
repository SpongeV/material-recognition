function GenerateTextures(images, directory, n, s, type, verbose)
% images - (cell) list of image names from PhoTex database
% directory - path to the PhoTex database
% n - number of images to generate
% verbose - display debug info
% s - used for resizing
	G1Set(images, directory, n, s, type, verbose);
end

function G1Set(images, directory, n, s, type, verbose)
	fprintf('Number of instances used for PS:%d\n', length(images));	

	if (type == 1)
		[albedo, normals] = PhotometricStereo(images,directory, s, 1);
	else
		[albedo, normals] = PhotometricStereo2(images,directory, s, 1);
	end
	imsize = size(albedo);
	
	synthesized_img1 = zeros(imsize);
	synthesized_img2 = zeros(imsize);

	fprintf('Generating %d images\n', n);	
	for i=1: n
		for i=1:imsize(1)
			for j=1:imsize(2)
				irr1 = LambertShading(normals(i,j,:), albedo(i,j), [0,10,10]);
				irr2 = PhongShading(normals(i,j,:), albedo(i,j),[0,10,10],[0,0,10000]);
				synthesized_img1(i,j) = irr1;
				synthesized_img2(i,j) = irr2;
			end
		end
		if (verbose == 1)
			figure; imshow(synthesized_img1,[]);
			figure; imshow(synthesized_img2,[]);
		end
	end
end

function GenerateDirections()


end