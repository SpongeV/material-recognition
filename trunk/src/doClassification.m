function totalAccuracy = doClassification(gaussianModels, marginalsSet)
%                                                                                                      Eli Broadhurst
%                                                                                                      University of North Carolina at Chapel Hill
%                                                                                                      reb@cs.unc.edu
%
%
%
  
numSamples = length(marginalsSet);
numTest     = length(marginalsSet{1});

listTestSamples     = reshape(repmat([1:numSamples], numTest, 1), 1, numSamples * numTest);
listTestNumbers     = repmat([1:numTest], 1, numSamples);
numListTest         = numSamples * numTest;
        
classifiedSamples = zeros(1, numListTest);

for i = 1:numListTest,
    sample = listTestSamples(i);
    num    = listTestNumbers(i);
    testMarginal = marginalsSet{sample}{num};
    classifiedSamples(i) = classifyMarginalGaussians(gaussianModels, testMarginal);
end;

correct = listTestSamples == classifiedSamples;

% disp(['Classification Results :']);
% for sample = 1:numSamples,
%     numCorrect = sum(correct(find(listTestSamples == sample)));
%     if(numCorrect ~= numTest)
%         disp(['  Sample ', int2str(sample), ': ', int2str(numCorrect), ' / ', int2str(numTest), ' = ', num2str(100 * numCorrect/numTest)]);
%     end
% end;
totalAccuracy = 100 * sum(sum(correct)) / numTest / numSamples;
disp(['    Classification Accuracy: ', int2str(sum(sum(correct))), ' / ', int2str(numTest * numSamples), ' = ', num2str(totalAccuracy)]);            

