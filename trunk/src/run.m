function run(args, photex_dir, image_dir, responses_dir, marginal_dir, test_set, train_set)
	photex_db = dir(image_dir);
	% omit directories '.' and '..'
	photex_db = photex_db(3:end);

	% clusterNr defined for texton dictionary
	clusterNr		= 100;
	
	
	% Generate all responses
	if args(1) == 1
		fprintf('Number of materials: %d\n', length(photex_db));
		fprintf('Generating responses...\n');
		tic;
		data = getNames(photex_db, image_dir);
		generateResponses(data, image_dir, responses_dir, 1);
		toc;
	elseif args(1) == 2
		fprintf('Number of materials: %d\n', length(photex_db));
		fprintf('Generating datasets...\n');
% 		[T0, T1, T2, T3, T4, TD] = randomSubSampling(photex_dir, photex_db);
		[T0, T1_idx, T2_idx, T3_idx, T4_idx, TD_idx] = pseudoRandomSubSampling(photex_dir);
		save T0.mat T0
		% the datasets below are created for the Texton Dictionary
		% experiment.
		save T1_idx.mat T1_idx
		save T2_idx.mat T2_idx
		save T3_idx.mat T3_idx
		save T4_idx.mat T4_idx
		save TD_idx.mat TD_idx
		
		T1 = T0(T1_idx);
		T2 = T0(T2_idx);
		T3 = T0(T3_idx);
		T4 = T0(T4_idx);
		
		save T1.mat T1
		save T2.mat T2
		save T3.mat T3
		save T4.mat T4
		
	elseif args(1) == 3
		load T0.mat
% 		generateDictionary(T1, responses_dir, clusterNr);


		fprintf('Generating marginals\n');
		% HARDCODED: number of texture classes (20), number of images per class (10),
		% number of maximum image responses (mr=8)

		classes		= 20;
		img_nr		= 8;
		conditions	= 40;

		numSamples = length(T0);
		marginalsSet = cell(1, classes);
		counter = 1;
		for i=1:classes %nr of textures%length(data)
			marginals = cell(1, conditions);
			for j=1:conditions
				fprintf('img nr: %d texture class: %d, ' ,counter, i);
				counter = counter + 1;
				img_name = T0{ (i*conditions-(conditions-1))+(j-1) };
				parts = strsplit('.', img_name);

				fprintf('condition: %s\n', img_name);
				responses = loadResponses(responses_dir, img_name, img_nr);
				marginals{j} = generateMarginals(responses', 25);


				name = strcat(marginal_dir,parts{2},'/',parts{1},'.',parts{2},'.', ...
							  parts{3},'.',parts{4},'.',parts{5},'.mat')
	% 			imwrite(max_responses(:,:,i),name,'bmp');
%  				marginal_struct = struct('name',name,'img',marginal);
%  				save(name, 'marginal_struct');
% 				marginalsSet{s} = marginal;		
% 				s = s + 1;
			end
			marginalsSet{i} = marginals;
		end

		save marginals_original.mat marginalsSet
		
	elseif args(1) == 4
		load marginalsSet.mat
		graphMaterial = 10;
		generateFigures(marginalsSet, graphMaterial);

	elseif args(1) == 5
		set_original	= load(test_set);
		set_synthesized = load(train_set);
		
		startSet = 1;
		numSets = 100;
		numSamples = 20;
		numConditions = 40;
		
		%Here is one of the arbitrary parameters of the setup.
		% numSets		: 100 
		% eigenValues 10: 90.2585% acc
		% eigenValues 11: 90.2585% acc
		% eigenValues 12: 90.2585% acc
		% eigenValues 13: 90.5750% acc
		numEigenValues = 13;

		totalAverageAccuracy = 0;
		totalAASquared       = 0;

% 		for kk = 1:100
% 			numEigenValues = 7;
% % 			numEigenValues = numEigenValues + 1;
% 			totalAverageAccuracy = 0;
% 			totalAASquared       = 0;
		
		for ss = startSet:startSet + numSets - 1,
			currAccuracy = 0;


			
			
%%			% Broadhurst Experiment
% 			randomSet = randperm(numConditions);
% 			trainingSet = randomSet(1:2:length(randomSet));
% 			testSet		= randomSet(2:2:length(randomSet));

%%			% Targhi Experiment
			% get the samples random
			randomSet   = randperm(numConditions);
			T1Set		= randomSet(1:2:length(randomSet));
			trainingSet = T1Set(1:end);
			testSet		= randomSet(2:2:length(randomSet));

			% get the samples uniformly distributed over hemisphere
% 			[pseudoRandomTrain pseudoRandomTest] = pseudoRandomSubSamplingBroadhurst(photex_dir); 
% 			trainingSet = pseudoRandomTrain(1:20);
% 			testSet		= pseudoRandomTest;

% 			trainingSet = 2:2:numConditions;
% 			testSet = 1:2:numConditions;
%%
			fprintf('DEB: trainingSet size: %d testSet size: %d\n', length(trainingSet), length(testSet));

		%JMG:  limit trainingsamples
		%idx = randperm(length(trainingSet));
		%trainingSet = trainingSet(idx(1:10));
		%trainingSet = trainingSet(1:40);

			%Both always 46 in these tests
			numTraining = length(trainingSet);
			numTest     = length(testSet);

			disp(['Set ', num2str(ss), ' (', num2str(numTraining), ' training samples, ', num2str(numEigenValues), ' eigenmodes, ', num2str(size(set_synthesized.marginalsSet{1}{1},1)), ' filters):']);

			trainingMarginalsSet = cell(1, numSamples);
			testMarginalsSet     = cell(1, numSamples);
			for s = 1:numSamples,
				marginalsSet = set_synthesized.marginalsSet;
				trainingMarginalsSet{s} = marginalsSet{s}(trainingSet);
				marginalsSet = set_original.marginalsSet;
				testMarginalsSet{s}     = marginalsSet{s}(testSet);
			end

			% JMG: BETTER LEFT OUT:
			%NORMALIZATION OF THE FILTER RESPONSES - In order to sensibly measure the joint variation of the marginals the filter responses
			%need to be in the same basic units. This is often done by normalizing each filter by its L1 norm. I did not realize this at the
			%time so I used my own arbitary normalization.  I have not tried normalizing by the L1 norm.
		%
		%    [trainingMarginalsSet, testMarginalsSet] = doFilterNormalization(trainingMarginalsSet, testMarginalsSet);
		%

			%TRAINING of joint marginals -- append them into one long vector per image
			for s = 1:numSamples,
				for i = 1:numTraining,
					trainingMarginalsSet{s}{i} = reshape(trainingMarginalsSet{s}{i}, 1, prod(size(trainingMarginalsSet{s}{i})));
				end
				for i = 1:numTest,
					testMarginalsSet{s}{i} = reshape(testMarginalsSet{s}{i}, 1, prod(size(testMarginalsSet{s}{i})));
				end
			end
			gaussianModels = doTraining(trainingMarginalsSet, numEigenValues);
		%gaussianModels.sampleMeans{1}
		%gaussianModels.sampleEigValues{1}
		%gaussianModels.sampleEigVectors{1}
		%gaussianModels.sampleLogDetVar{1}
		
			save gaussianModels.mat gaussianModels

			%CLASSIFICATION
			currAccuracy = doClassification(gaussianModels, testMarginalsSet);

			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			totalAverageAccuracy = totalAverageAccuracy + currAccuracy;
			totalAASquared = totalAASquared + currAccuracy * currAccuracy;
			sn = ss-startSet + 1;
			aaMean = totalAverageAccuracy / sn;
			if(sn == 1)
				aaStd = 0;
			else
				aaStd = sqrt( (totalAASquared - sn * aaMean * aaMean) / (sn-1));
			end

			disp(['    AVERAGE ACCURACY for ', num2str(sn), ' sets: ', num2str(aaMean), '% +- ', num2str(aaStd)]);
		end
% 		end
		
	elseif args(1) == 10
		load T1.mat
		load TD.mat
		load Dictionary3.mat
		
		[train_hists, train_labels] = constructHistograms(T1, responses_dir, dictionary);
		[test_hists, test_labels] = constructHistograms(TD, responses_dir, dictionary);
		save TrainData.mat train_hists
		save TrainLabels.mat train_labels
		save TestData.mat test_hists
		save TestLabels.mat test_labels

	elseif args(1) == 11
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
			ss = sum((trainHists-targetHist').^2);% ./ (trainHists+targetHist'+0.000000001), 2);
 			[distance,index] = min(ss);
            if (distance < mindist)
                mindist = distance;
				theLabel = train_labels((j*20)-19:j*20);
                class(i) = theLabel(1);
			end
% 			fprintf('distance: %d class: %d\n',distance,class(i));
		end
	end
  	[class' test_labels']
	
	p = class == test_labels;

	performance = sum(p)/size(test_labels,2)
	
	
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
	