% First check filenames to see if they contain one of the strings
% indicating race and gender. This will return {[]} if empty, therefore we
% must index into the cell to see whether it is actually empty or not.

check1 = (strfind(filenames(ii),'AF'));
check2 = (strfind(filenames(ii),'AM'));
check3 = (strfind(filenames(ii),'BF'));
check4 = (strfind(filenames(ii),'BM'));
check5 = (strfind(filenames(ii),'LF'));
check6 = (strfind(filenames(ii),'LM'));
check7 = (strfind(filenames(ii),'WF'));
check8 = (strfind(filenames(ii),'WM'));

if ~isempty(check1{1})
    % If the filename contains 'AF' fill in master cell accordingly.
    C(mi,7) = {'Asian'};
    C(mi,8) = {'Female'};
elseif ~isempty(check2{1})
    C(mi,7) = {'Asian'};
    C(mi,8) = {'Male'};
elseif ~isempty(check3{1})
    C(mi,7) = {'Black'};
    C(mi,8) = {'Female'};
elseif ~isempty(check4{1})
    C(mi,7) = {'Black'};
    C(mi,8) = {'Male'};
elseif ~isempty(check5{1})
    C(mi,7) = {'Latino'};
    C(mi,8) = {'Female'};
elseif ~isempty(check6{1})
    C(mi,7) = {'Latino'};
    C(mi,8) = {'Male'};
elseif ~isempty(check7{1})
    C(mi,7) = {'White'};
    C(mi,8) = {'Female'};
elseif ~isempty(check8{1})
    C(mi,7) = {'White'};
    C(mi,8) = {'Male'};
else
    C(mi, 7) = {0};
    C(mi, 8) = {0};
    
end 
    
    
    