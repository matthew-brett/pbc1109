function FiberLabelVolume = GetFiberLabeledVolume()

% FiberLabelVolume = GetFiberLabeledVolume( track )
% Creates a matlab 3D dimensional cell data structure of size same as
% underlying volume. Each elements in this data structure is a array of integers.
% Integers represent labels of tracks in track data structure.
%
% Input: None but assumes a global variable defined as PghBC2009_DEF with a
% field track. 
%       track is a matlab structure.
%       It contains following fields:
%           header: is a matlab structure. It contains all header information 
%                   requires to visualize fiber tracks in trackvis.
%           fiber: is a matlab cell. Each cell corresponds to a single fiber.
%                  Each fiber is a matlab structure. It contains following fields;
%                  num_points: Number of points in a fiber track.
%                  points    : is a num_points X 3 matrix, each row
%                              contains (x, y, z) coordinate location in
%                              mm coordinate space.
% Output:
%   FiberLabelVolume : is a matlab 3D cell data structure with each element in the
%                      3D cell is list of all fiber passing through voxel corresponds
%                      to that element.
%
% For details about header fields and fileformat see:
% http://www.trackvis.org/docs/?subsect=fileformat
%
%
% Example;
% 
% FiberLabelVolume = GetFiberLabeledVolume();
%
% In matlab workspace window you will see:
% FiberLabelVolume <128x128x68 cell>
%
% written by Sudhir K Pathak and Kate Fissell
% Date: March 10 2009
% for PghBC2009 competition 2009 http://sfcweb.lrdc.pitt.edu/pbc/2009/

%
% $Id: GetFiberLabeledVolume.m,v 1.1 2009/09/18 21:15:02 fissell Exp $
%

global PghBC2009_DEF;
if (~isfield(PghBC2009_DEF, 'track'))
	fprintf(1, '\nPardon, it appears that the PghBC2009_DEF.track field has not been set; please call setGlobalTrack.\n');
	return;
end;

v_dim    = double(PghBC2009_DEF.track.header.dim');
v_size_x = PghBC2009_DEF.track.header.voxel_size(1);
v_size_y = PghBC2009_DEF.track.header.voxel_size(2);
v_size_z = PghBC2009_DEF.track.header.voxel_size(3);
no_fibers = PghBC2009_DEF.track.header.n_count;

vsizes = [v_size_x; v_size_y; v_size_z];



%%%% Pass 1: Count fibers per voxel so we know what size cell array to allocate
%%%%         Due to matlab performance with incremental increases in cell array
%%%%         sizes it is necessary to run in 2 passes.

fprintf(1,'Counting Fibers...\n');

counts = int16(zeros(PghBC2009_DEF.track.header.dim'));
pct = 10;
for i=1:no_fibers

    
    n_points = PghBC2009_DEF.track.fiber{i}.num_points;
    fiber_indices = PghBC2009_DEF.track.fiber{i}.points;

    %%fprintf(1, '\nFiber %d, points %d',i,n_points);

    %% convert mm coords to matrix indices
    for coord = 1:3
    
    	fiber_indices(:,coord) = floor(fiber_indices(:,coord) / vsizes(coord)) + 1;
    	too_low = find(fiber_indices(:,coord) < 1);
    	if (length(too_low > 0))
    		fiber_indices(too_low,coord) = 1;
		fprintf(1, '\nWarning: Fiber Point Index near Edge in fiber %d',i);
    	end
    	too_hi = find(fiber_indices(:,coord) > v_dim(coord));
    	if (length(too_hi > 0))
    		fiber_indices(too_hi,coord) = v_dim(coord) ;
		fprintf(1, '\nWarning: Fiber Point Index near Edge in fiber %d',i);
    	end

    end
    
    %% flip z indices
    % fiber_indices(:,3) = v_dim(3) + 1 - fiber_indices(:,3);   

 
    %% discard any duplicate points from rounding issues
    fiber_indices_keep = unique(fiber_indices, 'rows');

  

    u_points = length(fiber_indices_keep(:,1));
    
   for ii=1:u_points 
        myx = fiber_indices_keep(ii,1);
	myy = fiber_indices_keep(ii,2);
	myz = fiber_indices_keep(ii,3);
        counts(myx, myy, myz) = counts(myx, myy, myz) + 1;
   end;
 
 
 
    %% progress report
    if mod(i,floor(no_fibers/10)) ==  0
        fprintf(1,'\nPass 1/2:  %d percent fibers processed...', pct);
	pct = pct + 10;
    end;

end;



%%%%%%% Allocate cell array
fprintf(1,'\n\nAllocating Fiber Labeled Volume Cell Array...\n');

   for xx = 1:v_dim(1)
	for yy = 1:v_dim(2)
		for zz = 1:v_dim(3)
			if (counts(xx,yy,zz) > 0)
				FiberLabelVolume{xx,yy,zz} = zeros(1,counts(xx,yy,zz));
			end
		end
	end
    end



%%%%%%% Pass 2, fill the cell array with fiber ids 
fprintf(1,'\n\nCreating Fiber Labeled Volume...\n');
FiberLabelVolume = cell(v_dim);


counts = int16(zeros(PghBC2009_DEF.track.header.dim'));
pct = 10;
for i=1:no_fibers

    
    n_points = PghBC2009_DEF.track.fiber{i}.num_points;
    fiber_indices = PghBC2009_DEF.track.fiber{i}.points;

    %%fprintf(1, '\nFiber %d, points %d',i,n_points);

    %% convert mm coords to matrix indices
    for coord = 1:3
    
    	fiber_indices(:,coord) = floor(fiber_indices(:,coord) / vsizes(coord)) + 1;
    	too_low = find(fiber_indices(:,coord) < 1);
    	if (length(too_low > 0))
    		fiber_indices(too_low,coord) = 1;
		fprintf(1, '\nWarning: Fiber Point Index near Edge in fiber %d',i);
    	end
    	too_hi = find(fiber_indices(:,coord) > v_dim(coord));
    	if (length(too_hi > 0))
    		fiber_indices(too_hi,coord) = v_dim(coord) ;
		fprintf(1, '\nWarning: Fiber Point Index near Edge in fiber %d',i);
    	end

    end
    
    %% flip z indices
    % fiber_indices(:,3) = v_dim(3) + 1 - fiber_indices(:,3);   

 
    %% discard any duplicate points from rounding issues
    fiber_indices_keep = unique(fiber_indices, 'rows');

  

    u_points = length(fiber_indices_keep(:,1));
    
   for ii=1:u_points 
        myx = fiber_indices_keep(ii,1);
	myy = fiber_indices_keep(ii,2);
	myz = fiber_indices_keep(ii,3);
        counts(myx, myy, myz) = counts(myx, myy, myz) + 1;
        FiberLabelVolume{myx,myy,myz}(counts(myx, myy, myz)) = i;
   end;
 
 
 
    %% progress report
    if mod(i,floor(no_fibers/10)) ==  0
        fprintf(1,'\nPass 2/2:  %d percent fibers processed...', pct);
	pct = pct + 10;
    end;

end;




fprintf(1,'\n');


