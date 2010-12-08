function main(args)
	close all;
	directory = '../Photex/';
	photex_db = dir(directory);
	% start at 3 to omit directories '.' and '..'	
	photex_db = photex_db(3:end);
	PseudoRandomSampling(directory, photex_db)
%	RandomSubSampling(directory, photex_db)
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
	GenerateTextures(T1(49:52), directory, 1, 256, 1, 1);
%	GenerateTextures(T1(37:39), directory, 1, 256, 1);
%	GenerateTextures(T1(241:260), directory, 1, 256, 1);
% 	GenerateTextures(T1(49:51), directory, 1, 256, 1)
% 	GenerateTextures(T1(1:4), directory, 1, 256, 1)
end


function RandomSubSampling(directory, photex_db)
	dbSize = length(photex_db);

	%%%%%%%%%%%%%%% Construct training sets and test set %%%%%%%%%%%%%%%
	
	
	noInstances	= 40;
	sizeT1		= 20;
	sizeT2		= 10;
	sizeT3		= 4;
	sizeT4		= 3;
	
	% split 40 instances into a set of 20 and a set of 
	[T1train TestSet] = SplitSet(40,20);
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
	GenerateTextures(T3(1:4), directory, 1, 256, 1, 1)
	
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

