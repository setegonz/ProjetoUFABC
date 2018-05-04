%% Análisis 

piloto1 = readtable('piloto1.txt'); %load data
piloto1 = readtable( 'piloto1.txt', opts);
T = readtable('piloto1.txt','Delimiter', ',', 'Format', '%d %d %d %s %f %f %f %f %d %f %f %f %f %f');


RTs = piloto1(:,{'Trial','RT'});

piloto1.RT
plot(piloto1.Trial(:,:),piloto1.RT(:,:));
histogram(~isnan(piloto1.RT));
bar(piloto1.RT);
bar(control.RT);

%%
control = piloto1(1:170,:); %control task
% controltrial = control(:,1);
controltrial = 
% controlrt = (isnan(control(:,8)) = [];
% controlrt = (~isnan(control(:,8));
%%
TBPM = piloto1(171:end,:); %TBPM


% %% correct responses
% correctoneback = control{:,9}==1;
% 
% %% incorret responses
% incorrectoneback = control{:,9}==0;


%number of clock checks

%moment of clock checks

%number o clock checks util clock reset


%% avg rt
avgrt = nanmean(piloto1{:,8});
%Rt's standar deviation
sdRT = nanstd(piloto1{:,8});

mediancontrolrt = nanmedian(control{:,8});


%%control RT
avgcontrolrt = nanmean(control{:,8});
sdcontrolRT = nanstd(control{:,8});
controlrts = ~isnan(control{:,8});
medianTBPMrt = nanmedian(TBPM{:,8});

%% TBPM RT
avgTBPMrt = nanmean(TBPM{:,8});
sdTBPMrt = nanstd(TBPM{:,8});
TBPMrt = ~isnan(TBPM{:,8});


%% avg image presentation time



%% plot

A = table2array(control(:,8));
B = table2array(TBPM(:,8));
hist(A)
hold on
hist(B)

figure(2)
bar(TBPM.RT)
boxplot(TBPM.RT)
figure(1)
boxplot(control.RT)



cohens(D);

G(power); %software
















