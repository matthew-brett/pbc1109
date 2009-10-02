function PlotFiber( FiberList )

% PlotFiber( FiberList )
% Plot fibers using matlab's plot3 function. 
% Input:
%       FiberList: List of Fiber Labels 
% Example;
% 
% PlotFiber( FiberList )
%
% written by Sudhir K Pathak
% Date: March 10 2009
% for PghBC2009 competition 2009 url:http://sfcweb.lrdc.pitt.edu/pbc/2009/

%
% $Id: PlotFiber.m,v 1.1 2009/09/18 20:45:17 fissell Exp $
%

global PghBC2009_DEF;
if (~isfield(PghBC2009_DEF, 'track'))
	fprintf(1, '\nPardon, it appears that the PghBC2009_DEF.track field has not been set; please call setGlobalTrack.\n');
	return;
end;

no_fibers = length(FiberList);

figure;
hold on;
for i=1:no_fibers
    plot3(PghBC2009_DEF.track.fiber{FiberList(i)}.points(:,1),PghBC2009_DEF.track.fiber{FiberList(i)}.points(:,2),PghBC2009_DEF.track.fiber{FiberList(i)}.points(:,3));
end;

xlabel('X axis');ylabel('Y axis');zlabel('Z axis');
title(sprintf('Number of Fiber %4d',no_fibers));
