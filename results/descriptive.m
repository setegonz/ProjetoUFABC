%% Análisis 

piloto1neutral = readtable('piloto1control.txt'); %load data
piloto1 = readtable( 'piloto1.txt', opts);
T = readtable('sub_AndreaNeutro','Delimiter', ',', 'Format', '%d %d %d %s %f %f %f %f %d %f %f %f %f %f');
S = readtable('sub_AndreaNeg','Delimiter', ',', 'Format', '%d %d %d %s %f %f %f %f %d %f %f %f %f %f');

RTs = piloto1(:,{'Trial','RT'});

piloto1.RT
plot(piloto1.Trial(:,:),piloto1.RT(:,:));
histogram(~isnan(piloto1.RT));
bar(piloto1.RT);
bar(control.RT);
D= sum(~isnan(S.dataOneMinPress_1)); %number of dataOneMinPress presses
%%
control = piloto1(1:170,:); %control task
% controltrial = control(:,1);
%controltrial = 
% controlrt = (isnan(control(:,8)) = [];
% controlrt = (~isnan(control(:,8));
%%
TBPM = piloto1(171:end,:); %TBPM
M = sum(~isnan(TBPM.dataOneMinPress_1)); %number of non nans
Z = nnz(piloto1.Accuracy); %number of non zeros


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

bar(T.RT0,'b')
hold on;
bar(T.RT1,'g');
hold on;
bar(T.RT2,'r')

somenames={'control'; 'sujeito 1'; 'sujeito 2'; 'sujeito 3'};

set(gca,'xticklabel',somenames);



control = (161/170)*100;
sujeito1 = (791/836)*100;
sujeito2 = (751/815)*100;
sujeito3 = (769/828)*100;
sujeitos = [control sujeito1 sujeito2 sujeito3];
bar(sujeitos)
somenames={'control'; 'sujeito 1'; 'sujeito 2'; 'sujeito 3'};

set(gca,'xticklabel',somenames);


bar(control,'b')
hold on;
bar(sujeito1,'b');
hold on;
bar(sujeito2,'r');
hold on;
bar(sujeito3, 'b');

somenames={'control'; 'sujeito 1'; 'sujeito 2'; 'sujeito 3'};

set(gca,'xticklabel',somenames);



















