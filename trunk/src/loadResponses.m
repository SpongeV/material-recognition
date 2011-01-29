function responses = loadResponses(directory, img_name, img_nr)
	parts = strsplit('.', img_name);
	for i=1:img_nr
		name = strcat(directory, parts{2}, '/', parts{1}, '.', parts{2}, '.', ...
					  parts{3}, '.', parts{4}, '.', parts{5}, '.', int2str(i), '.mat');
		response = load(name);
		responses(:, i) = response.img_struct.img(:);
	end
end