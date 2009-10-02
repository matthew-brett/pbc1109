function FiberStats = GetFiberStats()

% FiberStats = GetFiberStats()
% Outputs Structure with fields as differnt statistics (feature).
% Current it outputs Length (length), Center of Mass (CM), Start Point (Start)
% and End Point (End).
%
% Input:
%       None, It uses global track data from setGlobalTrack function. 
% Output:
%       FiberStats: is a structure with field length, CM Start and END.
%                   length is an array of length of all fiber in
%                   PghBC2009_DEF.track data.
%                   CM is an array with each row as (x,y,z) coordinate in mm space of
%                   center of mass of fiber
%                   Start and End is an array with each row as (x,y,z) coordinate in mm space of
%                   starting and ending point of fiber
%
% For details about header fields and fileformat see:
% http://www.trackvis.org/docs/?subsect=fileformat
%
%
% Example;
% global PghBC2009_DEF
% setGlobalTrack('/data/comp09/PghBC2009/brain0/TractographyResults/DeterministicTractography/QBALLRecon/hardiO10.trk');
% Brain0_Hardi_STATS = GetFiberStats()
% 
% Brain0_Hardi_STATS = 
% 
%     length: [291439x1 double]
%         CM: [291439x3 double]
%      Start: [291439x3 double]
%        End: [291439x3 double]
%
%
% written by Sudhir K Pathak
% Date: March 10 2009
% for PghBC2009 competition 2009 url:http://sfcweb.lrdc.pitt.edu/pbc/2009/
%
% $Id: GetFiberStats.m,v 1.1 2009/09/18 20:45:17 fissell Exp $
%


global PghBC2009_DEF;
if (~isfield(PghBC2009_DEF, 'track'))
	fprintf(1, '\nPardon, it appears that the PghBC2009_DEF.track field has not been set; please call setGlobalTrack.\n');
	return;
end;

no_fibers = PghBC2009_DEF.track.header.n_count;

FiberStats.length = zeros(no_fibers,1);
for i=1:no_fibers
    l_seg = 0;
    no_points = PghBC2009_DEF.track.fiber{i}.num_points;
    for j = 2:no_points
        l_seg = l_seg + sqrt( sum( (PghBC2009_DEF.track.fiber{i}.points(j,:) - PghBC2009_DEF.track.fiber{i}.points(j-1,:)).^2 ));
    end;
    FiberStats.length(i) = l_seg;
end

FiberStats.CM = zeros(no_fibers,3);
for i=1:no_fibers
    FiberStats.CM(i,1) = sum(PghBC2009_DEF.track.fiber{i}.points(:,1))/PghBC2009_DEF.track.fiber{i}.num_points;
    FiberStats.CM(i,2) = sum(PghBC2009_DEF.track.fiber{i}.points(:,2))/PghBC2009_DEF.track.fiber{i}.num_points;
    FiberStats.CM(i,3) = sum(PghBC2009_DEF.track.fiber{i}.points(:,3))/PghBC2009_DEF.track.fiber{i}.num_points;
end

FiberStats.Start = zeros(no_fibers,3);
FiberStats.End   = zeros(no_fibers,3);
for i=1:no_fibers
    FiberStats.Start(i,:) = PghBC2009_DEF.track.fiber{i}.points(1,:);
    FiberStats.End(i,:)   = PghBC2009_DEF.track.fiber{i}.points(end,:);
end
