function main(args)
% MAIN Main file of the Texture Classification Project
%		
%	main(args)
%		args = 1 generates responses for all imagse of all textures using
%		the MR8 filter bank. For each image, 8 responses are recorded.
%
	close all;
	photex_dir		= '../photex/';
	responses_dir	= '../responses/';
	clusterNr		= 100;

	photex_db = dir(photex_dir);
	% omit directories '.' and '..'
	photex_db = photex_db(3:end);

	% Generate all responses
	if args(1) == 1
		fprintf('Number of materials: %d\n', length(photex_db));
		fprintf('Generating responses...\n');
		tic;
		data = getNames(photex_db, photex_dir);
		generateResponses(data, photex_dir, responses_dir, 1);
		toc;
	elseif args(1) == 2
		fprintf('Number of materials: %d\n', length(photex_db));
		fprintf('Generating datasets...\n');
		[T1, T2, T3, T4, TD] = randomSubSampling(photex_dir, photex_db);
		save T1.mat T1
		save T2.mat T2
		save T3.mat T3
		save T4.mat T4
		save TD.mat TD
	elseif args(1) == 3
		load T1.mat
		generateDictionary(T1, responses_dir, clusterNr);
	elseif args(1) == 4
		load T1.mat
		load TD.mat
		load Dictionary3.mat
		
		[train_hists, train_labels] = constructHistograms(T1, responses_dir, dictionary);
		[test_hists, test_labels] = constructHistograms(TD, responses_dir, dictionary);
		save TrainData.mat train_hists
		save TrainLabels.mat train_labels
		save TestData.mat test_hists
		save TestLabels.mat test_labels
	elseif args(1) == 5
		NN_Classify();
	end
	
	
end

function NN_Classify()
	format long
	load TrainData.mat
	load TrainLabels.mat
	load TestData.mat
	load TestLabels.mat
	
	size(test_hists)
	size(train_hists)
	
	for i=1:size(test_hists,2)
		test_hist = test_hists(:,i);
        mindist = 1.0e+200;
		for j=1:20%size(train_hists,1)
			trainHists = double(train_hists(:,(j*20)-19:j*20));
			trainHists = trainHists;
% 			train_labels((j*20)-19:j*20)
 			
			nModels = size(trainHists,2);

			targetHist = double(ones(nModels,1)*test_hist');
			targetHist = targetHist;
			ss = sum((trainHists-targetHist').^2)% ./ (trainHists+targetHist'+0.000000001), 2);
 			[distance,index] = min(ss);
            if (distance < mindist)
                mindist = distance;
				theLabel = train_labels((j*20)-19:j*20);
                class(i) = theLabel(1);
            end;
% 			fprintf('distance: %d class: %d\n',distance,class(i));
		end
	end
  	[class' test_labels']
end


function clean_data = getNames(photex_db, directory)
	dbSize = length(photex_db);
	idx = 1;
	for i=1:dbSize
		if (photex_db(i).isdir)
			data = dir(strcat(directory, photex_db(i).name));
			% omit directories '.' and '..'	
			data = data(3:end);
			% read and filter directory data
			for j=1:length(data)
				if (strfind(data(j).name,'.bmp'))
					parts = strsplit('.',data(j).name);
					if (str2double(parts(3)) == 0 && HasTilt(parts,[0,30,60,90,120,150,180,210,240,270,300,330]) == 1)
						clean_data{idx} = data(j).name;
						idx = idx + 1;
					end
				end
			end
		end
	end
	%printStrings(clean_data);
end


function out = HasTilt(parts, tilts)
	out = 0;
	for i=1:length(tilts)
		if (str2double(parts(5)) == tilts(i))
			out = 1;
		end
	end
end
	