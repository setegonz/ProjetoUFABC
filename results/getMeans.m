% Read in file  
T = readtable('output.txt','Delimiter', ',');

% Create an empty cell and put mean values in it
C = cell(1,6);
C(1) = {round(mean(T.RT0),3)};
C(2) = {round(mean(T.RT1),3)};
C(3) = {round(mean(T.RT2),3)};
C(4) = {round(mean(T.Acc0),3)};
C(5) = {round(mean(T.Acc1),3)};
C(6) = {round(mean(T.Acc2),3)};

% Put data into a table.
T2 = cell2table(C, 'VariableNames', {'RT00', 'RT01', 'RT2', ...
    'Acc0', 'Acc1', 'Acc2'});

% Get values for intact to plot

NeutralRT = [T2.RT0(1)];
PositiveRT = [T2.RT1(1)];
NegativeRT =  [T2.RT2(1)];

%Get acc values to plot

NeutralAcc = [T2.Acc0(1)];
PositiveAcc = [T2.Acc1(1)];
NegativeAcc = [T2.Acc2(1)];