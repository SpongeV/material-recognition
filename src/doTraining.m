function gaussianModels = doTraining(marginalsSet, numEigenValues)
%                                                                                                      Eli Broadhurst
%                                                                                                      University of North Carolina at Chapel Hill
%                                                                                                      reb@cs.unc.edu
%
%Learn a gaussian model for each class using the first numEigenValues modes from PCA and the
%expected projection error onto this subspace

numSamples = length(marginalsSet);
numTraining = length(marginalsSet{1});
numFeatures = size(marginalsSet{1}{1}, 1);
numDims     = size(marginalsSet{1}{1}, 2);

sampleMeans = cell(1, numSamples);
sampleEigValues = cell(1, numSamples);
sampleEigVectors = cell(1, numSamples);
sampleLogDetVar = cell(1, numSamples);

for s = 1:numSamples,
    marginals = marginalsSet{s};
    
    sampleMeans{s} = cell(1, numFeatures);
    sampleEigValues{s} = cell(1, numFeatures);
    sampleEigVectors{s} = cell(1, numFeatures);            
    sampleLogDetVar{s} = cell(1, numFeatures);            
    for f = 1:numFeatures,
        A = zeros(numTraining, numDims);
        for i = 1:numTraining,
            A(i,:) = marginals{i}(f, :);
        end;

        fMean = mean(A);
        A = A - repmat(fMean, numTraining, 1);
        options.disp = 0;
        B = A' * A / (numTraining - 1);

        [vectors, values] = eigs(B, numEigenValues, 'lm', options);
        values = diag(values)';        

        projErrorVar = trace(B) - sum(values);
        values = [values, projErrorVar];

        sampleMeans{s}{f} = fMean;
        sampleEigValues{s}{f} = values;
        sampleEigVectors{s}{f} = vectors;
        sampleLogDetVar{s}{f} = sum(log(values));
    end
end
            
gaussianModels.sampleMeans = sampleMeans;
gaussianModels.sampleEigValues = sampleEigValues;
gaussianModels.sampleEigVectors = sampleEigVectors;
gaussianModels.sampleLogDetVar = sampleLogDetVar;
