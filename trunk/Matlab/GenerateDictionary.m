function GenerateDictionary( data, directory, target_directory, clusterNr, write)
% dictionary of textons: each row represents a texton-cluster
	fprintf('Generating responses\n');

	% HARDCODED: number of texture classes (18), number of images per class (10),
	% number of maximum image responses (mr=8)
	classes = 18;
	mr = 8;
	imgs = 10;
	
	dictionary = [];
	for i=9:classes %nr of textures%length(data)
		load Dictionary.mat
		total_responses = [];
		for j=1:imgs %nr of images per texture
			% get responses from the MR8 filter bank; returns 8 maximum responses
			[max_responses, dim1, dim2] = GetMaxResponses(data{(i*imgs-(imgs-1))+(j-1)}, directory, target_directory, write, 0);
			for k=1:mr
				tmp = max_responses(:,:,k);
				max_responses_vectors(:,k) = tmp(:);
			end
			total_responses(:, (j*mr) - (mr - 1):j * mr) = max_responses_vectors;
			fprintf('\ttotal responses: %d\n', size(total_responses,2));
		end
		
		[labels, a, clusters] = kmeansj(double(total_responses'),clusterNr);
		fprintf('###cluster size: %d textons###\n', size(clusters,1));
		fprintf('###dictionary size: %d textons###\n', size(dictionary,1));
		dictionary((i*clusterNr)-(clusterNr-1):clusterNr*i, :) = clusters;
		save Dictionary.mat dictionary
	end
end
