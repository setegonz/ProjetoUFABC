%{
A ideia basica eh que colocar esse while inteiro como a tentativa.
O raciocinio eh ele estar sempre checando se o voluntario apertou, se tiver
apertado e soh tiverem passado segundos desde o inicio do experimento
eh mostrado o relogio de segundos, se mais de um minuto o relogio de minutos
e segundos. Se nao apertou eh mostrada soh a imagem da tentativa

stimulusStartTime = momento do primeiro flip do experimento. Pegar no come?o de
tudo com 'firstFlip = Screen('Flip', etc)'. Deixar fora dos loops de
blocos. stimulusStartTime

retroKey = variavel para guardar se o voluntario ja respondeu nesse bloco.
Deve ser reiniciada para 'false'ou 0 a cada bloco. Do jeito que esta o
voluntario so pode responder uma vez por bloco.
while true
    time = GetSecs;
    retroKey = KbCheck;

    if time - firstFlip < 60 && retroKey == true % display at? um minuto de experimento (apenas segundos)
        clockTime = time - firstFlip; %% Calcula o tempo decorrido em segundos
        nowClock = sprintf('0m%us', round(clockTime)); % Anota o tempo decorido como texto
        DrawFormattedText(window, nowClock, 'right', 'center',[0 0 0]); %% Desenha o texto a ser apresentado
        % COLOCAR AQUI LINHA DE DESENHO DA FIGURA DO BLOCO
        shownClock = Screen('Flip', window);
        % COLOCAR AQUI LINHA DE DESENHO DA FIGURA DO BLOCO
        for ii = 1:length(shuffledImageSampleIdx)
           % Draw the image so that it is centered
           Screen('DrawTexture', window, images(ii), [],...
               [(targetImageX) (targetImageY)...
               (targetImageX + s2) (targetImageY + s1)], 0);

           % Save the time the screen was flipped
           stimulusStartTime = Screen('Flip', window);

           [keyWasPressed, responseTime] = recordKeys(stimulusStartTime, 1);

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
        Screen('Flip',[], shownClock + clockDuration); %Flip para apagar o relogio
        break
    elseif time - firstFlip > 59 && retroKey == true %display de um minuto para frente (minutos e segundos)
        clockTime = time - firstFlip; % em segundos
        clockTimeMinutes = round(clockTime/60); %  minutos
        clockTimeSecs = round((clockTime/60 -clockTimeMinutes)*100); %segundos
        nowClock = sprintf('%um%us', clockTimeMinutes, clockTimeSecs);
        DrawFormattedText(window, nowClock, 'right', 'center',[0 0 0]);
        % COLOCAR AQUI LINHA DE DESENHO DA FIGURA DO BLOCO
        shownClock = Screen('Flip', window);
        for ii = 1:length(shuffledImageSampleIdx)
           % Draw the image so that it is centered
           Screen('DrawTexture', window, images(ii), [],...
               [(targetImageX) (targetImageY)...
               (targetImageX + s2) (targetImageY + s1)], 0);

           % Save the time the screen was flipped
           stimulusStartTime = Screen('Flip', window);

           [keyWasPressed, responseTime] = recordKeys(stimulusStartTime, 1);

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
        break

    else
        % Codigo da figura sozinha
        % Inserir um if com 'break' para encerrar a tentativa se o tempo
        % tiver passado
    end
end

%}
