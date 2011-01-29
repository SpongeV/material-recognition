function textonHistogram = QuantizeImage(directory, image_name, clusters)
	[max_responses, dim1, dim2] = GetMaxResponses(image_name, directory, '', 0, 0);

	%% normalize responses and put them in vectors
	for i=1:size(max_responses,3)
		response = max_responses(:,:,i);
		responses(i,:) = response(:);% ./ norm(response(:));
	end

	%% for each texton, calculate euclidian distance to all clusters and
	%% get the cluster with closest distance
% 	for i=1:size(responses,1)
% 		distances = distm(clusters,double(responses(i,:)));
% 		[closest idx] = min(distances);
% 		idxs(i) = idx;
% 	end


	nTextons = size(clusters,2);

	sizeClusters = size(clusters)
	sizeResponses = size(ones(nTextons,1)*responses(:,i)')
	% for each pixel in the response
	for i=1:size(responses,2)
		[mindist,idx] = min(sum((clusters-ones(nTextons,1)*responses(:,i)).^2,2));
		textonHistogram(idx) = textonHistogram(idx)+1.0/npix;
	end



% 	%% construct histogram
% 	h = hist(idxs, size(clusters,1));
% 	
% 	%% normalize histogram
% 	h = h ./ sum(h);

	hist(textonHistogram, size(clusters,1));
	drawnow;
end