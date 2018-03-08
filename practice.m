%% Instructions

intro = 'Bem-vindo ao experimento! \n Pressione espaço para continuar.';
Screen('TextFont', window, 'Avenir');
Screen('TextSize', window, 80);
DrawFormattedText(window, intro, 'center', 'center', 0, [], [], [], 1.5);
Screen('Flip', window);

KbWait;

instructions = 'Agora vamos praticar a primeira tarefa. \n Nessas rodadas, você verá uma cruz de fixação verde se \n você está correto e uma cruz vermelha de fixação se você estiver incorreto. \n Pressione espaço para começar.';
Screen('TextFont', window, 'Avenir');
Screen('TextSize', window, 80);
DrawFormattedText(window, instructions, 'center', 'center', 0, [], [], [], 1.5);
Screen('Flip', window);

[~, ~, ~] = KbWait([], 2);
 

intro = 'Vamos praticar a tarefa one-back.\n Pressione espaço para praticar.';
Screen('TextFont', window, 'Avenir');
Screen('TextSize', window, 80);
DrawFormattedText(window, intro, 'center', 'center', 0, [], [], [], 1.5);
Screen('Flip', window);

[~, ~, ~] = KbWait([], 2);
stim = 0;
one_back_mateusV
% stim = 1;
% one_back_practice
% stim = 2;
% one_back_practice 

intro = 'Agora vamos praticar a tarefa de duas costas.\n Pressione espaço para praticar.';
Screen('TextFont', window, 'Avenir');
Screen('TextSize', window, 80);
DrawFormattedText(window, intro, 'center', 'center', 0, [], [], [], 1.5);
Screen('Flip', window);

[~, ~, ~] = KbWait([], 2);

stim = 0;
% two_back_practice 
% stim = 1;
% two_back_practice
% stim = 2;
two_back


% Close all screens 
Screen('Close')
