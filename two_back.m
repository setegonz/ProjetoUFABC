 %% General set-up 

% Get names of task source images depending on stim type
if stim == 0 
    sourceImages = dir(fullfile(pwd,'../stimuli', 'intact','*.jpg'));
else
    sourceImages = dir(fullfile(pwd,'../stimuli', 'degraded','*.jpg'));
end;

%% Choose stimuli sample for task

% Choose random sample of 7 images without replacement
[imageSample, imageSampleIdx] = datasample(sourceImages, 7, 'Replace', false);

% There is not a target image for 1-back and 2-back, this is for sizing
% purposes only
% Choose first image as target image
if stim == 0
    targetImage = imread(fullfile(pwd, '../stimuli','intact', imageSample(1).name));
else 
    targetImage = imread(fullfile(pwd, '../stimuli','degraded', imageSample(1).name));
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
        image = imread(fullfile(pwd, '../stimuli', 'intact', sourceImages(shuffledImageSampleIdx(ii)).name));
    else 
        image = imread(fullfile(pwd, '../stimuli','degraded', sourceImages(shuffledImageSampleIdx(ii)).name));
    end 
    images(ii) = Screen('MakeTexture', window, image);
    filenames(ii) = {sourceImages(shuffledImageSampleIdx(ii)).name};
end
 
% Display instructions for the task
instructions = 'Press the spacebar when you see an image that \n matches the one presented two prior.\n Press space to begin. \n';
Screen('TextFont', window, 'Avenir');
Screen('TextSize', window, 80);
DrawFormattedText(window, instructions, 'center', 'center', 0, [], [], [], 1.5);
Screen('Flip', window);

% Wait until user presses a key
[~, ~, ~] = KbWait([], 2);

% Draw fixation cross
drawFixation(window, rect, 40, black, 4);
Screen('Flip', window);
WaitSecs(1);
 
fprintf('pressed,time,correct\n');
% Display each image followed by fixation cross 
for ii = 1:length(shuffledImageSampleIdx)
    % Draw the image so that it is centered 
    Screen('DrawTexture', window, images(ii), [],... 
        [(targetImageX) (targetImageY)... 
        (targetImageX + s2) (targetImageY + s1)], 0);
    % Save the time the screen was flipped
    stimulusStartTime = Screen('Flip', window);
    
    [keyWasPressed, responseTime] = recordKeys(stimulusStartTime, 1);
    
    if ii > 2
        % Avoid negative indexing
        if shuffledImageSampleIdx(ii) == shuffledImageSampleIdx(ii - 2)
            wasTarget = 'true';                
        else         
            wasTarget = 'false';    
        end
    else
        wasTarget = 'false';
    end
        
    %fprintf('%s,%0.4f,%s\n', keyWasPressed, responseTime, wasTarget);
    
    % Fill in data matrix accordingly 
    C(mi,1) = {trial}; %trialnumber
    C(mi,2) = {2};     %task (0,1,2)
    C(mi,3) = {stim};  %intact(0), degraded(1)
    C(mi,4) = filenames(ii);
    C(mi,5) = {responseTime};  
    if strcmp(keyWasPressed,wasTarget) %accuracy
        C(mi,6) = {1};
    else
        C(mi,6) = {0};
    end 
    raceGender;
    mi = mi + 1;
        
    drawFixation(window, rect, 40, black, 4);
    Screen('Flip', window);
    WaitSecs(1);
end
Screen('Close');