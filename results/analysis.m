% Change to data directory 
cd ../data

% Look for text files in directory and store names in a cell
s = dir('*.txt');
file_list = {s.name};

% Preallocate for number of subjects. There are values for RT and accuracy
% for the 6 conditions. 
% C = cell(length(file_list),12);
C = cell(length(file_list),1);


% Can be changed based on number of runs
nruns = 1;

% Read each file 
for ii = 1:length(file_list)
    
    %Set empty arrays to capture data 
    RT0 = [];
    RT1 = [];
    RT2 = [];
    Acc0 = 0;
    Acc1 = 0;
    Acc2 = 0;
    
%     T = readtable(char(file_list(ii)),'Delimiter', ',', 'Format', '%d %d %d %s %f %f %f %f %d %f %f %f %f %f');
    T = readtable(char(file_list(ii)));
    % Get accurate RTs for each condition
    for ti = 1:size(T,1) %
        if T.nBack(ti) == 1 && T.Valence(ti) == 0 && ...
            T.Accuracy(ti) == 1 && ~isnan(T.RT(ti))
        % Add RT to matrix (we will later take mean)
        RT0 = [RT0 T.RT(ti)];
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 1 && ...
            T.Accuracy(ti) == 1 && ~isnan(T.RT(ti))
        % Add RT to matrix (we will later take mean)
        RT1 = [RT1 T.RT(ti)];
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 2 && ...
            T.Accuracy(ti) == 1 && ~isnan(T.RT(ti))
        % Add RT to matrix (we will later take mean)
        RT2 = [RT2 T.RT(ti)];
        end 
        
        % Now check accuracy
        if T.nBack(ti) == 1 && T.Valence(ti) == 0 && ...
            T.Accuracy(ti) == 1
        Acc0 = Acc0 + 1;
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 1 && ...
            T.Accuracy(ti) == 1 
        Acc1 = Acc1 + 1;
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 2 && ...
            T.Accuracy(ti) == 1 
        Acc2 = Acc2 + 1;
        end 
        
        % Round data to 3 decimals and put in cell
        C(ii,1) = {round(mean(RT0),3)};
        C(ii,2) = {round(mean(RT1),3)};
        C(ii,3) = {round(mean(RT2),3)};
%         C(ii,4) = {round(mean(RT11),3)};
%         C(ii,5) = {round(mean(RT20),3)};
%         C(ii,6) = {round(mean(RT21),3)};
        C(ii,4) = {round(Acc0/(nruns*10),3)};
        C(ii,5) = {round(Acc1/(nruns*10),3)};
        C(ii,6) = {round(Acc2/(nruns*10),3)};
%         C(ii,10) = {round(Acc11/(nruns*10),3)};
%         C(ii,11) = {round(Acc20/(nruns*10),3)};
%         C(ii,12) = {round(Acc21/(nruns*10),3)};
    end 
end 
    
    % Put data into a table.

T = cell2table(C, 'VariableNames', {'RT0', 'RT1', 'RT2', 'Acc0', 'Acc1'...
    'Acc2'}); % 'Acc00', 'Acc01', 'Acc10', 'Acc11', 'Acc20', 'Acc21'});
    
% Name file using sub_num & write table 
file_name = 'output.txt';

% Move back to analysis folder and write table
cd ../results
writetable(T, file_name) 