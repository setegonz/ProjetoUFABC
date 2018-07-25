%% General set-up

% Clear screen and workspace
sca;
close all;
clearvars;

% Save current directory
h = pwd;

% Get subject number from user
sub_num = input ('Subject number: ');
condition_exp = input ('Condition: ');

% Perform standard setup for Psychtoolbox
PsychDefaultSetup(2);

% Define black, white, and gray
black = BlackIndex(0);
white = WhiteIndex(0);
grey = white / 2;

% hide cursor
HideCursor;

%% Setup Screen
iscreen = max(Screen('Screens'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('Preference', 'SkipSyncTests', 1) % COMENTAR ISSO DEPOIS, NAO
%         ESQUECER DE JEITO NENHUM!!! (descomentar apenas para testar no pc do lab)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
oldVisualDebugLevel   = Screen('Preference', 'VisualDebugLevel',    3);

oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'UseRetinaResolution');
PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');
video.i = iscreen;
HideCursor(video.i);
window  = Screen('OpenWindow', video.i);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
video.r = Screen('GetFlipInterval', window);
rect    = Screen('Rect', window);
xCenter = rect(3)/2;
yCenter = rect(4)/2;

video.r

%[0 0 1280 600]);

% Get the center coordinates of the screen
[centerX, centerY] = RectCenter(rect);

% Get the size of the screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% % Disable all keys except for space bar
% keys = 1:256;
% keys(44) = [];
% olddisabledkeys = DisableKeysForKbCheck(keys);

%% KEYBOARD CONFIG
KbName('UnifyKeyNames');
nBackKey  = KbName('space');
clockKey  =  KbName('z');
oneMinKey =  KbName('/?'); 
escapeKey = KbName('ESCAPE');

RestrictKeysForKbCheck([nBackKey,clockKey,oneMinKey,escapeKey]);
KbCheck;
ListenChar(2);


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

clockDuration = 1; % duracao do aparecimento do relogio

% Create directory of images
practiceSourceImages = dir(fullfile(pwd,'stimuli','practice','*.jpg')); %practice
neutralSourceImages  = dir(fullfile(pwd,'stimuli','neutral','*.jpg'));  %Neutral
positiveSourceImages = dir(fullfile(pwd,'stimuli','positive','*.jpg')); %Positive
negativeSourceImages = dir(fullfile(pwd,'stimuli','negative','*.jpg')); %Negative

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Show practice & run experiment based on subject number %%%
%cd scripts;
% one_back_practiceV;
stim = 3;
one_back_practiceV;
% one_back_practiceTBPM;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Transition to real experiment %%%%%%%%%%%%%%%%%%%%%%
% instructions = 'Vc ta pronta(o) pro experimento real? \n barra espa??adora.\n ';
% Screen('TextFont', window, 'Avenir');
% Screen('TextSize', window, 80);
% DrawFormattedText(window, instructions, 'center', 'center', 0, [], [], [], 1.5);
% Screen('Flip', window);
% 
% [~, ~, ~] = KbWait([], 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Run experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%
setCondition;
% cd(h)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Put data into a table %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T = cell2table(C, 'VariableNames', {'Trial', 'nBack', 'Valence', 'Image',...
        'imagePresentationTime','NoisePresentationTime','x', 'StimDuration', 'NoiseDuration', 'RT', 'Accuracy', 'experiment' 'Clock', 'dataOneMinPress'});

% Name file using sub_num & write table
file_name = sprintf('sub_%d.txt',sub_num);

% move to data file and write table
cd data
writetable(T, file_name)

%% Close all screens
Screen('Close')
