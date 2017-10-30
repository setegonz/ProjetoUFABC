function [keyWasPressed, responseTime] = recordKeys(startTime, duration)
% Return if a key was pressed and the fastest response time.

keyWasPressed = 'false';
responseTime = NaN;
start = GetSecs;

% Wait until all keys are released, breaking if the stimulus disappears.
while KbCheck
    if GetSecs - startTime > duration
        break
    end
end

% Check for pressed keys while the stimulus is still displaying.
while GetSecs <= startTime + duration
    [keyIsDown, ~, ~] = KbCheck;
    
    if keyIsDown
        keyWasPressed = 'true';
        responseTime = [responseTime GetSecs-start];
        while KbCheck
            % Wait until all keys are released.
            if GetSecs - startTime > duration
                break
            end
        end
    end
end

responseTime = min(responseTime);

end