%Noise mean
% Change to data directory
cd ../data

% Look for text files in directory and store names in a cell
s = dir('*.txt');
file_list = {s.name};

% Preallocate for number of subjects. There are values for RT and accuracy
% for the 6 conditions.
% C = cell(length(file_list),12);
C = cell(length(file_list),1);



% Read each file
for ii = 1:length(file_list)
    
    %Set empty arrays to capture data
    NT0 = []; %NT Neutral Valence
    NT1 = []; %NT Positive Valence
    NT2 = []; %NT Negative Valence
    NT00 = []; %NT Control Neutral Valence
    NT01 = []; %NT Control Positive Valence
    NT02 = []; %NT Control Negative Valence
    
    T = readtable(char(file_list(ii)));
    % Get Noise time for each trial
    for ti = 1:size(T,1) %
        if T.nBack(ti) == 1 && T.Valence(ti) == 0 && ...
                T.experiment(ti) == 1
            % Add NT to matrix (we will later take mean)
            NT0 = [T.x(ti) - T.NoisePresentationTime(ti)];
            
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 1 && ...
                T.experiment(ti) == 1
            NT1 = [T.x(ti) - T.NoisePresentationTime(ti)];
            
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 2 && ...
                T.experiment(ti) == 1
            NT2 = [T.x(ti) - T.NoisePresentationTime(ti)];
            
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 0 && ...
                T.experiment(ti) == 0
            NT00 = [T.x(ti) - T.NoisePresentationTime(ti)];
            
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 1 && ...
                T.experiment(ti) == 0
            NT01 = [T.x(ti) - T.NoisePresentationTime(ti)];
            
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 2 && ...
                T.experiment(ti) == 0
            NT02 = [T.x(ti) - T.NoisePresentationTime(ti)];
        end
    end
       
    C(ii,1) = {round(mean(NT0),3)};
    C(ii,2) = {round(std(NT0),3)};
    C(ii,3) = {round(mean(NT1),3)};
    C(ii,4) = {round(std(NT1),3)};
    C(ii,5) = {round(mean(NT2),3)};
    C(ii,6) = {round(std(NT2),3)};
    C(ii,7) = {round(mean(NT00),3)};
    C(ii,8) = {round(std(NT00),3)};
    C(ii,9) = {round(mean(NT01),3)};
    C(ii,10) = {round(std(NT01),3)};
    C(ii,11) = {round(mean(NT02),3)};
    C(ii,12) = {round(std(NT02),3)};
    
end

T = cell2table(C, 'VariableNames', {'NT0', 'SD0', 'NT1', 'SD1', 'NT2', 'SD2', 'NT00', 'SD00', 'NT01', 'SD01', 'NT02', 'SD02'});
    
% Name file using sub_num & write table 
file_name = 'NToutput.txt';

% Move back to analysis folder and write table
cd ../results
writetable(T, file_name) 