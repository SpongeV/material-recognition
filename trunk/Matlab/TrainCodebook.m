function TrainCodebook( data, directory )
%TRAINCODEBOOK Summary of this function goes here
%   Detailed explanation goes here


	%PrintStrings(data);

	fprintf('Constructing codebook\n');

	% allocate memory
	parts = strsplit('.', data{1});
	image_dir = strcat(directory, parts{2}, '/' ,data{1});	
	img = imcrop(imread(image_dir), [156 156 200 200]);
	imsize = size(img);	
% 	images = zeros(imsize(1), imsize(2), length(data));
 	images = zeros(imsize(1), imsize(2), 1);

	fprintf('Loading images...\n');
	for i=1:1%length(data)
		parts = strsplit('.', data{i});
		image_dir = strcat(directory,parts{2},'/', data{i});
		img = imread(image_dir);
		img = imcrop(img,[156 156 200 200]);
		% convert image to [0 1] intensities
		img = double(rgb2gray(img))/255;
		images(:,:,i) = img;
	end


	% construct the MR sets
	F = makeRFSfilters;

	% allocate memory
	conv_img = conv2(images(:,:,1),F(:,:,1),'valid');
	responses = zeros(size(conv_img,1),size(conv_img,2),size(F,3));

	for i=1:size(images,3)
		for j=1:size(F,3)
			conv_img = conv2(images(:,:,i),F(:,:,j),'valid');
			responses(:,:,j)  = conv_img;
		end
		
		r1 = responses(:,:,6);
		
		fprintf('Material no.%d processed\n',i);
	end
end
