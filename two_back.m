try
%% General set-up 

% Get names of task source images depending on stim type
    %% General set-up
    neutralSourceImages = dir(fullfile(pwd,'stimuli','neutral','*.jpg'));    %Neutral
    positiveSourceImages = dir(fullfile(pwd,'stimuli','positive','*.jpg')); %Positive
    negativeSourceImages = dir(fullfile(pwd,'stimuli','negative','*.jpg')); %Negative
    clockDuration = 1; % dura�ao do aparecimento do relogio
    
    % Get names of task source images depending on stim type
    if stim == 0
        sourceImages = dir(fullfile(pwd,'stimuli','neutral','*.jpg'));
    elseif stim == 1
        sourceImages = dir(fullfile(pwd,'stimuli', 'positive','*.jpg'));
    elseif stim == 2
        sourceImages = dir(fullfile(pwd,'stimuli', 'negative','*.jpg'));
    end

%% Choose stimuli sample for task

% Choose random sample of 7 images without replacement
[imageSample, imageSampleIdx] = datasample(sourceImages, 7, 'Replace', false);

% There is not a target image for 1-back and 2-back, this is for sizing
% purposes only
% Choose first image as target image
if stim == 0
    targetImage = imread(fullfile(pwd, 'stimuli', 'neutral', imageSample(1).name));
elseif stim == 1
    targetImage = imread(fullfile(pwd, 'stimuli', 'positive', imageSample(1).name));
elseif stim == 2
    targetImage = imread(fullfile(pwd, 'stimuli', 'negative', imageSample(1).name));
end

% Select index randomly to insert target image 3 times. Note that in the
% case that targetIdx1 == targetIdx2, we may have only 2 targets in a
% trial. For example, if:
% imageSampleIdx = 297   353   262   123   208    39   321 
% targetIdx1 = 5
% targetIdx 2 = 5
% then we would have 
% imageSampleIdx1 = 297   353   262   123   208    39   208   321
% imageSampleIdx2 = 297   353   262   123   208    39   208   208   321
targetIdx1 = randi((length(imageSampleIdx)) - 2);
imageSampleIdx1 = [imageSampleIdx(1:(targetIdx1 + 1)) imageSampleIdx(targetIdx1)...
    imageSampleIdx((targetIdx1 + 2):end)];

targetIdx2 = randi((length(imageSampleIdx1)) - 2);
imageSampleIdx2 = [imageSampleIdx1(1:(targetIdx2 + 1)) imageSampleIdx1(targetIdx2)...
    imageSampleIdx1((targetIdx2 + 2):end)];

targetIdx3 = randi((length(imageSampleIdx2)) - 2);

% Final order of images
shuffledImageSampleIdx = [imageSampleIdx2(1:(targetIdx3 + 1)) imageSampleIdx2(targetIdx3)...
    imageSampleIdx2((targetIdx3 + 2):end)]; 

%% Main routine for two-back task

% Calculate size and x-coordinate of task image in instructions
[s1, s2, s3] = size(targetImage);
targetImageX = (screenXpixels - s2) / 2;
targetImageY = (screenYpixels - s1)/ 2;

% Store image textures in an array
images = [];
filenames = cell(1,length(shuffledImageSampleIdx));
for ii = 1:length(shuffledImageSampleIdx)
    if stim == 0
        image = imread(fullfile(pwd, 'stimuli', 'neutral', sourceImages(shuffledImageSampleIdx(ii)).name));
    elseif stim == 1
        image = imread(fullfile(pwd, 'stimuli','positive', sourceImages(shuffledImageSampleIdx(ii)).name));
    else
        image = imread(fullfile(pwd, 'stimuli','negative', sourceImages(shuffledImageSampleIdx(ii)).name));
    end
    images(ii) = Screen('MakeTexture', window, image);
    filenames(ii) = {sourceImages(shuffledImageSampleIdx(ii)).name};
end
 
% Display instructions for the task
instructions = 'Apreta espaço se tem \n uma imagem doos vezes seguidas.\n practica.\n espaço pra começar.\n';
Screen('TextFont', window, 'Avenir');
Screen('TextSize', window, 80);
DrawFormattedText(window, instructions, 'center', 'center', 0, [], [], [], 1.5);
Screen('Flip', window);

% Wait until user presses a key
[~, ~, ~] = KbWait([], 2);

    %draw square
    baseRect = [0 0 600 600];
    
    % Center the rectangle on the centre of the screen using fractional pixel
    % values.
    % For help see: CenterRectOnPointd
    centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);
    
    
    timeStart = Screen('Flip', window);
    
    fprintf('pressed,time,correct\n');
    
    % First fixation cross
    drawFixation(window, rect, 40, black, 4);
    Screen('Flip', window);
    WaitSecs(1);
    
    startClock = false;
    clockPress = false;
    dataClockPress  = []; % vector to save when clock key was pressed
    dataOneMinPress = []; % vector to save when one minute key was pressed
for ii = 1:length(shuffledImageSampleIdx)
    % verify if presented image was target or not
    if ii > 2
        % Avoid negative indexing
        if shuffledImageSampleIdx(ii) == shuffledImageSampleIdx(ii - 2)
            wasTarget = true;                
        else         
            wasTarget = false;    
        end
    else
        wasTarget = false;
    end
    % response time variables
    whenWasPressed  = NaN;
    timeClockPress  = NaN;
    timeNbackPress  = NaN;
    timeOneMinPress = NaN;
    
    nBackPress = false;
    
    time = GetSecs;
    
    [keyIsDown, whenWasPressed, keyCode] = KbCheck;
    
    firstFrame     = true;
    firstStimFrame = true;
    trialRun       = true;
    
    while trialRun
        % checks if any key was pressed
        if GetSecs-whenWasPressed > .3 % but just after 300ms after the last press (to avoid "repetitions" of values on the matrix because of a long press in the button)
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
            end
            
            if firstStimFrame
                tStim = randi([10 30])/10; % tempo do estimulo na tela, entre 1s e 3s
                
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
                else
                    % Displays a red or green fixation depending on whether the response is correct
                    if (nBackPress && wasTarget) || (~nBackPress && ~wasTarget)
                        % Green fixation as feedback
                        drawFixation(window, rect, 40, [0 255 0], 4);
                        Screen('Flip', window);
                        WaitSecs(1);
                    elseif (nBackPress && ~wasTarget) || (~nBackPress && wasTarget)
                        % Red fixation as feedback
                        drawFixation(window, rect, 40, [255 0 0], 4);
                        Screen('Flip', window);
                        WaitSecs(1);
                    end
                    trialRun = false;
                end
            end
            time = GetSecs;
        end
    
        
    %fprintf('%s,%0.4f,%s\n', keyWasPressed, responseTime, wasTarget);
    
    % Fill in data matrix accordingly
    C(mi,1) = {ii}; %trial number
    C(mi,2) = {1};     %task (0,1,2)
    C(mi,3) = {stim};  %Valence
    C(mi,4) = filenames(ii); %image
    C(mi,5) = {timeNbackPress}; %response time for nBack
    if (nBackPress && wasTarget) || (~nBackPress && ~wasTarget) %accuracy
        C(mi,6) = {1};
    else
        C(mi,6) = {0};
    end
    C(mi,7) = {dataClockPress}; %Clock Monitoring
    C(mi,8) = {dataOneMinPress};
    %raceGender;
    mi = mi + 1;
    
    dataClockPress  = [];
    dataOneMinPress = [];
end
Screen('Close');

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