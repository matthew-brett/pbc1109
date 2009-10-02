function print_track_info( hdr_info )

% print_track_info( hdr_info )
% read_trk reads fiber tracks output from trackvis
% Input:
%       hdr_info: is either a track file output from TrackVIS or
%                 a matlab structure output from read_trk function or
%                 a matlab structure output from read_trk_hdr function
% Output:
%       Prints Fiber Counts, Voxel Dimension, Number of Voxels and Origin
%       related to fibers.
%
% For details about fileformat see:
% http://www.trackvis.org/docs/?subsect=fileformat
%
%
% Example;
% 
% print_track_info('hardiO10.trk');
% where hardiO10.trk is track fileoutput from TrackVIS
% or
% print_track_info(track.header);
% where track is a output from read_trk function
% or
% print_track_info(track_hdr);
% where track is a output from read_trk_hdr function
%
% written by Sudhir K Pathak
% Date: March 10 2009
% for PghBC2009 competition 2009 url:http://sfcweb.lrdc.pitt.edu/pbc/2009/

%
% $Id: print_track_info.m,v 1.1 2009/09/18 20:45:17 fissell Exp $
%

if isstruct(hdr_info) && isfield(hdr_info, 'n_count')
    track_hdr = hdr_info;
elseif ischar(hdr_info)
    track_hdr = read_trk_hdr( hdr_info);
else
    fprintf('\nError: Input is not in trackvis header format\n\n');
    return;
end;
    

fprintf('\n\n');
fprintf('\t****************************************************\n');
fprintf('\t****************************************************\n');
fprintf('\tInformation about Fiber Data Output from TRACKVIS\n');
fprintf('\tFor details see http://www.trackvis.org\n');
fprintf('\t****************************************************\n');
fprintf('\t****************************************************\n');
fprintf('\n');
fprintf('\tNumber of Tracks:%6d\n',track_hdr.n_count);
fprintf('\tVoxel Dimension:[%5.3f, %5.3f, %5.3f]\n',track_hdr.voxel_size);
fprintf('\tNumber of Voxels in X Y Z dimension:[%3d, %3d, %3d]\n',track_hdr.dim);
fprintf('\tOrigin:[%5.3f, %5.3f, %5.3f]\n',track_hdr.origin);
fprintf('\t****************************************************\n');
fprintf('\n');
