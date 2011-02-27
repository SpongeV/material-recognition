function class = classifyMarginalGaussians(gaussianModels, marginal)
%                                                                                                      Eli Broadhurst
%                                                                                                      University of North Carolina at Chapel Hill
%                                                                                                      reb@cs.unc.edu
%
% The following code is valid only if each class has the same number of eigenmodes (easy to fix though)
%
means = gaussianModels.sampleMeans;
eigValues = gaussianModels.sampleEigValues;
eigVectors = gaussianModels.sampleEigVectors;
logDetVar = gaussianModels.sampleLogDetVar;

%fprintf('\t\tNUMBER OF EIGENMODES: %d\n', length(eigVectors));

numClasses  = length(means);
numFeatures = length(means{1});
numDims     = length(means{1}{1});
classProb = zeros(1, numClasses);

for c = 1:numClasses,
    prob = 0;
    for f = 1:numFeatures,
        X = (marginal(f, :) - means{c}{f}) * eigVectors{c}{f};
        projError = (marginal(f, :) - means{c}{f}) * (marginal(f, :) - means{c}{f})' - X * X';
        X = sum(([X .^ 2, projError]) ./ eigValues{c}{f});
        
        p = logDetVar{c}{f} + X;
        prob = prob + p;
    end;
    classProb(c) = prob;
end;

[minProb, class] = min(classProb);

