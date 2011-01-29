function generateResponses(data, directory, target_directory, write)
	for i=1:length(data)
		getMaxResponses(data{i}, directory, target_directory, write, 0);
	end
end
