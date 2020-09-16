% clear;
 clearvars -except wave_index
Folder = 'F:\Tao\Defecation\Backup\20191127\Intestine-1\';
Worm_name = '20191127-F1-wave ';
 wave_index = 2;

waveFolder = [Folder(1:end-1) '-Wave\wave-' num2str(wave_index) '\'];
intestineFolder = [Folder(1:end-1) '-Wave\'];
outFolder = ['F:\Tao\Defecation\Analysis\Normalized I\' Worm_name(1:end-6) ' waves\'];

if ~exist(outFolder,'dir')
    mkdir(outFolder);
end

load([waveFolder 'waveIntensity.mat']);
load([waveFolder 'wormLength.mat']);

%s_sample = [5 15 25 35 45];

frame_rate = 8;

sigma = 1;
gausFilter = fspecial('gaussian', [3,3], sigma);
I = imfilter(I, gausFilter, 'replicate');

seg_num = length(I(1,:));
frame_num = length(I(:,1));
I_loess = zeros(frame_num,seg_num);
I_normalize = zeros(frame_num,seg_num);

for i = 1:seg_num
    I_loess(:,i) = smooth(I(:,i),0.1,'loess');
    I_normalize(:,i) = (I_loess(:,i)-min(I_loess(:,i)))/range(I_loess(:,i));
    %I_normalize(:,i) = smooth(I_normalize(:,i),0.1,'loess');
end

figure(1);
imagesc([0.5,frame_num-0.5]/frame_rate,[0 1],I_normalize');colorbar;
yticks([0 1]); yticklabels({'Head','Tail'});
title([Worm_name num2str(wave_index) '  Intensity (Normalized)'])
xlabel('Time(s)');
saveas(gca,[outFolder Worm_name num2str(wave_index) '.fig'])
fig = figure(1);
print(fig,[outFolder,Worm_name num2str(wave_index)], '-djpeg','-r300');
save([outFolder,Worm_name num2str(wave_index) '.mat'],'I_normalize','I_loess','I');