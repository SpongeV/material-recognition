function clusters = ClusterResponses(directory, texton_db, clusterNr)
%CLUSTERRESPONSES Summary of this function goes here
%   Detailed explanation goes here



	texton = imread(strcat(directory, texton_db(1).name));
	g(length(texton_db),:) = texton(:);
	
	
	dbSize = length(texton_db);
	for i=1:dbSize
		fprintf('img: %d s1: %d s2: %d name: %s\n', i, size(g,1), size(g,2), strcat(directory, texton_db(i).name));
		texton = imread(strcat(directory, texton_db(i).name));
		g(i,:) = texton(:)';
	end
	
	[labels a, clusters] = kmeansj(double(g),clusterNr);
	
    for i=1:size(clusters,1)
        clusters(i,:) = clusters(i,:) ./ norm(clusters(i,:));
    end 	
end