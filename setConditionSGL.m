%%%%%%%% Sets order of conditions based on subject number %%%%%%%%%%
%%%%%%%%%%% 0 = Neutral, 1 = Positive, 3 = Negative %%%%%%%%%%%%%
%% Condition 1

if mod(sub_num,6) == 0

  stim = 0;
  %practice
  for ri = 1:nruns
    trial = ri + (2*nruns);
    one_back_mateusV
  end
  stim = 1;
  for ri = 1:nruns
    trial = ri + (3*nruns);
    one_back_mateusV
  end
  stim = 2;
  for ri = 1:nruns
    trial = ri + (4*nruns);
    one_back_mateusV
  end



%%% Condition 2
elseif mod(sub_num,5) == 0
    stim = 0;
    for ri = 1:nruns
      trial = ri;
      one_back_mateusV
    end
    stim = 1;
    for ri = 1:nruns
      trial = ri + nruns;
      one_back_mateusV
    end
    stim = 2;
    for ri = 1:nruns
      trial = ri + 2*nruns;
      one_back_mateusV
    end

%%% Condition 3
elseif mod(sub_num,4) == 0
  stim = 0;
  %practice
  for ri = 1:nruns
      trial = ri + (4*nruns);
      one_back_mateusV
  end
  stim = 1;
  for ri = 1:nruns
      trial = ri + (5*nruns);
      one_back_mateusV
  end
  stim = 2;
  for ri = 1:nruns
      trial = ri + (6*nruns);
      one_back_mateusV
  end

%%% Condition 4
elseif mod(sub_num,3) == 0
  stim = 2;
  for ri = 1:nruns
      trial = ri + (4*nruns);
      one_back_mateusV
  end
  stim = 1;
  for ri = 1:nruns
      trial = ri + (5*nruns);
      one_back_mateusV
  end
  stim = 0;
  for ri = 1:nruns
      trial = ri + (6*nruns);
      one_back_mateusV
  end

%% Condition 5
elseif mod(sub_num,2) == 0
  stim = 2;
  %practice
  for ri = 1:nruns
      trial = ri;
      one_back_mateusV
  end
  stim = 1;
  for ri = 1:nruns
      trial = ri + nruns;
      one_back_mateusV
  end
  stim = 0;
  for ri = 1:nruns
      trial = ri + 7*nruns;
      one_back_mateusV
  end

%%% Condition 6
else
  stim = 2;
  %practice
  for ri = 1:nruns
      trial = ri + (2*nruns);
      one_back_mateusV
  end
  stim = 1;
  for ri = 1:nruns
      trial = ri + (3*nruns);
      one_back_mateusV
  end
  stim = 0;
  for ri = 1:nruns
      trial = ri + (4*nruns);
      one_back_mateusV
  end
end
% Final screen & Exit
 finalScreen
