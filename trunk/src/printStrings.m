function printStrings(data)

	for i=1:length(data)
		fprintf('%s\n',data{i});
	end
	fprintf('Number of instances:%d\n',length(data));	
end