function write_trk( track, filename )

% write_trk( track, filename)
% write_trk write fiber tracks in trackvis format
% Input:
%       track:  is a matlab structure.
%               It contains following fields:
%               header: is a matlab structure. It contains all header information 
%                       requires to visualize fiber tracks in trackvis.
%               fiber: is a matlab cell. Each cell corresponds to a single fiber.
%                   Each fiber is a matlab structure. It contains following fields;
%                   num_points: Number of points in a fiber track.
%                   points    : is a num_points X 3 matrix, each row
%                               contains (x, y, z) coordinate location in
%                               mm coordinate space.
%       filename: Name of track file you want to save your data visualization in
%                 TrackVis with extension as trk
%
% For details about header fields and fileformat see:
% http://www.trackvis.org/docs/?subsect=fileformat
%
% Example:
% 
% write_trk( track, filename );
%
%
% written by Sudhir K Pathak
% Date: March 10 2009
% for PghBC2009 competition 2009 url:http://sfcweb.lrdc.pitt.edu/pbc/2009/

%
% $Id: write_trk.m,v 1.1 2009/09/18 20:45:17 fissell Exp $
%


fid = fopen(filename ,'wb');

fwrite(fid,track.header.id_string,'char');
fwrite(fid,track.header.dim,'int16');
fwrite(fid,track.header.voxel_size,'float');
fwrite(fid,track.header.origin,'float');
fwrite(fid,track.header.n_scalars,'int16');
fwrite(fid,track.header.scalar_name,'char');
fwrite(fid,track.header.n_properties,'int16');
fwrite(fid,track.header.property_name,'char');
fwrite(fid,track.header.reserved,'char');
fwrite(fid,track.header.voxel_order,'char');
fwrite(fid,track.header.pad2,'char');
fwrite(fid,track.header.image_orientation_patient,'float');
fwrite(fid,track.header.pad1,'char');
fwrite(fid,track.header.invert_x,'uchar');
fwrite(fid,track.header.invert_y,'uchar');
fwrite(fid,track.header.invert_z,'uchar');
fwrite(fid,track.header.swap_xy,'uchar');
fwrite(fid,track.header.swap_yz,'uchar');
fwrite(fid,track.header.swap_zx,'uchar');
fwrite(fid,track.header.n_count,'int');
fwrite(fid,track.header.version,'int');
fwrite(fid,track.header.hdr_size,'int');

for i=1:track.header.n_count
    fwrite(fid,track.fiber{i}.num_points,'int');
    fwrite(fid,track.fiber{i}.points','float');
end;

fclose(fid);
