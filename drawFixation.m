function drawFixation(window, rect, size, color, thickness)
% Draw a fixation cross

% Set start and end points of lines 
crossLines = [-size,0; size,0; 0, -size; 0, size];
crossLines = crossLines';

% find center of window
xCenter = rect(3)/2;
yCenter = rect (4)/2;

% Draw the lines original
Screen('DrawLines', window, crossLines, thickness, color, [xCenter, yCenter]);

end