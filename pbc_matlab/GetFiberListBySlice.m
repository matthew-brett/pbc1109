function FiberList = GetFiberListBySlice( sliceX, sliceY, sliceZ)

% FiberList = GetFiberListBySlice( sliceX, sliceY, sliceZ)
% Outputs union of List of fiber labels passing through sliceX or sliceY or sliceZ
%
% Input:
%       sliceX, sliceY and sliceZ are int or empty ("[]") representing slice number 
%       in X Y Z dimension. "[]" means you don't want to include 
% Output:
%       FiberList: List of fiber labels.
%
% For details about header fields and fileformat see:
% http://www.trackvis.org/docs/?subsect=fileformat
%
%
% Example;
% 
% Fibers passing through slice X = 65
% FiberList = GetFiberListBySlice( 65, [], []);
%
% Fibers passing through slice Y = 39
% FiberList = GetFiberListBySlice( [], 39, []);
%
% Fibers passing through slice Z = 52
% FiberList = GetFiberListBySlice( [], [], 52);
%
% Union of Fibers passing through slice Y = 72 and Z = 39
% FiberList = GetFiberListBySlice( [], 72, 39);
%
% written by Sudhir K Pathak
% Date: March 10 2009
% for PghBC2009 competition 2009 url:http://sfcweb.lrdc.pitt.edu/pbc/2009/


%
% $Id: GetFiberListBySlice.m,v 1.1 2009/09/18 21:29:20 fissell Exp $
%

global PghBC2009_DEF;
if (~isfield(PghBC2009_DEF, 'FiberLabelVol'))
	fprintf(1, '\nPardon, it appears that the PghBC2009_DEF.FiberLabelVol field has not been set; please call setGlobalFiberLabelVol.\n');
	return;
end;

if isempty(sliceX) && isempty(sliceY) && isempty(sliceZ)
    sprintf(1,'No slice is selected');
    FiberList = [];
    return;
end;

v_dim = size(PghBC2009_DEF.FiberLabelVol);

wx = [];
if ~isempty(sliceX)
    if sliceX < 1 && sliceX > v_dim(1), fprintf(1,'\nsliceX can min = 1 and max = %d\n',v_dim(1)); return; end;
    for i=1:v_dim(2)
        for j=1:v_dim(3)
            wx = [wx PghBC2009_DEF.FiberLabelVol{sliceX,i,j}];
        end;
    end;
end;

wy = [];
if ~isempty(sliceY)
    if sliceY < 1 && sliceY > v_dim(2), fprintf(1,'\nsliceY can min = 1 and max = %d\n',v_dim(2)); return; end;
    for i=1:v_dim(1)
        for j=1:v_dim(3)
            wy = [wy PghBC2009_DEF.FiberLabelVol{i,sliceY,j}];
        end;
    end;
end;

wz = [];
if ~isempty(sliceZ)
    if sliceZ < 1 && sliceZ > v_dim(3), fprintf(1,'\nsliceZ can min = 1 and max = %d\n',v_dim(3)); return; end;
    for i=1:v_dim(1)
        for j=1:v_dim(2)
            wz = [wz PghBC2009_DEF.FiberLabelVol{i,j,sliceZ}];
        end;
    end;
end;

FiberList = [wx wy wz];
FiberList = unique(FiberList);
