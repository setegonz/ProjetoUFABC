% Sets order of conditions based on subject number

%% Condition 1

if condition_exp == 0

    
    transition
    
    instructions = 'Voce esta pronta(o) para o experimento real? \n Pressione a barra espaçadora.\n ';
    Screen('TextFont', window, 'Avenir');
    Screen('TextSize', window, 35);
    DrawFormattedText(window, instructions, 'center', 'center', 0, [], [], [], 1.5);
    Screen('Flip', window);
    
    [~, ~, ~] = KbWait([], 2);
    
    stim = 0
    experiment = 0
    control
    
    transition
    
    stim = 0
    experiment = 1
    one_back_mateusV
    
    

%% Condition two
elseif condition_exp == 1
    
    
    transition
    
    
    instructions = 'Voce esta pronta(o) para o experimento real? \n Pressione a barra espaçadora.\n ';
    Screen('TextFont', window, 'Avenir');
    Screen('TextSize', window, 35);
    DrawFormattedText(window, instructions, 'center', 'center', 0, [], [], [], 1.5);
    Screen('Flip', window);
    
    [~, ~, ~] = KbWait([], 2);
    
    
    stim = 1
    experiment = 0
    control
    
    transition
    
    stim = 1
    experiment = 1
    one_back_mateusV


 %% Condition 3
elseif condition_exp == 2
    
    transition
    
    
    instructions = 'Voce esta pronta(o) para o experimento real? \n Pressione a barra espaçadora.\n';
    Screen('TextFont', window, 'Avenir');
    Screen('TextSize', window, 35);
    DrawFormattedText(window, instructions, 'center', 'center', 0, [], [], [], 1.5);
    Screen('Flip', window);
    
    [~, ~, ~] = KbWait([], 2);
    
    stim = 2
    experiment = 0
    control
    
    transition
    
    stim = 2
    experiment = 1
    one_back_mateusV
end
 % Final screen & Exit
 finalScreen
