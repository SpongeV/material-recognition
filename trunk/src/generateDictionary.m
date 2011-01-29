function generateDictionary( data, directory, clusterNr)
% dictionary of textons: each row represents a texton-cluster
	fprintf('Generating dictionary\n');

	% HARDCODED: number of texture classes (18), number of images per class (10),
	% number of maximum image responses (mr=8)
	classes		= 20;
	img_nr		= 8;
	conditions	= 20;
	dictionary	= [];

%	PrintStrings(data);
	for i=1:classes %nr of textures%length(data)
		features_vector = [];
		for j=1:conditions
			fprintf('img nr: %d texture class: %d, ' ,i*j, i); 
			img_name = data{ (i*conditions-(conditions-1))+(j-1) };
			fprintf('condition: %s\n', img_name);
			responses = loadResponses(directory, img_name, img_nr);
			features_vector = [features_vector; responses];
% 			subplot(5,4,i)
		end
 		size(features_vector)
		[labels, a, clusters] = kmeansj(double(features_vector),clusterNr);

		for k=1:size(clusters,1)
			clusters(k,:) = clusters(k,:)/sum(clusters(k,:));
		end
		
		dictionary = [dictionary; clusters];
	end
	
	
	save Dictionary.mat dictionary
end