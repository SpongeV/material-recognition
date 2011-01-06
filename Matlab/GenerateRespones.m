function GenerateRespones( data, directory, target_directory, write)
	fprintf('Generating responses\n');
	tic;
	for i=1:length(data)
		GetMaxResponses(data{i}, directory, target_directory, write, 0);
	end
	toc;

end
