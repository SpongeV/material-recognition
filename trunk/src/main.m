function [ output_args ] = main( args )
% MAIN Main file of the Texture Classification Project
%		
%	main(args)
%		args = 1 generates responses for all imagse of all textures using
%		the MR8 filter bank. For each image, 8 responses are recorded.
%
%		args = 2 generate indices for sampling from the photex database.
%		Targhi's experiment samples pseudorandomly: azimuth is constrained
%		to be distributed uniformly over the hemisphere.


	close all;

%% image directories
	photex_dir			= '../photex/';
	% 5 repetitions of the experiment
	image_Lambertian3_1			= '../DB_LAMBERTIAN3_1/';
	image_Lambertian4_1			= '../DB_LAMBERTIAN4_1/';
	image_Lambertian10_1		= '../DB_LAMBERTIAN10_1/';
	image_Lambertian20_1		= '../DB_LAMBERTIAN20_1/';


	image_OrenNayar4_1			= '../DB_ORENNAYAR4_1/';
	image_OrenNayar20_1			= '../DB_ORENNAYAR20_1/';

	image_Phong20_1				= '../DB_PHONG20_1/';
	image_Phong4_1				= '../DB_PHONG4_1/';

	
	lambertian20_2_dir			= '../DB_LAMBERTIAN20_2/';
	lambertian20_3_dir			= '../DB_LAMBERTIAN20_3/';
	lambertian20_4_dir			= '../DB_LAMBERTIAN20_4/';
	lambertian20_5_dir			= '../DB_LAMBERTIAN20_5/';
	
	image_OrenNayar20_2			= '../DB_ORENNAYAR20_2/';
	image_OrenNayar20_3			= '../DB_ORENNAYAR20_3/';
	image_OrenNayar20_4			= '../DB_ORENNAYAR20_4/';
	image_OrenNayar20_5			= '../DB_ORENNAYAR20_5/';
	
	image_Phong_TT				= '../DB_PHONG_TT/';
	image_Lambertian_TT			= '../DB_LAMBERTIAN_TT/';
	
	
	image_dir = photex_dir;

%% response directories	
	responses_original			= '../responses_original/';
	
	responses_Lambertian4_1		= '../responses_Lambertian4_1/';
	responses_Lambertian20_1	= '../responses_Lambertian20_1/';

	responses_Phong4_1			= '../responses_Phong4_1/';
	responses_Phong20_1			= '../responses_Phong20_1/';

	responses_OrenNayar4_1		= '../responses_OrenNayar4_1/';
	responses_OrenNayar20_1		= '../responses_OrenNayar20_1/';

	responses_Phong_TT			= '../responses_Phong_TT/';

	
	responses_Lambertian20_2	= '../responses_Lambertian20_2/';
	responses_Lambertian20_3	= '../responses_Lambertian20_3/';
	responses_Lambertian20_4	= '../responses_Lambertian20_4/';
	responses_Lambertian20_5	= '../responses_Lambertian20_5/';
	
	responses_OrenNayar20_2		= '../responses_OrenNayar20_2/';
	responses_OrenNayar20_3		= '../responses_OrenNayar20_3/';
	responses_OrenNayar20_4		= '../responses_OrenNayar20_4/';
	responses_OrenNayar20_5		= '../responses_OrenNayar20_5/';

	responses_dir				= responses_original;

%% marginal directories
	marginal_original		= '../marginals_original/';
	
	marginal_Lambertian4_1	= '../marginals_Lambertian4_1/';
	marginal_Lambertian20_1	= '../marginals_Lambertian20_1/';

	marginal_Phong4_1		= '../marginals_Phong4_1/';
	marginal_Phong20_1		= '../marginals_Phong20_1/';

	marginal_OrenNayar4_1	= '../marginals_OrenNayar4_1/';
	marginal_OrenNayar20_1	= '../marginals_OrenNayar20_1/';

	marginal_Phong_TT		= '../marginals_Phong_TT/';

	
	marginal_Lambertian20_2	= '../marginals_Lambertian20_2/';
	marginal_Lambertian20_3	= '../marginals_Lambertian20_3/';
	marginal_Lambertian20_4	= '../marginals_Lambertian20_4/';
	marginal_Lambertian20_5	= '../marginals_Lambertian20_5/';

	marginal_OrenNayar20_2	= '../marginals_OrenNayar20_2/';
	marginal_OrenNayar20_3	= '../marginals_OrenNayar20_3/';
	marginal_OrenNayar20_4	= '../marginals_OrenNayar20_4/';
	marginal_OrenNayar20_5	= '../marginals_OrenNayar20_5/';

	marginal_dir			= marginal_original;



	
% 	run(5, photex_dir, photex_dir, '../responses_original/', '../marginals_original/', ...
% 		'experiment1/marginals_original.mat', 'experiment1/marginals_original.mat');

% 	run(5, photex_dir, '../DB_LAMBERTIAN20_1/', '../responses_Lambertian20_1/', '../marginals_Lambertian20_1/', ...
% 			'experiment1/marginals_original.mat', 'experiment1/marginals_Lambertian20_1.mat');

	run(5, photex_dir, '../DB_PHONG20_1/', '../responses_Phong20_1/', '../marginals_Phong20_1/', ...
		'experiment1/marginals_Original.mat', 'experiment1/marginals_Phong20_1.mat');

% 	createSynthesizedDatabase();
% 
% 	run(1, photex_dir, '../DB_PHONG4_1/', '../responses_Phong4_1/', '../marginals_Phong4_1/', ...
% 		'experiment1/marginals_Original.mat', 'experiment1/marginals_Phong4_1.mat');
end