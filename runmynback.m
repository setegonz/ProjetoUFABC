%% General set-up

% Clear screen and workspace
sca;
close all;
clearvars;

% Save current directory
h = pwd;

% Get subject number from user
sub_num = input ('Subject number: ');

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
[window, rect] = PsychImaging('OpenWindow', 0, []);

%[0 0 1280 600]);

% Get the center coordinates of the screen
[centerX, centerY] = RectCenter(rect);

% Get the size of the screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Disable all keys except for space bar
keys = 1:256;
keys(44) = [];
olddisabledkeys = DisableKeysForKbCheck(keys);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Set experiment parameters%%%%%%%%%%%%%%%%%

% Set the number of runs. The script will run each condition this many
% times.
nruns = 1;

% Preallocate a cell array to collect data. There are 10 trials per run and
% 6 conditions (6*10), which we can muliply by the number of runs. There
% are 8 different measures being collected.

C = cell(nruns*60,6);

% This is the master index, which tells us which trial we are on for data
% collection purposes.
mi = 1;

% Create directory of images
practiceSourceImages = dir(fullfile(pwd,'stimuli','practice','*.jpg')) %practice
neutralSourceImages = dir(fullfile(pwd,'stimuli','neutral','*.jpg'));    %Neutral
positiveSourceImages = dir(fullfile(pwd,'stimuli','positive','*.jpg')); %Positive
negativeSourceImages = dir(fullfile(pwd,'stimuli','negative','*.jpg')); %Negative

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Show practice & run experiment based on subject number %%%
%cd scripts;
practice;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Transition to real experiment %%%%%%%%%%%%%%%%%%%%%%
instructions = 'Vc ta pronta(o) pro experimento real? \n barra espa??adora.\n ';
Screen('TextFont', window, 'Avenir');
Screen('TextSize', window, 80);
DrawFormattedText(window, instructions, 'center', 'center', 0, [], [], [], 1.5);
Screen('Flip', window);

[~, ~, ~] = KbWait([], 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Run experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%
setCondition;
cd(h)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Put data into a table %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T = cell2table(C, 'VariableNames', {'Trial', 'nBack', 'Valence', 'Image',...
    'RT', 'Accuracy'});

% Name file using sub_num & write table
file_name = sprintf('sub_%d.txt',sub_num);

% move to data file and write table
cd data
writetable(T, file_name)

%% Close all screens
Screen('Close')
