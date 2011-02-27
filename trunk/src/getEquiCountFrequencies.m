function [frequencies, edges, widths] = getEquiCountFrequencies(locations, discrete)
%                                                                                                      Eli Broadhurst
%                                                                                                      University of North Carolina at Chapel Hill
%                                                                                                      reb@cs.unc.edu
%
%
% 100 x numPatches

if(nargin < 2)
    discrete = 0;
end;

if(discrete == 1)
    minWidth = 1;
else
    minWidth = 0.000001;
end;

%pad them
numBins = size(locations, 1);

PaddedLocations = [2 * locations(1, :) - locations(2, :); locations; 2 * locations(end, :) - locations(end-1,:)];

widths = 0.5 * (PaddedLocations(3:end, :) - PaddedLocations(1:end-2, :)) + minWidth;

frequencies = 1.0 / numBins ./ widths;

edges = 0.5 * (PaddedLocations(2:end, :) + PaddedLocations(1:end-1, :));