function [max_responses, dim1, dim2] = getMaxResponses(image, directory, target_dir, write, verbose)
% GETMAXRESPONSES
%	getMaxResponses(image, directory, target_dir, write, verbose)
%		Output the maximum response of the MR8 filter bank: 
%		2 anisotropic filters with 6 orientations on 3 scales
%		and a gaussian and laplacian of gaussian filters give
%		a total of 38 responses. 
%		For a given image, the maximum response at each scale 
%		over the 6 orientations is returned giving a total of 
%		8 responses.
%
%		image		- image name (image folder 2nd part of image name
%		directory	- photex directory
%		target_dir	- directory to write responses
%		write		- flag for writing
%		verbose		- flag for debug infor

	fprintf('\tProcessing image: %s\n', image);
	fprintf('\t\tCalculate responses... ');

	% allocate memory
	parts = strsplit('.', image);
	image_dir = strcat(directory, parts{2}, '/' ,image);
	
	% crop image to a region of 200x200 in the center of the image
	img = imread(image_dir);
	img = img(:,:,1);
	img = imcrop(img, [156 156 200 200]);
	img = im2double(img);
	% normalize image intensity to zero-mean and unit standard deviation
 	img = (img-mean(img(:)))/var(img(:));
	
	% construct the MR sets
	F = makeRFSfilters;

	% allocate memory
	conv_img = conv2(img(:,:,1),F(:,:,1),'valid');
	responses = zeros(size(conv_img,1),size(conv_img,2),size(F,3));
	max_responses = zeros(size(conv_img,1),size(conv_img,2), 8);
	
	dim1 = size(conv_img,1);
	dim2 = size(conv_img,2);
	
	for i=1:size(F,3)
		conv_img = conv2(img,F(:,:,i),'valid');
		responses(:,:,i)  = conv_img;
	end	
	fprintf(' done!\n');
	fprintf('\t\tObtain maximum responses...');
	
	ii = 0;	% index for each set of 6 orientations of the anisotropic filters
	for i=1:6	% for each set of filters
		max_val = -10000;
		idx = 1;
		for j=1:6	% obtain index of the maximum response
			temp = sum(sum(responses(:,:,ii+j)));
			if (temp > max_val)
				max_val = temp;
				idx = j;
			end
		end
		% store maximum response
		max_responses(:,:,i) = responses(:,:,ii+idx);
		ii = ii + 6;	%% jump to next set of filters
	end
	fprintf(' done!\n');

	% store 2 responses of isotropic filters
	max_responses(:,:,7) = responses(:,:,37);
	max_responses(:,:,8) = responses(:,:,38);
	
	% write away responses
	if (write == 1)
		for i=1:size(max_responses,3)
			name = strcat(target_dir,parts{2},'/',parts{1},'.',parts{2},'.', ...
						  parts{3},'.',parts{4},'.',parts{5},'.',int2str(i),'.mat');
% 			imwrite(max_responses(:,:,i),name,'bmp');
			img_struct = struct('name',name,'img',max_responses(:,:,i));
			save(name, 'img_struct');
		end
	end
	
	if (verbose==1)
		% display max_responses
		figure;
		for i=1:size(max_responses,3)
			subplot(2,4,i);
			imshow(max_responses(:,:,i),[]);
		end		
		% display responses
		figure;
		for i=1:size(responses,3)
			subplot(4,12,i);
			imshow(responses(:,:,i),[]);
		end
		%display filters
		figure;
		for i=1:size(F,3)
			subplot(4,12,i);
			imshow(F(:,:,i),[]);
		end
	end	
end