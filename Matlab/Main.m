function d =main(args)
	close all;

	photex_directory		= '../Photex/';
	texton_train_directory	= '../textons_train/';
	texton_test_directory	= '../textons_test/';

	
	photex_db = dir(photex_directory);
	% start at 3 to omit directories '.' and '..'	
	photex_db = photex_db(3:end);
%	PseudoRandomSampling(directory, photex_db)


	%% STEP 1: Generate train/test sets
	if args(1) == 1
		fprintf('Number of materials: %d\n', length(photex_db));
		fprintf('Generating datasets...\n');
		[T1, T2, T3, T4, TestData] = RandomSubSampling(photex_directory, photex_db);
		save T1.mat T1
		save T2.mat T2
		save T3.mat T3
		save T4.mat T4
		save TestData.mat TestData

		[cl, cb] = SplitSet(length(T1),length(T1)/2);
		T1CL = T1(cl);	% train data used for clustering
		T1CB = T1(cb);	% train data used for constructing histograms
		save T1CL.mat T1CL
		save T1CB.mat T1CB
		
	%% STEP 2: Get responses of train  data and store them on disk
	elseif (args(1) == 2)
		load T1CL.mat T1CL
		GenerateRespones(T1CL, photex_directory, texton_train_directory, 1);
	%% STEP 3: Cluster responses and construct histograms for training
	elseif (args(1) == 3)
		load T1CB.mat T1CB
		texton_train = dir(texton_train_directory);
		% start at 3 to omit directories '.' and '..'	
		texton_train = texton_train(3:end);
		clusters = ClusterResponses(texton_train_directory, texton_train(1:1440), 18);
		[SVMTrainData SVMTrainLabels] = ConstructHistograms(photex_directory, T1CB, clusters);
		save SVMTrainData.mat SVMTrainData
		save SVMTrainLabels.mat SVMTrainLabels
	elseif (args(1) == 4)
		load TestData.mat
		texton_train = dir(texton_train_directory);
		% start at 3 to omit directories '.' and '..'	
		texton_train = texton_train(3:end);
		clusters = ClusterResponses(texton_train_directory, texton_train(1:1440), 18);
		[SVMTestData SVMTestLabels] = ConstructHistograms(photex_directory, TestData, clusters);
		save SVMTestData.mat SVMTestData
		save SVMTestLabels.mat SVMTestLabels
	end
	
	
end
	
function PseudoRandomSampling(directory, photex_db)
	dbSize = length(photex_db);
	T1idx = 1;
	for i=1:dbSize
		if (photex_db(i).isdir)
			data = dir(strcat(directory,photex_db(i).name));
			data = data(3:end);
			
			idx = 1;
			clean_data = {};
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
			% Construct training-set
			for j=1:4
				T1{T1idx} = clean_data{j};
				T1idx = T1idx+1;
			end
		end
	end
%	PrintStrings(clean_data);
%	GenerateTextures(T1(1:4), directory, 1, 256, 1, 1);
%	GenerateTextures(T1(49:52), directory, 1, 256, 1, 1);
%	GenerateTextures(T1(37:39), directory, 1, 256, 1);
%	GenerateTextures(T1(241:260), directory, 1, 256, 1);
% 	GenerateTextures(T1(49:51), directory, 1, 256, 1)
% 	GenerateTextures(T1(1:4), directory, 1, 256, 1)
end


function [T1, T2, T3, T4, TestData] = RandomSubSampling(directory, photex_db)
	dbSize = length(photex_db);

	%%%%%%%%%%%%%%% Construct training sets and test set %%%%%%%%%%%%%%%	
	noInstances	= 40;
	sizeT1		= 20;
	sizeT2		= 10;
	sizeT3		= 4;
	sizeT4		= 3;
	
	% split 40 instances into a set of 20 and a set of 
	[T1train TestSet]   = SplitSet(40,20);
	[T2train]			= SplitSet(20,10);
	[T3train]			= SplitSet(20,4);
	[T4train]			= SplitSet(20,3);
	
	T1idx = 1;
	T2idx = 1;
	T3idx = 1;
	T4idx = 1;
	TestIdx = 1;
	
	% init cells
	T1{sizeT1 * dbSize} = 0;
	T2{sizeT2 * dbSize} = 0;
	T3{sizeT3 * dbSize} = 0;
	T4{sizeT4 * dbSize} = 0;
	TestData = {};
	
	for i=1:dbSize
		if (photex_db(i).isdir)
			data = dir(strcat(directory,photex_db(i).name));
			data = data(3:end);
			
			idx = 1;
			clean_data = {};
%			photex_db(i).name
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
%			length(clean_data)

			% Construct Test Set
			for j=1:length(TestSet)
				TestData{TestIdx} = clean_data{TestSet(j)};
				TestIdx = TestIdx+1;
			end

			% Construct T1
			for j=1:length(T1train)
				T1{T1idx} = clean_data{T1train(j)};
				T1idx = T1idx+1;
			end
			% Construct T2
			for j=1:length(T2train)
				T2{T2idx} = clean_data{T1train(T2train(j))};
				T2idx = T2idx+1;
			end
			% Construct T3
			for j=1:length(T3train)
				T3{T3idx} = clean_data{T1train(T3train(j))};
				T3idx = T3idx+1;
			end
			% Construct T4
			for j=1:length(T4train)
				T4{T4idx} = clean_data{T1train(T4train(j))};
				T4idx = T4idx+1;
			end
		end
	end

%	GenerateTextures(T1(241:260), directory, 1, 256, 0)
%	GenerateTextures(T3(1:4), directory, 1, 256, 1, 1)	
%	PrintStrings(T1)
%	PrintStrings(T2)
%	PrintStrings(T3)
%	PrintStrings(T4)
%	PrintStrings(TestData)
end

function [trainIdx testIdx] = SplitSet(data, nr)
	idx = randperm(data);
	trainIdx = idx(1:nr);
	testIdx  = idx(nr+1:end);
end

function out = HasTilt(parts, tilts)
	out = 0;
	for i=1:length(tilts)
		if (str2double(parts(5)) == tilts(i))
			out = 1;
		end
	end
end

