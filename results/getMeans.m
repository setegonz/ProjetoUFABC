% Read in file  
T = readtable('output.txt','Delimiter', ',', 'Format', '%.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f');

% Create an empty cell and put mean values in it
C = cell(1,12);
C(1) = {round(mean(T.RT00),3)};
C(2) = {round(mean(T.RT01),3)};
C(3) = {round(mean(T.RT10),3)};
C(4) = {round(mean(T.RT11),3)};
C(5) = {round(mean(T.RT20),3)};
C(6) = {round(mean(T.RT21),3)};
C(7) = {round(mean(T.Acc00),3)};
C(8) = {round(mean(T.Acc01),3)};
C(9) = {round(mean(T.Acc10),3)};
C(10) = {round(mean(T.Acc11),3)};
C(11) = {round(mean(T.Acc20),3)};
C(12) = {round(mean(T.Acc21),3)};

% Put data into a table.
T2 = cell2table(C, 'VariableNames', {'RT00', 'RT01', 'RT10', 'RT11', 'RT20'...
    'RT21', 'Acc00', 'Acc01', 'Acc10', 'Acc11', 'Acc20', 'Acc21'});

% Get values for intact to plot

intactRT = [T2.RT00(1) T2.RT10(1) T2.RT20(1)];
degradedRT = [T2.RT01(1) T2.RT11(1) T2.RT21(1)];

%Get acc values to plot

intactAcc = [T2.Acc00(1) T2.Acc10(1) T2.Acc20(1)];
degradedAcc = [T2.Acc01(1) T2.Acc11(1) T2.RT21(1)];