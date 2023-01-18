function [nam2, r] = get_files(nameF)
% read files from folder (input)
% Detect the r_0 files from xxxxr##_xxxx.mat
% output names an r_0
%name = 'DE0_test_ph0.2';
nFold =dir(nameF);
names = [];
for idx = 1:length(nFold)-2
srt = strfind(nFold(idx+2).name,'_r');
nd = strfind(nFold(idx+2).name(srt+2:end),'_');
r(idx) = str2num(nFold(idx+2).name(srt+2:srt+nd(1)));
text = [ nameF '/' nFold(idx+2).name ];
names = [names; {text}]; 
end
[r index] = sort(r);
nam2 = [];
for idx = 1:length(r);
    nam2 = [nam2; {names{index(idx)}}];
end
return


