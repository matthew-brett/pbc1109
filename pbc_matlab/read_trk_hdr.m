function track_hdr = read_trk_hdr( filename )

% track_hdr = read_trk_hdr( filename)
% read_trk_hdr reads header information about fiber tracks output from trackvis
% Input:
%       filename: Name of track file output from trackvis
%                 The extension of file is .trk
% Output:
%       track is a matlab structure.
%       It contains following fields:
%           header: is a matlab structure. It contains all header information 
%                   requires to visualize fiber tracks in trackvis.
%
% For details about header fields and fileformat see:
% http://www.trackvis.org/docs/?subsect=fileformat
%
%
% Example;
% 
% track_hdr = read_trk_hdr('hardiO10.trk');
% track_hdr = 
%                     id_string: [6x1 char]
%                           dim: [3x1 int16]
%                    voxel_size: [3x1 double]
%                        origin: [3x1 double]
%                     n_scalars: 0
%                   scalar_name: [200x1 char]
%                  n_properties: 0
%                 property_name: [200x1 char]
%                      reserved: [508x1 char]
%                   voxel_order: [4x1 char]
%                          pad2: [4x1 char]
%     image_orientation_patient: [6x1 double]
%                          pad1: [2x1 char]
%                      invert_x: 0
%                      invert_y: 0
%                      invert_z: 0
%                       swap_xy: 0
%                       swap_yz: 0
%                       swap_zx: 0
%                       n_count: 247974
%                       version: 1
%                      hdr_size: 1000
%
% written by Sudhir K Pathak
% Date: March 10 2009
% for PghBC2009 competition 2009 url:http://sfcweb.lrdc.pitt.edu/pbc/2009/
% NOTE: This program reads trk file in little endian format
% If you want to change it for big endian type >help fopen in matlab

%
% $Id: read_trk_hdr.m,v 1.1 2009/09/18 20:45:17 fissell Exp $
%



fid = fopen(filename ,'r');

track_hdr.id_string                  = fread(fid,6,'char=>char');
track_hdr.dim                        = fread(fid,3,'int16=>int16');
track_hdr.voxel_size                 = fread(fid,3,'float');
track_hdr.origin                     = fread(fid,3,'float');
track_hdr.n_scalars                  = fread(fid,1,'int16=>int16');
track_hdr.scalar_name                = fread(fid,200,'char=>char');
track_hdr.n_properties               = fread(fid,1,'int16=>int16');
track_hdr.property_name              = fread(fid,200,'char=>char');
track_hdr.reserved                   = fread(fid,508,'char=>char');
track_hdr.voxel_order                = fread(fid,4,'char=>char');
track_hdr.pad2                       = fread(fid,4,'char=>char');
track_hdr.image_orientation_patient  = fread(fid,6,'float');
track_hdr.pad1                       = fread(fid,2,'char=>char');
track_hdr.invert_x                   = fread(fid,1,'uchar');
track_hdr.invert_y                   = fread(fid,1,'uchar');
track_hdr.invert_z                   = fread(fid,1,'uchar');
track_hdr.swap_xy                    = fread(fid,1,'uchar');
track_hdr.swap_yz                    = fread(fid,1,'uchar');
track_hdr.swap_zx                    = fread(fid,1,'uchar');
track_hdr.n_count                    = fread(fid,1,'int');
track_hdr.version                    = fread(fid,1,'int');
track_hdr.hdr_size                   = fread(fid,1,'int');

fclose(fid);
