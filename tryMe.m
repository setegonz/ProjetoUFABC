%% General set-up

% Clear screen and workspace
sca;
close all;
clearvars;

% Save current directory
h = pwd;


% Get subject number from user
subject = input ('Initials: ','s');
task = input ('Task: 1 = 1-back, 2 = 2-back : ');
stim = input('Valence: 0 = neutral, 1 = positive, 2 = negative: ');
nruns = input('Number of runs? ');

% Define black, white, and gray
black = BlackIndex(0);
white = WhiteIndex(0);
grey = white / 2;

% subject = 'v'
% task = 1
% stim = 0
% nruns = 1

%%
try
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
  clockKey  =  KbName('1!');
  oneMinKey =  KbName('2@');
  escapeKey = KbName('ESCAPE');

  RestrictKeysForKbCheck([nBackKey,clockKey,oneMinKey,escapeKey]);
  KbCheck;
  ListenChar(2);

    % This is the master index, which tells us which trial we are on for data
    % collection purposes.

    mi = 1;

    clockDuration = 1; % duracao do aparecimento do relogio

    % Set condition & run experiment based on subject number
    %cd scripts

    %% Run task of choice
    if task == 1
        for ri = 1:nruns
            trial = ri;
            one_back_practiceV
%
%             control
        end
    end

    % Exit

    sca;


    %% Put data into a table.
    % T = cell2table(C, 'VariableNames', {'Trial', 'nBack', 'Valence', 'Image',...
    %    'RT', 'Accuracy', 'Race', 'Gender'});

    T = cell2table(C, 'VariableNames', {'Trial', 'nBack', 'Valence', 'Image',...
        'imagePresentationTime','NoisePresentationTime','x','RT', 'Accuracy', 'Clock', 'dataOneMinPress'});

    % Name file using sub_num & write table
    file_name = sprintf('sub_%s.txt',subject);

    % move to data file and write table
    cd(h)
    cd data
    writetable(T, file_name)
    cd(h)



    % Close all screens

    Screen('Close');

    % Restores the mouse cursor.
    ShowCursor;

    ListenChar(0);

    % Restore preferences
    Screen('Preference', 'VisualDebugLevel',    oldVisualDebugLevel);
    Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);

catch
    % ---------- Error Handling ----------
    % If there is an error in our code, we will end up here.

    % The try-catch block ensures that Screen will restore the display and return us
    % to the MATLAB prompt even if there is an error in our code.  Without this try-catch
    % block, Screen could still have control of the display when MATLAB throws an error, in
    % which case the user will not see the MATLAB prompt.
    Screen('CloseAll');

    % Restores the mouse cursor.
    ShowCursor;
    ListenChar(0);

    % Restore preferences
    Screen('Preference', 'VisualDebugLevel',    oldVisualDebugLevel);
    Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);

    % We throw the error again so the user sees the error description.
    psychrethrow(psychlasterror);
end
