function [vx vy vz] = mm2voxel(x, y, z, track_hdr)

% [vx vy vz] = mm2voxel(x, y, z, track_hdr)
% mm2voxel converts millimeter coordinate of a Point in a fiber
% to voxel coodinate w.r.t underlying image volume
% 
% Example:
% 
% [vx vy vz] = mm2voxel(121.56, 89.56, 39.5, track_hdr)
% 
% NOTE: This is matlab based indexing i.e., Indexing start with 1 insted of
%       0.

%
% $Id: mm2voxel.m,v 1.1 2009/09/21 15:29:30 fissell Exp $
%


vx = floor(x/track_hdr.voxel_size(1)) + 1;
vy = floor(y/track_hdr.voxel_size(2)) + 1;
vz = floor(z/track_hdr.voxel_size(3)) + 1;
