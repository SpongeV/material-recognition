function GetMaxResponses(image, directory,verbose)
% GetMaxResponses
%
% Output the maximum response of the MR8 filter bank: 
% 2 anisotropic filters with 6 orientations on 3 scales
% and a gaussian and laplacian of gaussian filters give
% a total of 38 responses. 
% For a given image, the maximum response at each scale 
% over the 6 orientations is returned giving a total of 
% 8 responses.

	fprintf('Processing image: %s\n', image);
	fprintf('\tCalculate responses...\n');

	% allocate memory
	parts = strsplit('.', image);
	image_dir = strcat(directory, parts{2}, '/' ,image);	
	img = im2double(imcrop(imread(image_dir), [156 156 200 200]));

	% construct the MR sets
	F = makeRFSfilters;

	tic;
	% allocate memory
	conv_img = conv2(img(:,:,1),F(:,:,1),'valid');
	responses = zeros(size(conv_img,1),size(conv_img,2),size(F,3));
	max_responses = zeros(size(conv_img,1),size(conv_img,2), 8);
	
	for i=1:size(F,3)
		conv_img = conv2(img(:,:,1),F(:,:,i),'valid');
		responses(:,:,i)  = conv_img;
	end	

	fprintf('\tObtain maximum responses ...\n');
	ii = 1;
	for i=1:6
		max = -10000;
		idx = 1;
		for j=1:6
			temp = sum(sum(responses(:,:,ii+j)));
			if (temp > max)
				max = temp;
				idx = j;
			end
		end
		max_responses(:,:,i) = responses(:,:,ii+idx);
		ii = ii + 6;
	end
	toc;

	max_responses(:,:,7) = responses(:,:,37);
	max_responses(:,:,8) = responses(:,:,38);
	
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