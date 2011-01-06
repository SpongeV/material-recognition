function clusters = ClusterResponses(directory, texton_db, clusterNr)
%CLUSTERRESPONSES Summary of this function goes here
%   Detailed explanation goes here



	texton = imread(strcat(directory, texton_db(1).name));
	g(length(texton_db),:) = texton(:);
	
	
	dbSize = length(texton_db);
	for i=1:dbSize
		texton = imread(strcat(directory, texton_db(i).name));
		g(i,:) = texton(:)';
		fprintf('img: %d s1: %d s2: %d\n', i, size(g,1), size(g,2));
	end
	
	[labels a, clusters] = kmeansj(double(g(1:400,:)),clusterNr);
	
    for i=1:size(clusters,1)
        clusters(i,:) = clusters(i,:) ./ norm(clusters(i,:));
    end 	
end