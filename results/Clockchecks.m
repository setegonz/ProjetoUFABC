cd ../data

% Look for text files in directory and store names in a cell
s = dir('*.txt');
file_list = {s.name};

% Preallocate for number of subjects. There are values for RT and accuracy
% for the 6 conditions.
% C = cell(length(file_list),12);
C = cell(length(file_list),1);
for ii = 1:length(file_list)
    
    %Set empty arrays to capture data
    CK0 = []; %CK Neutral Valence
    CK1 = []; %CK Positive Valence
    CK2 = []; %CK Negative Valence
    CK00 = []; %CK Control Neutral Valence
    CK01 = []; %CK Control Positive Valence
    CK02 = []; %CK Control Negative Valence
    
    T = readtable(char(file_list(ii)));
    
    sum(~isnan(TBPM.dataOneMinPress_1))
    
    
    for ti = 1:size(T,1) %
        
        if T.nBack(ti) == 1 && T.Valence(ti) == 0 && ...
                T.experiment(ti) == 1
            % Add RT to matrix (we will later take mean)
            CK0 = sum(~isnan(T.dataOneMinPress_1(ti)));
            
            
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 1 && ...
                T.experiment(ti) == 1
            % Add RT to matrix (we will later take mean)
            CK1 = sum(~isnan(T.dataOneMinPress_1(ti)));
            
            
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 2 && ...
                T.experiment(ti) == 1
            % Add RT to matrix (we will later take mean)
            CK2 = sum(~isnan(T.dataOneMinPress_1(ti)));
            
            
            
            
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 0 && ...
                T.experiment(ti) == 0
            % Add RT to matrix (we will later take mean)
            CK00 = sum(~isnan(T.dataOneMinPress_1(ti)));
            
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 1 && ...
                T.experiment(ti) == 0
            % Add RT to matrix (we will later take mean)
            CK01 = sum(~isnan(T.dataOneMinPress_1(ti)));
            
        elseif T.nBack(ti) == 1 && T.Valence(ti) == 2 && ...
                T.experiment(ti) == 0
            % Add RT to matrix (we will later take mean)
            CK02 = sum(~isnan(T.dataOneMinPress_1(ti)));
        end
    end
    
    C(ii,1) = {CK0};
    C(ii,2) = {CK00};
    C(ii,3) = {CK1};
    C(ii,4) = {CK01};
    C(ii,5) = {CK2};
    C(ii,6) = {CK02};
    
    T = cell2table(C, 'VariableNames', {'CK0', 'CK00', 'CK1', 'CK01', 'CK2', 'CK02'});
end

file_name = 'ClockChecks.txt';
cd ../results
writetable(T, file_name) 
        