%% General set-up

practiceSourceImages = dir(fullfile(pwd,'stimuli','practice','*.jpg')) %practice
clockDuration = 1; % dura�ao do aparecimento do relogio

         %% KEYBOARD CONFIG
% KbName('UnifyKeyNames');
% spaceBar = KbName('space');
% clockKey =  KbName('1!');
% escapeKey   = KbName('ESCAPE');
% 
% RestrictKeysForKbCheck([spaceBar,clockKey,escapeKey]);
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

clockPress = false;
% drawFixation(window, rect, 40, black, 4);
fixationStartTime = Screen('Flip', window);

for ii = 1:length(shuffledImageSampleIdx)
    responseTime = NaN;
    time = GetSecs;
    [keyIsDown, respTime, keyCode] = KbCheck;
    firstFrame     = true;
    firstStimFrame = true;
    trialRun       = true;
    keyWasPressed = 'false';
    if ii ~= 1 %prova
        % Avoid negative indexing
        if shuffledImageSampleIdx(ii) == shuffledImageSampleIdx(ii - 1)
            wasTarget = 'true';
        else
            wasTarget = 'false';
        end
    else
        wasTarget = 'false';
    end %prova
        while trialRun
            % Displays a red or green fixation depending on whether the response is
            % correct.
%             if strcmp(keyWasPressed,wasTarget)
%                 % Green fixation as feedback
%                 drawFixation(window, rect, 40, [0 1 0], 4);
%                 Screen('Flip', window);
%                 WaitSecs(1);
%             else
%                 % Red fixation as feedback
%                 drawFixation(window, rect, 40, [1 0 0], 4);
%                 Screen('Flip', window);
%                 WaitSecs(1);
%             end %prova
%             if ~keyCode(spaceBar)
%                 [keyIsDown, respTime, keyCode] = KbCheck;
%                 if keyCode(spaceBar)
%                     keyWasPressed='true';
%                     responseTime = GetSecs-stimulusStartTime;
%                 end
%             end
            if ~keyCode(clockKey)
                [keyIsDown, respTime, keyCode] = KbCheck;
                if keyCode(clockKey)
                    clockPress = true
                    timeClockPress = GetSecs;
                    % calcula o tempo do relogio
                    clockTime        = timeClockPress - timeStart; % em segundos
                    clockTimeMinutes = floor(clockTime/60); % minutos
                    clockTimeSecs    = floor(mod(clockTime,60)); % segundos
                    nowClock         = sprintf('%um%us', clockTimeMinutes, clockTimeSecs);
                end
            end
            if firstFrame
                time = GetSecs;
                startClock = false;
                firstFrame = false;
                if startClock && (timeClockPress - shownClock > clockDuration)
                    clockPress = false;
                end
            else
                if time - fixationStartTime < 1
                    time = GetSecs;
                    if startClock && (timeClockPress - shownClock > clockDuration)
                        clockPress = false;
                    end
                else
                    if firstStimFrame
                        tStim = randi([10 30])/10; % tempo do estimulo na tela, entre 1s e 3s
                        Screen('DrawTexture', window, images(ii), [], [centeredRect], 0);
                        % Save the time the screen was flipped
                        stimulusStartTime = Screen('Flip', window);
                        time = GetSecs;
                        %[keyWasPressed, responseTime] = recordKeys(stimulusStartTime, 1); %prova
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
                            trialRun = false;                                                    
                        end
                    end
                end
            end
            time = GetSecs;
        end


%     if ii ~= 1
%         % Avoid negative indexing
%         if shuffledImageSampleIdx(ii) == shuffledImageSampleIdx(ii - 1)
%             wasTarget = 'true';
%         else
%             wasTarget = 'false';
%         end
%     else
%         wasTarget = 'false';
%     end
% 
% 
%         [keyWasPressed, responseTime] = recordKeys(stimulusStartTime, 1);
% 
fprintf('%s,%0.4f,%s\n', keyWasPressed, responseTime, wasTarget);
    % Displays a red or green fixation depending on whether the response is
    % correct.

    if strcmp(keyWasPressed,wasTarget)
        % Green fixation as feedback
        drawFixation(window, rect, 40, [0 1 0], 4);
        Screen('Flip', window);
        WaitSecs(1);
    else
        % Red fixation as feedback
        drawFixation(window, rect, 40, [1 0 0], 4);
        Screen('Flip', window);
        WaitSecs(1);
    end
end

    Screen('Close');
