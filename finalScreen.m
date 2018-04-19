congrats = 'Parabens! \n Voce terminou o experimento.';
Screen('TextFont', window, 'Avenir');
Screen('TextSize', window, 35);
DrawFormattedText(window, congrats, 'center', 'center', 0);
Screen('Flip', window);

KbWait;

sca;