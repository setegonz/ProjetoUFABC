% Sets order of conditions based on subject number

%% Condition 1

if mod(sub_num,6) == 0
    %Move on to next task
    stim = 0;
    one_back_practice
    for ri = 1:nruns
        trial = ri;
        one_back
    end
    stim = 1;
    for ri = 1:nruns
        trial = ri + nruns;
        one_back
    end
    stim = 2;
    for ri = 1:nruns
        trial = ri + (2*nruns);
        one_back
    end


    %Transition once more
    transition

    % Final task
    stim = 0;
    two_back_practice
    for ri = 1:nruns
        trial = ri + (3*nruns);
        two_back
    end
    stim = 1;
    for ri = 1:nruns
        trial = ri + (4*nruns);
        two_back
    end
    stim = 2;
    for ri = 1:nruns
        trial = ri + (5*nruns);
        two_back
    end


%% Condition two
elseif mod(sub_num,5) == 0
    stim = 0;
    one_back_practice
    for ri = 1:nruns
        trial = ri;
        one_back
    end
    stim = 1;
    for ri = 1:nruns
        trial = ri + nruns;
        one_back
    end
    stim = 2;
    for ri = 1:nruns
        trial = ri + 2*nruns;
        one_back
    end

    %Transition screens to notify experimenter
    transition

    %Move on to next task
    stim = 0;
    two_back_practice
    for ri = 1:nruns
        trial = ri + (3*nruns);
        two_back
    end
    stim = 1;
    for ri = 1:nruns
        trial = ri + (4*nruns);
        two_back
    end
    stim = 2;
    for ri = 1:nruns
        trial = ri + (5*nruns);
        two_back
    end

    %Transition once more
    transition



 %% Condition 3
elseif mod(sub_num,4) == 0
    stim = 0; %0 = intact, 1 = degraded
    two_back_practice
    for ri = 1:nruns
        trial = ri;
        two_back
    end
    stim = 1;
    for ri = 1:nruns
        trial = ri + nruns;
        two_back
    end
    stim = 2;
    for ri = 1:nruns
        trial = ri + 2*nruns;
        two_back
    end

    %Transition once more
    transition

    % Final task
    stim = 0;
    one_back_practice
    for ri = 1:nruns
        trial = ri + (3*nruns);
        one_back
    end
    stim = 1;
    for ri = 1:nruns
        trial = ri + (4*nruns);
        one_back
    end
    stim = 2;
    for ri = 1:nruns
        trial = ri + (5*nruns);
        one_back
    end


    %% Condition 4

elseif mod(sub_num,3) == 0

    %Move on to next task
    stim = 1;
    two_back_practice
    for ri = 1:nruns
        trial = ri;
        two_back
    end
    stim = 0;
    for ri = 1:nruns
        trial = ri + nruns;
        two_back
    end
    stim = 2;
    for ri = 1:nruns
        trial = ri + nruns;
        two_back
    end


    %Transition once more
    transition

    % Final task
    stim = 1;
    one_back_practice
    for ri = 1:nruns
        trial = ri + (4*nruns);
        one_back
    end
    stim = 0;
    for ri = 1:nruns
        trial = ri + (5*nruns);
        one_back
    end

%% Condition 5
elseif mod(sub_num,2) == 0
    stim = 1;
    one_back_practice
    for ri = 1:nruns
        trial = ri;
        one_back
    end
    stim = 0;
    for ri = 1:nruns
        trial = ri + nruns;
        one_back
    end


    %Transition once more
    transition

    % Final task
    stim = 1;
    two_back_practice
    for ri = 1:nruns
        trial = ri + (4*nruns);
        two_back
    end
    stim = 0;
    for ri = 1:nruns
        trial = ri + (5*nruns);
        two_back
    end

%% Condition 6
else
    stim = 1;
    two_back_practice
    for ri = 1:nruns
        trial = ri;
        two_back
    end
    stim = 0;
    for ri = 1:nruns
        trial = ri + nruns;
        two_back
    end

    %Transition screens to notify experimenter
    transition

    %Move on to next task
    stim = 1;
    one_back_practice
    for ri = 1:nruns
        trial = ri + (2*nruns);
        one_back
    end
    stim = 0;
    for ri = 1:nruns
        trial = ri + (3*nruns);
        one_back
    end

    %Transition once more
    transition

    % Final task
    stim = 1;
    zero_back_practice
    for ri = 1:nruns
        trial = ri + (4*nruns);
        zero_back
    end
    stim = 0;
    for ri = 1:nruns
        trial = ri + (5*nruns);
        zero_back
    end
end
 % Final screen & Exit
 finalScreen
