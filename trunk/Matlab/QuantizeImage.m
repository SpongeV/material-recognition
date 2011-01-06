function h = QuantizeImage(directory, image_name, clusters)
	[max_responses, dim1, dim2] = GetMaxResponses(image_name, directory, '', 0, 0);

	%% normalize responses and put them in vectors
	for i=1:size(max_responses,3)
		texton = max_responses(:,:,i);
		textons(i,:) = texton(:) ./ norm(texton(:));
	end

	%% for each texton, calculate euclidian distance to all clusters and
	%% get the cluster with closest distance
	for i=1:size(textons,1)
		distances = distm(clusters,double(textons(i,:)));
		[closest idx] = min(distances);
		idxs(i) = idx;
	end

	%% construct histogram
	h = hist(idxs, size(clusters,1));
	
	%% normalize histogram
	h = h ./ sum(h);

% 	hist(idxs, size(clusters,1));
% 	drawnow;
end