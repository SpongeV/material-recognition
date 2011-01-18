function [histograms labels] = ConstructHistograms(directory, data, clusters)


	for i=1:length(data)
		h = QuantizeImage(directory, data{i}, clusters);
		histograms(i,:) = h;
		s = sum(h(:))
		parts = strsplit('.', data{i});
		parts(2)
		labels(i) = ConvertLabel(char(parts(2)))
	end
end

function out = ConvertLabel(in)
	
	switch in
		case 'aaa'
			out = 1;
		case 'aab'
			out = 2;
		case 'aaj'
			out = 3;
		case 'aam'
			out = 4;
		case 'aan'
			out = 5;
		case 'aao'
			out = 6;
		case 'aar'
			out = 7;
		case 'aas'
			out = 8;
		case 'aba'
			out = 9;
		case 'abj'
			out = 10;
		case 'abk'
			out = 11;
		case 'acc'
			out = 12;
		case 'acd'
			out = 13;
		case 'ace'
			out = 14;
		case 'add'
			out = 15;
		case 'ade'
			out = 16;
		case 'adg'
			out = 17;
		case 'adh'
			out = 18;
	end
end