%% General set-up

practiceSourceImages = dir(fullfile(pwd,'stimuli','practice','*.jpg')) %practice
clockDuration = 1; % dura�ao do aparecimento do relogio

%% KEYBOARD CONFIG
% KbName('UnifyKeyNames');
% nBackKey  = KbName('space');
% clockKey  =  KbName('1!');
% oneMinKey =  KbName('2@');
% escapeKey = KbName('ESCAPE');
%
% RestrictKeysForKbCheck([nBackKey,clockKey,escapeKey]);
% KbCheck;
% ListenChar(2);

%% Choose stimuli sample for task

% Choose random sample of 7 images without replacement
[imageSample, imageSampleIdx] = datasample(practiceSourceImages, 7, 'Replace', false);

% There is not a target image for 1-back and 2-back, this is for sizing
% purposes only.
targetImage = imread(fullfile(pwd, 'stimuli','practice', imageSample(1).name));


% Select index randomly to insert target image 3 times
targetIdx1 = randi(length(imageSampleIdx));
imageSampleIdx1 = [imageSampleIdx(1:targetIdx1) imageSampleIdx(targetIdx1)...
    imageSampleIdx((targetIdx1 + 1):end)];

targetIdx2 = randi(length(imageSampleIdx1));
imageSampleIdx2 = [imageSampleIdx1(1:targetIdx2) imageSampleIdx1(targetIdx2)...
    imageSampleIdx1((targetIdx2 + 1):end)];

targetIdx3 = randi(length(imageSampleIdx2));

% Final order of images
shuffledImageSampleIdx = [imageSampleIdx2(1:targetIdx3) imageSampleIdx2(targetIdx3)...
    imageSampleIdx2((targetIdx3 + 1):end)];

%% Main routine for one-back task

% Calculate size and x-coordinate of target image. Used to position
% stimuli.
[s1, s2, s3] = size(targetImage);
targetImageX = (screenXpixels - s2) / 2;
targetImageY = (screenYpixels - s1)/ 2;


% Store image textures in an array
images = [];
for ii = 1:length(shuffledImageSampleIdx)
    image = imread(fullfile(pwd, 'stimuli', 'practice', practiceSourceImages(shuffledImageSampleIdx(ii)).name));
    images(ii) = Screen('MakeTexture', window, image);
end

% Display instructions for the task
instructions = 'Apreta espaço se tem \n uma imagem doos vezes seguidas.\n practica.\n espaço pra começar.\n';
Screen('TextFont', window, 'Avenir');
Screen('TextSize', window, 80);
DrawFormattedText(window, instructions, 'center','center', 0, [], [], [], 1.5);
Screen('Flip', window);

% Wait until user presses a key
[~, ~, ~] = KbWait([], 2);


%draw square
baseRect = [0 0 600 600];

% Center the rectangle on the centre of the screen using fractional pixel
% values.
% For help see: CenterRectOnPointd
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);

timeStart = Screen('Flip', window)

fprintf('pressed,time,correct\n');

% Display each image followed by fixation cross
% First fixation cross
drawFixation(window, rect, 40, black, 4);
Screen('Flip', window);
WaitSecs(1);

startClock = false;
clockPress = false;
dataClockPress  = []; % vector to save when clock key was pressed
dataOneMinPress = []; % vector to save when one minute key was pressed
tStim = 1; %500ms~
tISI = setISI; % tempo do estimulo na tela, entre  .3s e 3s

[keyIsDown, whenWasPressed, keyCode] = KbCheck;

    for ii = 1:length(shuffledImageSampleIdx)
        
        % verify if presented image was target or not
        if ii ~= 1
            % Avoid negative indexing
            if shuffledImageSampleIdx(ii) == shuffledImageSampleIdx(ii - 1)
                wasTarget = true;
            else
                wasTarget = false;
            end
        else
            wasTarget = false;
        end
        
        % response time variables
        
        timeClockPress  = NaN;
        timeNbackPress  = NaN;
        timeOneMinPress = NaN;
        
        nBackPress = false;
        
        time = GetSecs;
        
        firstFrame     = true;
        firstStimFrame = true;
        trialRun       = true;
        
        while trialRun
            % checks if any key was pressed
            if GetSecs-whenWasPressed > .15 % but just after 300ms after the last press (to avoid "repetitions" of values on the matrix because of a long press in the button)
                [keyIsDown, whenWasPressed, keyCode] = KbCheck;
            end
            if keyIsDown
                if keyCode(clockKey)
                    clockPress = true;
                    timeClockPress = whenWasPressed;
                    
                    % calcula o tempo do relogio
                    clockTime        = timeClockPress - timeStart; % em segundos
                    clockTimeMinutes = floor(clockTime/60); % minutos
                    clockTimeSecs    = floor(mod(clockTime,60)); % segundos
                    nowClock         = sprintf('%um%us', clockTimeMinutes, clockTimeSecs);
                    
                    dataClockPress = [dataClockPress clockTime];
                    clockTime = NaN;
                    keyIsDown = false;
                    
                elseif keyCode(nBackKey)
                    timeNbackPress = whenWasPressed-stimulusStartTime;
                    nBackPress = true;
                    keyIsDown = false;
                    
                elseif keyCode(oneMinKey)
                    timeOneMinPress = whenWasPressed-timeStart;
                    dataOneMinPress = [dataOneMinPress timeOneMinPress];
                    timeOneMinPress = NaN;
                    keyIsDown = false;
                    timeStart = GetSecs; %reset do relogio
                    
                elseif keyCode(escapeKey)
                    Screen('CloseAll');
                    % Restores the mouse cursor.
                    ShowCursor;
                    ListenChar(0);
                    % Restore preferences
                    Screen('Preference', 'VisualDebugLevel',    oldVisualDebugLevel);
                    Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
                    sca;
                end
                keyIsDown = false;
            end
            
            if firstStimFrame
            
                Screen('DrawTexture', window, images(ii), [], [centeredRect], 0);
                % Save the time the screen was flipped
                stimulusStartTime = Screen('Flip', window);
                time = GetSecs;
                
                firstStimFrame = false;
            else
                if time - stimulusStartTime < tStim
                    Screen('DrawTexture', window, images(ii), [], [centeredRect], 0);
                    
                    if clockPress
                        if ~startClock
                            startClock = true;
                            shownClock = GetSecs;
                        end
                        DrawFormattedText(window, nowClock, 'right', 'center',[0 0 0]);
                    end
                    
                    time = Screen('Flip', window);
                    if startClock && (time - shownClock > clockDuration)
                        clockPress = false;
                    end
%                 elseif (time - stimulusStartTime >= tStim) && (time - stimulusStartTime < tISI(ii))
%                 [x, y] = meshgrid(-250:1:250, -250:1:250);
%                 [s1, s2] = size(x);
                else
                    % Displays a red or green fixation depending on whether the response is correct
                    if (nBackPress && wasTarget) || (~nBackPress && ~wasTarget)
                        % Green fixation as feedback
                        drawFixation(window, rect, 40, [0 255 0], 4);
                        Screen('Flip', window);
                        WaitSecs(2);
                    elseif (nBackPress && ~wasTarget) || (~nBackPress && wasTarget)
                        % Red fixation as feedback
                        drawFixation(window, rect, 40, [255 0 0], 4);
                        Screen('Flip', window);
                        WaitSecs(2);
                    end
                    trialRun = false;
                end
            end
            time = GetSecs;
        end
    end
Screen('Close');
