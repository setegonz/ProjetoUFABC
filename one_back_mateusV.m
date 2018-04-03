
try
    
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
    
    
    
    %% KEYBOARD CONFIG
    %     KbName('UnifyKeyNames');
    % nBackKey  = KbName('space');
    % clockKey  =  KbName('1!');
    % oneMinKey =  KbName('2@');
    % escapeKey = KbName('ESCAPE');
    %
    %     RestrictKeysForKbCheck([nBackKey,clockKey,escapeKey]);
    %     KbCheck;
    %     ListenChar(2);
    %% Choose stimuli sample for task
    
    % Choose random sample of 7 images without replacement
    [imageSample, imageSampleIdx] = datasample(sourceImages, 7, 'Replace', false);
    
    % There is not a target image for 1-back and 2-back, this is for sizing
    % purposes only.
    % Choose first image as target image
    if stim == 0
        targetImage = imread(fullfile(pwd, 'stimuli', 'neutral', imageSample(1).name));
    elseif stim == 1
        targetImage = imread(fullfile(pwd, 'stimuli', 'positive', imageSample(1).name));
    elseif stim == 2
        targetImage = imread(fullfile(pwd, 'stimuli', 'negative', imageSample(1).name));
    end
    
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
    %Get the size of the on screen window
    % [screenXpixels, screenYpixels] = Screen('WindowSize', window); %screenXpixels=1280 %screenYpixels=800
    % % Get the centre coordinate of the window
    %     [xCenter, yCenter] = RectCenter(rect);
    
    % Calculate size and x-coordinate of target image. Used to position
    % stimuli.
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
    instructions = 'Pressione a barra de espaco quando ver \n uma repeticao de imagem duas vezes seguidas.\n Pressione espaco para comecar.\n';
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
    
    tStim = .5; %500ms
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
            if GetSecs-whenWasPressed > .15 % but just after 300s after the last press (to avoid "repetitions" of values on the matrix because of a long press in the button)
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
                
                if clockPress && ~startClock
                    startClock = true;
                    shownClock = GetSecs;
                    DrawFormattedText(window, nowClock, 'right', 'center',[0 0 0]);
                elseif clockPress && (time - shownClock < clockDuration)
                    DrawFormattedText(window, nowClock, 'right', 'center',[0 0 0]);
                else
                    startClock = false;
                    clockPress = false;
                end
                
                if GetSecs-timeStart >= 10
                    DrawFormattedText(window, 'You have to reset clock to 0', 'right', 'center',[0 0 0]);
                end
                
                % Save the time the screen was flipped
                stimulusStartTime = Screen('Flip', window);
                time = GetSecs;
%                 if startClock 
%                     clockPress = false;
%                     shownClock = 0;
%                 end
                
                firstStimFrame = false;
            else
                if clockPress && ~startClock
                    startClock = true;
                    shownClock = GetSecs;
                    DrawFormattedText(window, nowClock, 'right', 'center',[0 0 0]);
                elseif clockPress && (time - shownClock < clockDuration)
                    DrawFormattedText(window, nowClock, 'right', 'center',[0 0 0]);
                else
                    startClock = false;
                    clockPress = false;
                end
                
                if GetSecs-timeStart >= 10
                    DrawFormattedText(window, 'You have to reset clock to 0', 'right', 'center',[0 0 0]);
                end
                
                if time - stimulusStartTime < tStim
                    Screen('DrawTexture', window, images(ii), [], [centeredRect], 0);
                elseif (time - stimulusStartTime >= tStim) && (time - stimulusStartTime < tISI(ii))
                    [x, y] = meshgrid(-250:1:250, -250:1:250);
                    [s1, s2] = size(x);
                    
                    % Make ablack and white noise texture
                    noise = wgn(s1,s2,0);
                    noiseTexture = Screen('MakeTexture', window, noise);
                    
                    % Batch Draw all of the texures to screen
                    Screen('DrawTextures', window, noiseTexture, [], centeredRect);
                else
                    trialRun = false;
                end
                
                time = Screen('Flip', window);
                
%                 if startClock && (time - shownClock > clockDuration)
%                     clockPress = false;
%                     shownClock = 0;
%                 end
            end
            time = GetSecs;
        end
        
        
        
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