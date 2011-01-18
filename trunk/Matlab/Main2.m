function Main2(args)
	close all;

	photex_directory		= '../Photex/';
	responses_train_directory	= '../responses_train/';

	clusterNr = 10;

	
	
	photex_db = dir(photex_directory);
	% start at 3 to omit directories '.' and '..'	
	photex_db = photex_db(3:end);
	if args(1) == 1
		fprintf('Number of materials: %d\n', length(photex_db));
		fprintf('Generating datasets...\n');
		[T1, T2, T3, T4, TestData] = RandomSubSampling(photex_directory, photex_db);
		save T1.mat T1
		save T2.mat T2
		save T3.mat T3
		save T4.mat T4
		save TestData.mat TestData

		[cl, cb] = SplitSet(T1);
		T1CL = T1(cl);	% train data used for clustering
% 		PrintStrings(T1CL)
		T1CB = T1(cb);	% train data used for constructing histograms
		save T1CL.mat T1CL
		save T1CB.mat T1CB
		
	elseif args(1) == 2
		load T1CL.mat
		fprintf('Generating texton dictionary...\n');
		GenerateDictionary(T1CL, photex_directory, responses_train_directory, clusterNr, 1);
	elseif args(1) == 3
		load T1CB.mat
		load Dictionary.mat
		[SVMTrainData SVMTrainLabels] = ConstructHistograms(photex_directory, T1CB, dictionary);
		save SVMTrainData.mat SVMTrainData
		save SVMTrainLabels.mat SVMTrainLabels
	elseif (args(1) == 4)
		load TestData.mat
		load Dictionary.mat
		[SVMTestData SVMTestLabels] = ConstructHistograms(photex_directory, TestData, dictionary);
		save SVMTestData.mat SVMTestData
		save SVMTestLabels.mat SVMTestLabels
	elseif (args(1) == 5)
		SVMClassify();
		%KNNClassify();
	end
end


function [trainIdx testIdx] = SplitSet(data)
	trainIdx = [];
	testIdx = [];
	for i=1:18
		randIdx = randperm(20)+((i-1)*20);
		trainIdx = [trainIdx, randIdx(1:10)];
		testIdx = [testIdx, randIdx(11:end)];
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