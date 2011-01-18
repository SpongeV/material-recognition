function Main(args)
	close all;

	photex_directory		= '../Photex/';
	responses_train_directory	= '../responses_train/';

	no_clusters = 600;
	
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

		
% 		[cl, cb] = SplitSet(length(T1),length(T1)/4);
		[cl, cb] = SplitSet2(T1);
		T1CL = T1(cl);	% train data used for clustering
% 		PrintStrings(T1CL)
		T1CB = T1(cb);	% train data used for constructing histograms
		save T1CL.mat T1CL
		save T1CB.mat T1CB
		
	%% STEP 2: Get responses of train  data and store them on disk
	elseif (args(1) == 2)
		load T1CL.mat T1CL
		GenerateRespones(T1CL, photex_directory, responses_train_directory, 1);
	%% STEP 3: Cluster responses and construct histograms for training
	elseif (args(1) == 3)
		load T1CB.mat T1CB
		responses_train = dir(responses_train_directory);
		% start at 3 to omit directories '.' and '..'	
		responses_train = responses_train(3:end);
		responses_train = responses_train(1:end-1);
		size(responses_train)
		clusters = ClusterResponses(texton_train_directory, texton_train, no_clusters);
		[SVMTrainData SVMTrainLabels] = ConstructHistograms(photex_directory, T1CB, clusters);
		save Clusters.mat clusters
		save SVMTrainData.mat SVMTrainData
		save SVMTrainLabels.mat SVMTrainLabels
	elseif (args(1) == 4)
		load TestData.mat
		load Clusters.mat
		[SVMTestData SVMTestLabels] = ConstructHistograms(photex_directory, TestData, clusters);
		save SVMTestData.mat SVMTestData
		save SVMTestLabels.mat SVMTestLabels
	elseif (args(1) == 5)
		%SVMClassify();
		KNNClassify();
	end
end
	
function SVMClassify()
	load SVMTrainData.mat
	load SVMTrainLabels.mat
	load SVMTestData.mat
	load SVMTestLabels.mat
    model = svmtrain(double(SVMTrainLabels'), double(SVMTrainData),'-t 3 -q -b 1');
    [pred, a ,scores] = svmpredict(double(SVMTestLabels'), double(SVMTestData), model, '-b 1');
	[SVMTestLabels' pred]
end

function KNNClassify()
	load Clusters.mat
	load SVMTrainData.mat
	load SVMTrainLabels.mat
	load SVMTestData.mat
	load SVMTestLabels.mat
	train_labels = one_of_n_encoding(SVMTrainData, clusters, SVMTrainLabels);
	test_labels  = one_of_n_encoding(SVMTestData, clusters, SVMTestLabels);
	
	k = 1;
	nin  = size(SVMTrainData, 2);
	nout = size(SVMTrainData, 2);
	nout = size(clusters, 1);
	net = knn(nin, nout, k, SVMTrainData, train_labels);
	[Y, T] = knnfwd(net, SVMTestData);

	[CM, R] = confmat(Y, test_labels);            %% why Y? why not tstSetLbls?
	tstAccur = R(1)
	tstError = (1.0 - (tstAccur * 0.01))
end

function encoding = one_of_n_encoding(data, clusters, labels)
	encoding = zeros(size(data, 1), size(clusters,1));
	for i=1:length(labels)
		encoding(i, labels(i)) = 1;
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

function [trainIdx testIdx] = SplitSet2(data)
	trainIdx = [];
	testIdx = [];
	for i=1:18
		randIdx = randperm(20)+((i-1)*20);
		trainIdx = [trainIdx, randIdx(1:10)];
		testIdx = [testIdx, randIdx(11:end)];
	end
end



