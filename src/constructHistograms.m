function [histograms labels] = constructHistograms(data, directory, dictionary)

	img_nr		= 8;	% number of responses per image
	nTextons	= size(dictionary,1);

	histograms	= [];
	
	for i=1:length(data)
		parts = strsplit('.', data{i});
		fprintf('condition: %s\n', data{i}); 
		responses = loadResponses(directory, data{i}, img_nr);
		textonHistogram = zeros(nTextons,1);

		npix = size(responses,1);

		for u = 1:npix
			tmp = sum((dictionary-ones(nTextons,1)*responses(u,:)).^2,2);
            [mindist,index] = min(tmp);
             textonHistogram(index) = textonHistogram(index)+1.0;%/npix;
		end

% 		figure;
% 		hist(textonHistogram);
% 		drawnow;
		
		labels(i) = ConvertLabel(char(parts(2)));
		histograms(:,i) = textonHistogram;
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
		case 'adb'
			out = 15;
		case 'adc'
			out = 16;
		case 'add'
			out = 17;
		case 'ade'
			out = 18;
		case 'adg'
			out = 19;
		case 'adh'
			out = 20;
	end
end