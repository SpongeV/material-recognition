function [albedo, normals] = PhotometricStereo(im, dir, s, verbose)
	%PrintStrings(images)

	% allocate matrix for images
	parts = strsplit('.',im{1});
	img = imcrop(imread(strcat(dir,parts{2},'/',im{1})), [156 156 200 200]);
% 	img = imread(strcat(dir,parts{2},'/',im{1}));
	imsize = size(img);
	
	images = zeros(imsize(1), imsize(2), length(im));
	
    % define matrix for the albedo surface
    albedo=zeros(imsize(1),imsize(2));
    % define matrices to store the normals
	normals=zeros(imsize(1),imsize(2),3);

	V = zeros(length(im),3);
	
	
	for i=1:length(im)
		parts = strsplit('.',im{i});
		img = imread(strcat(dir,parts{2},'/',im{i}));
		img = imcrop(img,[156 156 200 200]);
		% convert image to [0 1] intensities
		img = double(rgb2gray(img))/255;
		images(:,:,i) = img;
	end

	%[Investigation].[texturename].[rotation].[slant].[tilt].[format]
	% rotation: rotation of the surface in DEGREES
	% slant:
	% tilt:
	for i=1:length(im)
		parts = strsplit('.',im{i});
		% get lightsource directions from image names and normalize the
		% directions
		V(i,:) = [cos(str2double(parts(5)))*sin(str2double(parts(4))), ...
			sin(str2double(parts(5)))*cos(str2double(parts(4))), ...
			cos(str2double(parts(4)))];
		V(i,:) = V(i,:)/norm(V(i,:));
	end

%	imshow(images(:,:,1))
    p=double(zeros(imsize,imsize));
    q=double(zeros(imsize,imsize));


	for n=1:imsize
        for m=1:imsize
			% stack pixel values of all images at (i,j)
			i = images(n,m,:);
			i = i(:);
			% construct diagonal matrix I
			I = diag(i);
            sumI = sum(I);
            countZeros = sum(sumI==0);

			if countZeros>2
                g=[0; 0; 0];
            else
                % solve the linear system of I*i=I*V*g with g unknown
                % using a numerical approach
                g=linsolve(I*V,I*i);
			end

			% reconstruct surface albedo
            albedo(n,m)=norm(g);
            % calculate normal
            N=g/albedo(n,m);
            % store normal
			normals(n,m,:) = N;

			% calculate the derivatives in both x and y direction
            p(n,m)=N(1)/N(3);
            q(n,m)=N(2)/N(3);
            % replace improbable values
            if q(n,m) == -inf || q(n,m) == inf || isnan(q(n,m))
                q(n,m)=0;
            end
            if p(n,m) == -inf || p(n,m) == inf || isnan(p(n,m))
                p(n,m)=0;
            end
			
		end
	end

    zQ=double(zeros(imsize,imsize));
    prevQ=0;
    firstVal=0;
    for m=1:imsize
        for n=1:imsize
            % skip the first 2 values due to inconsistency (results get
            % smoother)
            if firstVal<=2 
                if not(q(n,m)==0)
                    firstVal=firstVal+1;
                end
            else
                % surfaceheight=previous surfaceheight + q at current point
                zQ(n,m)=prevQ+q(n,m);
                prevQ=zQ(n,m);
            end
        end
        prevQ=0;
        firstVal=0;
	end
	
	if (verbose == 1)
		albedo = albedo./max(albedo(:));
		figure; imshow(albedo, []);
		
		diff_p = diff(p,1,1);
		diff_q = diff(q,1,2);
		check = (diff_p(1:end,1:end-1) - diff_q(1:end-1,1:end)).^2;
		figure;	imshow(check);
		
% 	    [x y]=meshgrid(0.1:0.1:imsize/10,0.1:0.1:imsize/10);	
% 	    z = -1*zQ;
% 		figure;
% 		quiver3(x,y,z,normals(:,1),normals(:,2),normals(:,3));
	end
end