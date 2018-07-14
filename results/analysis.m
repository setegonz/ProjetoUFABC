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

% Read each file 
for ii = 1:length(file_list)
    
    %Set empty arrays to capture data
    RT0 = []; %Rt Neutral Valence
    RT1 = []; %Rt Positive Valence
    RT2 = []; %Rt Negative Valence
    RT00 = []; %Rt Control Neutral Valence
    RT01 = []; %Rt Control Positive Valence
    RT02 = []; %Rt Control Negative Valence
    Acc0 = 0; %Accuracy Neutral Valence
    Acc1 = 0; %Accuracy Positive Valence
    Acc2 = 0; %Accuracy Negative Valence
    Acc00 = 0; %Control Accuracy Neutral Valence
    Acc01 = 0; %Control Accuracy Positive Valence
    Acc02 = 0; %Contral Accuracy Negative Valence
    
    T = readtable(char(file_list(ii)));
    % Get accurate RTs for each condition
    for ti = 1:size(T,1) %
        if T.nBack(ti) == 1 && T.Valence(ti) == 0 && ...
                T.Accuracy(ti) == 1 && ~isnan(T.RT(ti)) && ...
                T.experiment(ti) == 1
            % Add RT to matrix (we will later take mean)
            RT0 = [RT0 T.RT(ti)];         
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 1 && ...
                T.Accuracy(ti) == 1 && ~isnan(T.RT(ti)) && ...
                T.experiment(ti) == 1
            % Add RT to matrix (we will later take mean)
            RT1 = [RT1 T.RT(ti)]; 
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 2 && ...
                T.Accuracy(ti) == 1 && ~isnan(T.RT(ti)) && ...
                T.experiment(ti) == 1
            % Add RT to matrix (we will later take mean)
            RT2 = [RT2 T.RT(ti)];
            
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 0 && ...
                T.Accuracy(ti) == 1 && ~isnan(T.RT(ti)) && ...
                T.experiment(ti) == 0
            % Add RT to matrix (we will later take mean)
            RT00 = [RT00 T.RT(ti)]; 
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 1 && ...
                T.Accuracy(ti) == 1 && ~isnan(T.RT(ti)) && ...
                T.experiment(ti) == 0
            % Add RT to matrix (we will later take mean)
            RT01 = [RT01 T.RT(ti)];
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 2 && ...
                T.Accuracy(ti) == 1 && ~isnan(T.RT(ti)) && ...
                T.experiment(ti) == 0
            % Add RT to matrix (we will later take mean)
            RT02 = [RT02 T.RT(ti)];
        end
        
        % Now check accuracy
        if T.nBack(ti) == 1 && T.Valence(ti) == 0 && ...
                T.Accuracy(ti) == 1 && T.experiment(ti) == 1
            Acc0 = (Acc0 + 1);
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 1 && ...
                T.Accuracy(ti) == 1 && T.experiment(ti) == 1
            Acc1 = (Acc1 + 1);
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 2 && ...
                T.Accuracy(ti) == 1 && T.experiment(ti) == 1
            Acc2 = (Acc2 + 1);
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 0 && ...
                T.Accuracy(ti) == 1 && T.experiment(ti) == 0
            Acc00 = (Acc00 + 1);
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 1 && ...
                T.Accuracy(ti) == 1 && T.experiment(ti) == 0
            Acc01 = (Acc01 + 1);
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 2 && ...
                T.Accuracy(ti) == 1 && T.experiment(ti) == 0
            Acc02 = (Acc02 + 1);
        end
    end
    
    % Round data to 3 decimals and put in cell
    C(ii,1) = {round(mean(RT0),3)};
    C(ii,2) = {round(std(RT0),3)};
    C(ii,3) = {round(mean(RT1),3)};
    C(ii,4) = {round(std(RT1),3)};
    C(ii,5) = {round(mean(RT2),3)};
    C(ii,6) = {round(std(RT2),3)};
    C(ii,7) = {round(mean(RT00),3)};
    C(ii,8) = {round(std(RT00),3)};
    C(ii,9) = {round(mean(RT01),3)};
    C(ii,10) = {round(std(RT01),3)};
    C(ii,11) = {round(mean(RT02),3)};
    C(ii,12) = {round(std(RT02),3)};
    C(ii,13) = {round(Acc0)./sum(T.experiment == 1)}; %need to fix Acc divided by the lengh of Acc0lengh =%
    C(ii,14) = {round(Acc1)./sum(T.experiment == 1)};
    C(ii,15) = {round(Acc2)./sum(T.experiment == 1)};
    C(ii,16) = {round(Acc00)./sum(T.experiment == 0)}; %need to fix Acc divided by the lengh of Acc00lengh =%
    C(ii,17) = {round(Acc01)./sum(T.experiment == 0)};
    C(ii,18) = {round(Acc02)./sum(T.experiment == 0)};
end

%% Clock checks

% Total of clock checks

%Clock checks by trail. Trial= start of experiment to dataOneMinPress. And then oneminutepress
%to the next one minute press.

% # clock checks before 30s of each trial

% # clock checks after 30s of each trial





%% Put data into a table.
T = cell2table(C, 'VariableNames', {'RT0', 'SD0', 'RT1', 'SD1', 'RT2', 'SD2', 'RT00', 'SD00', 'RT01', 'SD01', 'RT02', 'SD02',...
    'Acc0', 'Acc1','Acc2', 'Acc00', 'Acc01', 'Acc02'});
    
% Name file using sub_num & write table 
file_name = 'output.txt';

% Move back to analysis folder and write table
cd ../results
writetable(T, file_name) 