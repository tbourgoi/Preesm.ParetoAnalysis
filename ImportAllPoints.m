%% Import data from text file.
% Script for importing data from the following text file:
%
%    F:\INSA\InnovR\R�sultat compilation\EzSift_V5\Hvideo_4CoresX86_all_points_log.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2021/04/02 16:19:15

%% Initialize variables.
filename = ['F:\INSA\InnovR\R�sultat compilation\',directorySave,'Hvideo_4CoresX86_all_points_log.csv'];
delimiter = ';';
startRow = 2;

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: text (%s)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%s%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
nKeypointsMaxUser = dataArray{:, 1};
image_width = dataArray{:, 2};
parallelismLevel = dataArray{:, 3};
AspectRatioDenominator = dataArray{:, 4};
delayRead = dataArray{:, 5};
delayDisplay = dataArray{:, 6};
NumeratorFrequency = dataArray{:, 7};
imgDouble = dataArray{:, 8};
Schedulability = dataArray{:, 9};
Energy = dataArray{:, 10};
Latency = dataArray{:, 11};
DurationII = dataArray{:, 12};
Memory = dataArray{:, 13};
AskedCuts = dataArray{:, 14};
AskedPrecuts = dataArray{:, 15};


%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;