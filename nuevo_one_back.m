%% General set-up
neutralSourceImages = dir(fullfile(pwd,'stimuli','neutral','*.jpg'));    %Neutral
positiveSourceImages = dir(fullfile(pwd,'stimuli','positive','*.jpg')); %Positive
negativeSourceImages = dir(fullfile(pwd,'stimuli','negative','*.jpg')); %Negative

% Get names of task source images depending on stim type
if stim == 0
   sourceImages = dir(fullfile(pwd,'stimuli','neutral','*.jpg'));
elseif stim == 1
   sourceImages = dir(fullfile(pwd,'stimuli', 'positive','*.jpg'));
else stim == 2
  sourceImages = dir(fullfile(pwd,'stimuli', 'negative','*.jpg'));
end;
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
else stim == 2
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
[screenXpixels, screenYpixels] = Screen('WindowSize', window); %screenXpixels=1280 %screenYpixels=800
% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(rect);



% Calculate size and x-coordinate of target image. Used to position
% stimuli.
[s1, s2, s3] = size(targetImage); % target image matrix size 768x1024x3
targetImageX = (screenXpixels - s2)/ 2; %1280-1024=    targetImageX=256
targetImageY = (screenYpixels - s1)/ 2; %800-768=32    targetImageY=32

%%%



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
instructions = 'Pressione a barra espaciadora quando v? uma repeti??o de imagem duas vezes seguidas.\n Pressione espa?o para come?ar.\n';
Screen('TextFont', window, 'Avenir');
Screen('TextSize', window, 80);
DrawFormattedText(window, instructions, 'center','center', 0, [], [], [], 1.5);
Screen('Flip', window);

% Wait until user presses a key
[~, ~, ~] = KbWait([], 2);

%Dibujar rectangulo
baseRect = [0 0 600 600];

% Center the rectangle on the centre of the screen using fractional pixel
% values.
% For help see: CenterRectOnPointd
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);

% Draw fixation cross
drawFixation(window, rect, 40, black, 4);
Screen('Flip', window);
WaitSecs(1);

fprintf('pressed,time,correct\n');
% Display each image followed by fixation cross
% colocar tic. chamar toc
for ii = 1:length(shuffledImageSampleIdx)
% Make a base Rect of 60 by 60 pixels.
    baseRect = [0 0 600 600];
% Center the rectangle on the centre of the screen using fractional pixel
% values.
    centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);
    [keyIsDown,secs, keyCode] = KbCheck;
    leftKey = KbName('LeftArrow');
%RestrictKeysForKbCheck([space, leftKey]);
    tStart = tic;
    tElapsed = toc(tStart);
%   tElapsed = KbCheck
% Draw the image so that it is centered
    Screen('DrawTexture', window, images(ii), [], [centeredRect], 0);
    if keyIsDown 
        if keyCode(leftKey)
            DrawFormattedText(baseRect,'tElapsed','center', 'center', []);
        end
    end
%   Screen('DrawTexture', window, images(ii), [],...
%       [(targetImageX) (targetImageY)...
%       (targetImageX + s2) (targetImageY + s1)], 0);
% [top-left-x top-left-y bottom-right-x bottom-right-y]

   % Save the time the screen was flipped
   stimulusStartTime = Screen('Flip', window);


   [keyWasPressed, responseTime] = recordKeys(stimulusStartTime, randi([1, 5]));

   if ii ~= 1
       % Avoid negative indexing
       if shuffledImageSampleIdx(ii) == shuffledImageSampleIdx(ii - 1)
           wasTarget = 'true';
       else
           wasTarget = 'false';
       end
   else
       wasTarget = 'false';
   end

   %fprintf('%s,%0.4f,%s\n', keyWasPressed, responseTime, wasTarget);

  % Fill in data matrix accordingly
   C(mi,1) = {trial}; %trial number
   C(mi,2) = {1};     %task (0,1,2)
   C(mi,3) = {stim};  %Valence
   C(mi,4) = filenames(ii);
   C(mi,5) = {responseTime};
   if strcmp(keyWasPressed,wasTarget) %accuracy
       C(mi,6) = {1};
   else
       C(mi,6) = {0};
   end
   %raceGender;
   mi = mi + 1;

   drawFixation(window, rect, 40, black, 4);
   Screen('Flip', window);
   WaitSecs(1);
end

Screen('Close');
