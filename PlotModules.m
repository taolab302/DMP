%PlotModules: L, I, AVL, DVB
clear;
Folder = 'G:\Backup\20191129\Intestine-6\';
wave_index = 2;
name_element = strsplit(Folder,'\');
title_name = strcat(name_element(end-2),'-',name_element(end-1),' Wave ',num2str(wave_index));


waveFolder = [Folder(1:end-1) '-Wave\wave-' num2str(wave_index) '\'];
intestineFolder = [Folder(1:end-1) '-Wave\'];

load([waveFolder 'wormLength.mat'])  %load L
load([waveFolder 'waveIntensity'])  %load I
% load([waveFolder 'neuron\AVL.mat']); AVL = neuron_I;  %load AVL
% load([waveFolder 'neuron\DVB.mat']); DVB = neuron_I;  %load DVB

frame_num = length(L);
seg_num = length(I(1,:));
frame_rate = 8;
pixel_size = 6.5/4; % unit: um

% normalize I
sigma = 1;
gausFilter = fspecial('gaussian', [3,3], sigma);
I_gauss = imfilter(I, gausFilter, 'replicate');
I_normalize = zeros(frame_num,seg_num);
for i = 1:seg_num
    % temp = sort(I_gauss(:,i));
    % I_normalize(:,i) = (I_gauss(:,i)-mean(temp(1:25)))/(max(I_gauss(:,i))-mean(temp(1:75)));
    I_normalize(:,i) = (I_gauss(:,i)-min(I_gauss(:,i)))/range(I_gauss(:,i));
    
end

figure;

% ah1 = subplot(4,1,1);
% pos1 = get(ah1,'Position');
% yyaxis left;
% % plot((1:frame_num)/frame_rate,AVL,'c--');hold on;
% avl = plot((1:frame_num)/frame_rate,smooth(AVL,'loess',0.1),'b');ylabel('AVL');hold on;
% yyaxis right;
% % plot((1:frame_num)/frame_rate,DVB,'m--');hold on;
% dvb = plot((1:frame_num)/frame_rate,smooth(DVB,'loess',0.1),'r');ylabel('DVB');hold on;
% xlim([0 frame_num/frame_rate])
% xlabel('Time(s)');
% % legend([avl,dvb],'AVL','DVB')
% title(title_name)

subplot(4,1,2);
% subplot(3,1,1);
plot((1:frame_num)/frame_rate,L*pixel_size);hold on;
l = plot((1:frame_num)/8,smooth(L*pixel_size,0.1,'loess'),'k');
legend(l,'smoothed L')
xlim([0 frame_num/frame_rate])
xlabel('Time(s)');
ylabel('Length (um)')

ah3 = subplot(4,1,3);
pos3 = get(ah3,'Position');pos3(3) = pos1(3);
% subplot(3,1,2);
imagesc([0.5,frame_num-0.5]/frame_rate,[1/seg_num 1],I');colormap('jet');
xlabel('Time(s)');ylabel('Intestine Calcium');colorbar;set(ah3,'Position',pos3);
yticks([0.5/seg_num 1-0.5/seg_num]); yticklabels({'A','P'});

ah4 = subplot(4,1,4);
pos4 = get(ah4,'Position');pos4(3) = pos4(3);
% subplot(3,1,3);
imagesc([0.5,frame_num-0.5]/frame_rate,[1/seg_num 1],I_normalize');colormap('jet');
xlabel('Time(s)');ylabel('Intestine Calcium (Normalized)');colorbar;set(ah4,'Position',pos4);
yticks([0.5/seg_num 1-0.5/seg_num]); yticklabels({'A','P'});