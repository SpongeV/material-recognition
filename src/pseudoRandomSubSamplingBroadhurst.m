function [T1_idx Test_idx] = pseudoRandomSubSamplingBroadhurst(directory)
	photex_db = dir(directory);
	photex_db = photex_db(3:end);
	dbSize = length(photex_db);

	%%%%%%%%%%%%%%% Construct training sets and test set %%%%%%%%%%%%%%%	
	numSamples	  = 20;
	numConditions = 40;
	sizeT1		= 20;
	sizeT2		= 10;
	sizeT3		= 4;
	sizeT4		= 3;
	
	
	% init cells
	T0{numSamples * numConditions} = 0;
	T0idx = 1;
	
	dir_count = 0;
	
	for i=1:dbSize
		if (photex_db(i).isdir)
			dir_count = dir_count + 1;
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

			for j=1:length(clean_data)
				T0{T0idx} = clean_data{j};
				T0idx = T0idx+1;
			end
		end
	end
	
	[idx Test_idx] = SplitSetUniformDistributed(T0);

	
	Test_idx = Test_idx(1:20);
	T1_idx = [];
	for i=1:40
		if (sum(Test_idx == i)) == 0
			T1_idx = [T1_idx i];
		end
	end
end


function [train test] = SplitSetUniformDistributed(data)
	% only get uniformly distributed tilts for each randomly selected
	% slant. For slant = 30 there is only one set of tilts available.

	no_materials = 20;
	
	
	slants = [30 45 60 75];
	
	
	
	tilts1 = [0 90 180 270];
	tilts2 = [30 120 210 300];
	tilts3 = [60 150 240 330];

	T1 = [];
	T1idx = 1;
	testIdx = 1;
	for i=1:1
		slant_idx = 0;
		while slant_idx == 0
			slant_idx = int16(rand * 4);
		end
		tilt_idx = int16(rand * 3);
		
		if (tilt_idx == 1)
			tilts = tilts1;
		elseif (tilt_idx == 2)
			tilts = tilts2;
		else
			tilts = tilts3;
		end

		if slant_idx == 1
			tilts = tilts1;
		end
		
		for n=1:length(data)
			parts = strsplit('.',data{n});
			p4 = str2double(parts{4});
			p5 = str2double(parts{5});
			if p4 == slants(slant_idx)
				if p5 == tilts(1) || p5 == tilts(2) || p5 == tilts(3) || p5 == tilts(4)
					T1(T1idx) = n;
					T1idx = T1idx + 1;
				end
			else 
				test(testIdx) = n;
				testIdx = testIdx + 1;
			end
		end
	end

	
% 	T1 = sort(T1);

	train = T1;
% 	sort(T1)
% 	size(T1)
end

function out = HasTilt(parts, tilts)
	out = 0;
	for i=1:length(tilts)
		if (str2double(parts(5)) == tilts(i))
			out = 1;
		end
	end
end
