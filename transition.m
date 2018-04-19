

instructions = 'Voce teminou esta tarefa.\n Por favor, notifique o experimentador.\n';
Screen('TextFont', window, 'Avenir');
Screen('TextSize', window, 35);
DrawFormattedText(window, instructions, 'center', 'center', 0, [], [], [], 1.5);
Screen('Flip', window);

[~, ~, ~] = KbWait([], 2);

ready = 'Pronto para continuar?? \n pressione a barra de espaco. \n';
Screen('TextFont', window, 'Avenir');
Screen('TextSize', window, 35);
DrawFormattedText(window, ready, 'center', 'center', 0, [], [], [], 1.5);
Screen('Flip', window);

[~, ~, ~] = KbWait([], 2);
