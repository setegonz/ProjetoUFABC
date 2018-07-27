try

    %% General set-up
    neutralSourceImages = dir(fullfile(pwd,'stimuli','neutral','*.jpg'));    %Neutral
    positiveSourceImages = dir(fullfile(pwd,'stimuli','positive','*.jpg')); %Positive
    negativeSourceImages = dir(fullfile(pwd,'stimuli','negative','*.jpg')); %Negative
    practiceSourceImages = dir(fullfile(pwd,'stimuli','practice','*.jpg')); %Practice
    clockDuration = 1; % dura�ao do aparecimento do relogio

    % Get names of task source images depending on stim type
    if stim == 0
        sourceImages = dir(fullfile(pwd,'stimuli','neutral','*.jpg'));
    elseif stim == 1
        sourceImages = dir(fullfile(pwd,'stimuli', 'positive','*.jpg'));
    elseif stim == 2
        sourceImages = dir(fullfile(pwd,'stimuli', 'negative','*.jpg'));
    elseif stim == 3
        sourceImages = dir(fullfile(pwd,'stimuli', 'practice','*.jpg'))
    end

    %% Choose stimuli sample for task

    % Choose random sample of 22 images without replacement
    [imageSample, imageSampleIdx] = datasample(sourceImages, 22, 'Replace', false);

    % There is not a target image for 1-back and 2-back, this is for sizing
    % purposes only.
    % Choose first image as target image
    if stim == 0
        targetImage = imread(fullfile(pwd, 'stimuli', 'neutral', imageSample(1).name));
    elseif stim == 1
        targetImage = imread(fullfile(pwd, 'stimuli', 'positive', imageSample(1).name));
    elseif stim == 2
        targetImage = imread(fullfile(pwd, 'stimuli', 'negative', imageSample(1).name));
    elseif stim == 3
        targetImage = imread(fullfile(pwd, 'stimuli', 'practice', imageSample(1).name));
    end

    % create a vector of indexes (from 1 to 22) in random order
    shuffledImageSampleIdx = []
    for i=1:22
        shuffledImageSampleIdx = [shuffledImageSampleIdx randperm(22)];
    end
    % selects some indexes to repeat
    idx = sort(randi(length(shuffledImageSampleIdx),1,ceil(length(shuffledImageSampleIdx)/4)),'descend');
    % insert repeated index in the vector
    for i=1:length(idx)
        shuffledImageSampleIdx = [shuffledImageSampleIdx(1:idx(i)) shuffledImageSampleIdx(idx(i)) shuffledImageSampleIdx(idx(i)+1:end)];
    end

 %%
    % Calculate size and x-coordinate of target image. Used to position
    % stimuli.
    [s1, s2, s3] = size(targetImage);
    targetImageX = (screenXpixels - s2) / 2;
    targetImageY = (screenYpixels - s1)/ 2;


    % Store image textures in an array
    images = [];
    filenames = cell(1,22);
    for ii = 1:22
        if stim == 0
            imageNeutral = imread(fullfile(pwd, 'stimuli', 'Neutral', sourceImages(ii).name));
            images(ii) = Screen('MakeTexture', window, imageNeutral);
            filenames(ii) = {neutralSourceImages(ii).name};
        elseif stim == 1
            imagePositive = imread(fullfile(pwd, 'stimuli','Positive', sourceImages(ii).name));
            images(ii) = Screen('MakeTexture', window, imagePositive);
            filenames(ii) = {positiveSourceImages(ii).name};
        elseif stim == 2
            imageNegative = imread(fullfile(pwd, 'stimuli','Negative', sourceImages(ii).name));
            images(ii) = Screen('MakeTexture', window, imageNegative);
            filenames(ii) = {negativeSourceImages(ii).name};
        elseif stim == 3
            imagePractice = imread(fullfile(pwd, 'stimuli','Practice', sourceImages(ii).name));
            images(ii) = Screen('MakeTexture', window, imagePractice);
            filenames(ii) = {practiceSourceImages(ii).name};
        end
    end

    % Display instructions for the task
    instructions = 'Pressione a barra de espaco quando a imagem \n que esta na tela for a mesma que a imagem imediatamente anterior.\n Voce vera uma cruz verde se voce \n esta correto e uma cruz vermelha se voce estiver errado. \n Pressione espaco para comecar.'; %Lembre-se de zerar o relógio toda vez \n que um minuto de experimento passar. \n Pressione espaco para comecar.\n';
    Screen('TextFont', window, 'Avenir');
    Screen('TextSize', window, 30);
    DrawFormattedText(window, instructions, 'center','center', 0, [], [], [], 1.5);
    Screen('Flip', window);
    % Wait until user presses a key
    [~, ~, ~] = KbWait([], 2);

    % First fixation cross
    drawFixation(window, rect, 40, black, 4);
    Screen('Flip', window);
    WaitSecs(1);
    oneMinPressed = false;
    startFeedback = false;
    startClock = false;
    clockPress = false;


    %draw square
    baseRect = [0 0 600 600];

    % Center the rectangle on the centre of the screen using fractional pixel
    % values.
    % For help see: CenterRectOnPointd
    centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);

    dataClockPress  = []; % vector to save when clock key was pressed
    dataOneMinPress = []; % vector to save when one minute key was pressed
    tStim = 1; %ms
    %tISI = setISI(length(shuffledImageSampleIdx)); % tempo do ISI na tela, entre  .5s e 3s
    timeStart = GetSecs;
    timeExperiment = GetSecs;

    [keyIsDown, whenWasPressed, keyCode] = KbCheck;

    for ii = 1:length(shuffledImageSampleIdx)
        if (GetSecs - timeExperiment)/60>1
            Screen('Close');
        else
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
        timeNoiseTexture = NaN;
        nBackPress = false;
        time = GetSecs;
        firstFrame     = true;
        firstStimFrame = true;
        trialRun       = true;
        lastStimPresentation = true;
        firstNoise = false;
        lastNoisePresentation = true;
        endtrial = false;

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
                    oneMinPressed = true;
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
                Screen('DrawTexture', window, images(shuffledImageSampleIdx(ii)), [], [centeredRect], 0);

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
                % Save the time the screen was flipped
                stimulusStartTime = Screen('Flip', window);
                time = GetSecs;
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
                if time - stimulusStartTime <= tStim
                    Screen('DrawTexture', window, images(shuffledImageSampleIdx(ii)), [], [centeredRect], 0);
                    lastStimPresentation = true;
                elseif (time - stimulusStartTime > tStim) && (time - stimulusStartTime <= 2) %tISI(ii))
                    if lastStimPresentation
                        firstNoise = true;
                        lastStimPresentation = false;
                    end
                    if (nBackPress && wasTarget) || (~nBackPress && ~wasTarget)
                        % Green fixation as feedback
                        drawFixation(window, rect, 40, [0 255 0], 4);
                    elseif (nBackPress && ~wasTarget) || (~nBackPress && wasTarget)
                        % Red fixation as feedback
                        drawFixation(window, rect, 40, [255 0 0], 4);
                    end
                    lastNoisePresentation = true;
                else
                    if lastNoisePresentation
                        endtrial = true;
                        lastNoisePresentation = false;
                    end
                    trialRun = false;
                end
                if oneMinPressed && ~startFeedback
                    startFeedback = true;
                    shownFeedback = GetSecs;
                    DrawFormattedText(window, 'Voce zerou \n o relogio', 'right', 'center',[0 0 0]);
                elseif oneMinPressed && (time - shownFeedback <= clockDuration)
                    DrawFormattedText(window, 'Voce zerou \n o relogio', 'right', 'center',[0 0 0]);
                else
                    startFeedback = false;
                    oneMinPressed = false;
                end
                time = Screen('Flip', window);
                if firstNoise
                    firstNoisePresentation = time;
                    firstNoise = false;
                end
                if endtrial
                    endNoise = time;
                    endtrial = false;
                end
            end
            time = GetSecs;
        end
        end
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
