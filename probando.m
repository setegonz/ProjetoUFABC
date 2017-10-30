% Clear the workspace and the screen
close all;
clearvars;
sca

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');
tic;

% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);

% Define black, white and grey
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;

% Open an on screen window and color it grey
PsychDebugWindowConfiguration;
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

time = toc;
toc = KbCheck;
[keyWasPressed, responseTime, ~] = KbCheck;
    if KbCheck == true
        clockTime = time - tic;
        nowClock = sprintf('0m%us', round(clockTime));
        DrawFormattedText(window, nowClock, 'right', 'center',[0 0 0]);
        shownClock = Screen('Flip', window);
        % Flip to the screen
        Screen('Flip',[], shownClock);
    end

WaitSecs(10);

% Clear the screen
sca;
