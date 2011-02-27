function [hist, x] = getFrequencyHistograms(data, numBins, minWidth, smoothingFactor);
%                                                                                                      Eli Broadhurst
%                                                                                                      University of North Carolina at Chapel Hill
%                                                                                                      reb@cs.unc.edu
%
% Each guy is a row vector
%
numHists = size(data, 1);

[h, f, w] = getEquiCountFrequencies(data');
w = w'/2;
w = max(w, minWidth);

hist = zeros(numHists, numBins+1);
xMin = min(min(data - w));
xMax = max(max(data + w));
x = xMin + [0:numBins] / numBins * (xMax - xMin);
for i = 1:numHists,    
   m = data(i, :);
   sigma = smoothingFactor * w(i, :);
   for ii = 1:numBins+1,
       hist(i, ii) = sum((1/sqrt(2*pi)) .* (1 ./ sigma) .* exp(-0.5 * (x(ii) - m) .^ 2 ./ (sigma .^ 2)));
   end
   hist(i, :) = hist(i, :) / sum(hist(i, :)) / (xMax - xMin) * (numBins+1);
end
