function isi=setISI(n)

D = .5:.1:3;

for i=1:n
isi(i) = datasample(D,1);
end

% figure
% Y = histc(isi,D);
% plot(D,Y)
% mean(isi)

% C = 5;
% ((1/C)*(1/C)*10)
end