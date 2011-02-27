function unitTestNNCLassify()
	format long
	load TrainData.mat
	load TrainLabels.mat
	load TestData.mat
	load TestLabels.mat
	
	size(test_hists)
	size(train_hists)

	test_hist = test_hists(:,50);

	mindist = 1.0e+200;
	class = 0;
	for j=1:20
		trainHists = double(train_hists(:,(j*20)-19:j*20));
		trainHists = trainHists;

		nModels = size(trainHists,2);

		targetHist = double(ones(nModels,1)*test_hist');
		targetHist = targetHist;
		
% 		size(trainHists)
% 		size(targetHist)
		
		
		

		ss = sum((trainHists-targetHist').^2);% ./ (trainHists+targetHist'+0.000000001), 2);
		[distance,index] = min(ss);
		distance
		if (distance < mindist)
			mindist = distance;
			theLabel = train_labels((j*20)-19:j*20);
			class = theLabel(1);
		end
% 			fprintf('distance: %d class: %d\n',distance,class(i));
	end
	class
	
end