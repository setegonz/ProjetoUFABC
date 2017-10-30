%% General set-up

% Clear screen and workspace
sca;
close all;
clearvars;

% Save current directory
h = pwd;


% Get subject number from user
subject = input ('Initials: ','s');
task = input ('Task: 0 = 0-back, 1 = 1-back, 2 = 2-back : ');
stim = input('Valence: 0 = neutral, 1 = positive, 2 = negative: ');
nruns = input('Number of runs? ');


% Perform standard setup for Psychtoolbox
PsychDefaultSetup(2);

% Define black, white, and gray
black = BlackIndex(0);
white = WhiteIndex(0);
gray = white / 2;

% hide cursor
HideCursor;
 
% Open the window
PsychDebugWindowConfiguration;
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'UseRetinaResolution');
[window, rect] = PsychImaging('OpenWindow', 0, [], []);
%[0 0 1280 600]);
 
% Get the center coordinates of the screen
[centerX, centerY] = RectCenter(rect);    
 
% Get the size of the screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);


% This is the master index, which tells us which trial we are on for data
% collection purposes.

mi = 1;

% Set condition & run experiment based on subject number 
%cd scripts

%% Run task of choice 
if task == 1 
    for ri = 1:nruns
        trial = ri;
        %one_back
        %nuevotryme
        one_back_mateus
        %one_back_mateus_andre
    end
end
    
% Exit 

sca;


%% Put data into a table.
% T = cell2table(C, 'VariableNames', {'Trial', 'nBack', 'Valence', 'Image',...
%    'RT', 'Accuracy', 'Race', 'Gender'});

T = cell2table(C, 'VariableNames', {'Trial', 'nBack', 'Valence', 'Image',...
    'RT', 'Accuracy'});
    
% Name file using sub_num & write table 
file_name = sprintf('sub_%s.txt',subject);

% move to data file and write table
cd(h)
cd data 
writetable(T, file_name)
cd(h)

% Close all screens 

Screen('Close');