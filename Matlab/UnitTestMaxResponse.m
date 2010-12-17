function UnitTestMaxResponse(verbose)
% UnitTestMaxResponse
%
% Output the maximum response of the MR8 filter bank: 
% 2 anisotropic filters with 6 orientations on 3 scales
% and a gaussian and laplacian of gaussian filters give
% a total of 38 responses. 
% The maximum response at each scale over the 6 orientations
% is returned giving a total of 8 responses.

	image = '1.acd.0.30.0.bmp'
	directory = '../Photex/'



	%PrintStrings(data);

	fprintf('Calculate responses...\n');

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
	toc;

	fprintf('Obtain maximum responses ...\n');

	% separate filter responses
	an1sc1 = responses(:,:,   1:6);
	an1sc2 = responses(:,:,  7:12);
	an1sc3 = responses(:,:, 13:18);
	
	an2sc1 = responses(:,:, 19:24);
	an2sc2 = responses(:,:, 25:30);
	an2sc3 = responses(:,:, 31:36);

	max = -10000;
	idx = 1;
	for i=1:6
		temp = sum(sum(an1sc1(:,:,i)));
		if (temp > max)
			max = temp
			idx = i;
		end
	end
	max_responses(:,:,1) = an1sc1(:,:,idx);
	
	figure;
	imshow(max_responses(:,:,1),[]);
	
	if (verbose==1)
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