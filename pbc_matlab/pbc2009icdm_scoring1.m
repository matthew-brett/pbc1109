function your_scores = pbc2009icdm_scoring1(filename)

% function your_score = pbc2009icdm_scoring1(filename)
%
% Program to score PghBC2009 IEEE competition, challenge 1
%
% Input: 
%	filename	File with fiber bundles to be scored.  This is
%			an Nx2 ascii file, first column fiber id, second
%			column fiber bundle label.  Fiber ids and fiber bundle
%			labels are positive integers.
%			The name of file will indicate all relevant information 
%			as to brain, scan, participant, etc. and is as follows:
%			<contestant>_brain#_scan#_submit#.txt
%			eg smith_brain1_scan1_submit2.txt
%			Note that the "submit2" string is added by the PBC
%			webpage upload program.
%			This program assumes a cwd named submissions that
%			has dir <contestant> that contains the input file.
%			This program assumes that the scoring file(s) are in a
%			dir tree called pbc2009icdm rooted at cwd and following
%			the same structure as the PBC download tree
%
% Output:  score
%          logfile written to <contestant> dir
%
%
%
% Written by Kate Fissell
% Date: August 2009
% for PghBC2009IEEE competition  http://sfcweb.lrdc.pitt.edu/pbc/2009/

% $Id: pbc2009icdm_scoring1.m,v 1.1 2009/09/21 20:08:19 fissell Exp $


fprintf(1, '\nThis is a pre-release of the Pittsburgh IEEE Brain Competition 2009 challenge 1 scoring program, released for testing purposes only.\n');


% Maximum number of bundles permitted, whole brain or ROI
MAX_BUNDLES_WHOLEBRAIN = 500;
MAX_BUNDLES_ROI = 20;

%% init score
your_scores = 0;


%% chop .txt extension from filename
i = strfind(filename, '.txt');
if (length(i) > 1) 
	fprintf(1, '\nError, filename %s has repeat of txt extension\n',filename);
	return;
end
if (length(i) == 1)
	filename = filename(1:i-1);
end


%% get information from filename string
[PARTICIP, BRAIN, SCAN, SUBMIT] = check_input_name2B(filename);
if (PARTICIP == -1)
	fprintf(1, '\nError processing %s\n',filename);
	return;
end


%% pathname of directory that contains the gold standard bundles used by PBC to 
%% score contestant solutions.
%% These gold standard bundles are released to contestants only for Brain1, for 
%% testing purposes
GOLD_DIR = sprintf('pbc2009icdm/%s', BRAIN);


%%  List of bundle labels to score against.  See brain1_scan1_bundle_ids.txt
%% 1       Arcuate
%% 2       Cingulum
%% 3       Corticospinal
%% 4       Forceps Major
%% 5       Fornix
%% 6       Inferior Occipitofrontal Fasciculus
%% 7       Superior Longitudinal Fasciculus
%% 8       Uncinate

BUNDLE_LIST = [1 2 3 4 5 6 7 8];



%% open logfile
lfname = sprintf('submissions/%s/%s_report_%s.txt',PARTICIP,filename,datestr(now, 'ddmmmyy-HHMMSS'));
fp = fopen(lfname, 'r');
if (fp ~= -1)
	fclose(fp);
	fprintf(1, '\n Error, logfile %s already exists.\n',lfname');
	return;
end
logfp = fopen(lfname, 'w');
if (logfp == -1)
	fprintf(1, '\n Error, logfile %s cannot be opened for write.\n',lfname');
	return;
end


fprintf(logfp, 'Participant:\t%s',PARTICIP);
fprintf(logfp, '\nFilename:\t%s',filename);
fprintf(logfp, '\nDate:\t%s',datestr(now));
fprintf(logfp, '\n');

%% Initialize array of scores on each map to 0
your_scores = zeros(1,length(BUNDLE_LIST));



%% load participant submitted file
particip_bundle_filename = sprintf('submissions/%s/%s_%s_%s_submit%s.txt',PARTICIP, PARTICIP, BRAIN, SCAN, SUBMIT);
particip_bundle = load(particip_bundle_filename);

%% sanity check on input bundle
ret = check_bundleB(particip_bundle);
if (ret ~= 1)
	fprintf(1, '\n Error, sanity check on %s failed.\n',filename);
	fprintf(logfp, '\n Error, sanity check on %s failed.\n',filename);
	fclose(logfp);
	return;
end

%% check max number fiber bundles
label_set = unique(particip_bundle(:,2));
if ( ( (min(label_set) == 0) && (length(label_set) > (MAX_BUNDLES_WHOLEBRAIN+1)) ) || ...
     ( (min(label_set) > 0)  && (length(label_set) > (MAX_BUNDLES_WHOLEBRAIN)) ) ) 
		fprintf(1, '\nERROR: too many fiber bundles submitted: %d', length(label_set) );
		fprintf(1, '\nMax permitted labels is %d (plus label 0)', MAX_BUNDLES_WHOLEBRAIN);
		fprintf(logfp, '\nERROR: too many fiber bundles submitted: %d', length(label_set) );
		fprintf(logfp, '\nMax permitted labels is %d (plus label 0)', MAX_BUNDLES_WHOLEBRAIN);
		fclose(logfp);
		return;
end


%%%%%%%%%%%%%%%%%%%%%%% score each bundle
for i=1:length(BUNDLE_LIST)

	fprintf(1, '\nScoring fiber bundle label %d',BUNDLE_LIST(i));

	%% load scoring bundle
	expert_bundle_green_file  = sprintf('%s/%s_%s_fiber_labels.txt', GOLD_DIR, BRAIN, SCAN);
	expert_bundle_green = load_bundle(BUNDLE_LIST(i), expert_bundle_green_file);

	%% score the bundle
	[your_score your_num_bundles] = score_bundleB(expert_bundle_green, particip_bundle);
	if (your_num_bundles > MAX_BUNDLES_ROI)
		fprintf(logfp, '\nBundle: %s_%s_fiber_labels.txt bundle %d\tNumber overlapping bundles: %d\tScore 0.0000',...
				BRAIN, SCAN, BUNDLE_LIST(i), your_num_bundles);
		fprintf(logfp, '\nERROR: Too many bundles, max submitted bundles per bundle is %d: Bundle: %s_%s_fiber_labels.txt bundle %d \tNumber overlapping bundles: %d',...
		                MAX_BUNDLES_ROI, BRAIN, SCAN, BUNDLE_LIST(i), your_num_bundles);
		fprintf(1, '\nERROR: Too many bundles, max submitted bundles per ROI is %d: Bundle: %s_%s_green_fiberlist.txt\tNumber overlapping bundles: %d',...
			    MAX_BUNDLES_ROI,BRAIN, BUNDLE_LIST(i), your_num_bundles);
		your_scores(i) = 0;
	else
		fprintf(logfp, '\nBundle: %s_%s_fiber_labels.txt bundle %d\tNumber overlapping bundles: %d\tScore %.4f',...
				BRAIN, SCAN, BUNDLE_LIST(i), your_num_bundles, your_score);
		your_scores(i) = your_score;
	end
end



fprintf(logfp, '\n');
fclose(logfp);
return;

% --------------------------------------------------------------------------------
% function score_bundleB
%	compute score of fiber bundle
%
% Inputs: expert green bundle,  bundle to be scored
%         expert green bundle: Nx1 list of fiber labels
%	  est_bundle: Mx2 list of labelled fibers: col1 fiber number, col2 fiber label
% Output: score value, number of overlapping bundles
% --------------------------------------------------------------------------------
 function [s num_bundles] = score_bundleB(green_bundle, est_bundle)
 

%% green = value for correct fibers
%% red = val for incorrect fibers
GREEN = 1;
RED = -1;


% init score to 0		
s = 0;

submit_fibers = est_bundle(:,1);
submit_labels = est_bundle(:,2);

% find set of labels that intersect with green list
[interfibers, inter_submit_ind, inter_expert_ind] = intersect(submit_fibers, green_bundle);
this_bundle_labelsA = unique(submit_labels(inter_submit_ind));

% only include labels > 0
this_bundle_labels = this_bundle_labelsA(find(this_bundle_labelsA>0));


% score each of submitted bundles that overlaps with green bundle
score_array = [];
for i=1:length(this_bundle_labels)

	% get their bundle for this label
	their_bundle_ind = find(submit_labels == this_bundle_labels(i));
	their_fiber_list = submit_fibers(their_bundle_ind);

	% total number of submitted fibers
	total_num = length(their_fiber_list);

	% number of green fibers
	green_num = length(intersect(green_bundle,their_fiber_list ));
	
	
	% number of red fibers
	red_num = total_num - green_num;

	bundle_score = ( (green_num*GREEN) + (red_num*RED) ) / length(green_bundle);

	% only include positive scores	
	if (bundle_score > 0)
		score_array = [score_array; bundle_score];
	end

	fprintf(1, '\nbundle %d of %d: label %d;  length %d;  green %d; target len %d;  score %d',...
		i,length(this_bundle_labels),this_bundle_labels(i),total_num,green_num,length(green_bundle),bundle_score);
end

%% total score is sum of score of each overlapping bundle / total target fibers
s = sum(score_array);

%% number of fiberbundles that overlapped this bundle
num_bundles = length(this_bundle_labels);
	
return;



%---------------------------------------------------------------------------
% function load_bundle
%	load the list of fibers for designated fiber bundle from the scoring file
%       The scoring file has labelled fibers for all bundles
%
% input: label -- the fiber bundle label to load
%        score_file -- the name of the scoring file that has all the labelled fibers
%
% output: fiber_list is a Nx1 list of fiber numbers for all the fibers in 
%	the designated bundle
%---------------------------------------------------------------------------
function fiber_list = load_bundle(label, score_file)


	all_fibers = load(score_file);
	my_fiber_ind = find(all_fibers(:,2) == label);
	fiber_list = all_fibers(my_fiber_ind, 1);

return;




%---------------------------------------------------------------------------
% function check_bundleB
% 	do some minimal sanity checks on submitted bundle list
%
% Input:  loaded bundle, should be an Nx2 vector
%		first col is fiber number, 2nd col is label
% Output: 0/1
%---------------------------------------------------------------------------
function ok = check_bundleB(flist)

ok = 1;

%% must be Nx2 vector
[a, b] = size(flist);
if (b ~= 2)
	ok = 0;
	fprintf(1, '\nError: loaded fiber list is not Nx2 vector, its %d x %d \n',a,b);
	return;
end

fibers = flist(:,1);
labels = flist(:,2);

%%%%%%%%%%%%%%%%%%% checks on fibers

%% must not have any repeated fibers
unique_list = unique(fibers);
if (length(fibers) ~= length(unique_list))
	ok = 0;
	fprintf(1, '\nError: loaded fiber list has repeated fibers: number of fibers: %d;  number of unique fibers: %d\n', length(fibers),length(unique_list));
end

%% must be positive values 1-1000000
if (min(fibers) < 1)
	ok = 0;
	fprintf(1, '\nError: loaded fiber list has min fiber value less than 1: %d\n', min(fibers));	
end

%% must be positive values 1-1000000
if (max(fibers) > 1000000)
	ok = 0;
	fprintf(1, '\nError: loaded fiber list has max fiber value greater than 1000000: %d\n', max(fibers));	
end


%%%%%%%%%%%%%%%%%%% check on labels
%% must be positive values 
if (min(labels) < 0)
	ok = 0;
	fprintf(1, '\nError: loaded fiber list has min label value less than 0: %d\n', min(labels));	
end



return;



%----------------------------------------------------------------------------
% function check_input_name2B
%	checks that the input filename correctly designates a
%	participant, brain, scan, and submission number
%
%	Input: filename
%	Output: strings for participant, brain, scan, and submission number
%	setting participant to -1 indicates error
%-----------------------------------------------------------------------------
function [pa, br, sc, su] = check_input_name2B(f)

pa = -1;
br = -1;
sc = -1;
su = -1;

MAX_SUBMIT = 5;

%% participant
[pa, frest] = strtok(f, '_');


%% brain string
[br, frest] = strtok(frest, '_');
if ( (~strcmp(br,'brain1')) && (~strcmp(br,'brain2')) && (~strcmp(br,'brain3')) )
	fprintf(1, '\nError, string %s does not have correct brain token: %s\n',f, br);
	pa = -1;
	br = -1;
	return;
end


%% scan string
[sc, frest] = strtok(frest, '_');
if ( (~strcmp(sc,'scan1')) && (~strcmp(sc,'scan2')) )
	fprintf(1, '\nError, string %s does not have correct scan token: %s\n',f, sc);
	pa = -1;
	br = -1;
	sc = -1;
	return;
end




%% submission number
[su, frest] = strtok(frest, '_');

% submit string
[ss] = sscanf(su, '%6s', 1);
 if ( ~strcmp(ss, 'submit') )
	fprintf(1, '\nError, string %s does not have correct submit token: %s\n',f,su);
	pa = -1;
	br = -1;
	sc = -1;
	su = -1;
	return;
end

% submit number
xxx = sscanf(su, '%6s%d');
if (length(xxx) ~= 7)
	fprintf(1, '\nError, string %s has invalid submission number: %s\n',f, su);
	pa = -1;
	br = -1;
	sc = -1;
	su = -1;
	return;
end

su_num = xxx(7);

if (su_num < 1)
	fprintf(1, '\nError, string %s has invalid submission number: %d\n',f, su_num);
	pa = -1;
	br = -1;
	sc = -1;
	su = -1;
	return;
end


%% brain1 has unlimited submissions, brains2,3 limited
if (~strcmp(br, 'brain1'))
	if (su_num > MAX_SUBMIT)
		fprintf(1, '\nError, string %s has submission number too high: %d\n',f, su_num);
		pa = -1;
		br = -1;
		su = -1;
		return;
	end

end

su = num2str(su_num);
return;








 	
