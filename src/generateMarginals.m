function binMarginal = generateMarginals(features, numBins);
%                                                                                                      Eli Broadhurst
%                                                                                                      University of North Carolina at Chapel Hill
%                                                                                                      reb@cs.unc.edu
% features should be a numFeatures x numPoints matrix, for the MR8 CUReT this is 8x(~150x150)
% numBins is the number of bins per feature, i.e. each margin is represented with numBins
% binMarginal numFeatures x numBins:  The "quantile histogram" representation for each marginal

%sort them and make integer number of points per bin ... now a marginal
numFeatures = size(features, 1);
numPoints = size(features, 2);    
ind = randperm(numPoints);
numPointsPerBin = floor(numPoints/numBins);

numPoints = numPointsPerBin * numBins;
features = features(:, ind(1:numPoints));        

marginal = sort(features');
marginal = marginal';

binMarginal = zeros(numFeatures, numBins);
for p = 1:numBins,
    start = 1 + numPointsPerBin * (p-1);
    binMarginal(:, p) = sum(marginal(:, start:start+numPointsPerBin - 1), 2) / numPointsPerBin;
end;
