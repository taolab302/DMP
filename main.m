clear;
Folder = 'G:\Backup\20191128\Intestine-3\';
name_elements = strsplit(Folder,'\');
wave_index = 1;

%% Folders and Parameters
% Worm_Thres = 140;  % for Cali method 1 & 2
Worm_Thres = 5;
Worm_Area = 12000;
frame_rate = 8;

midtime = load([Folder(1:end-1) '.txt']);
time_frame = midtime(wave_index,2);
close all

frame_seq = (midtime(wave_index,1)-time_frame+1):(midtime(wave_index,1)+time_frame);

waveFolder = [Folder(1:end-1) '-Wave\wave-' num2str(wave_index) '\'];
intestineFolder = [Folder(1:end-1) '-Wave\'];

%% Segmentation
prompt = 'Has segmentation completed? 0 = yes, other values = no: ';
seg_flag = input(prompt);
if seg_flag~=0
    Segmentation('test',Folder,frame_seq,Worm_Thres,Worm_Area,wave_index);
    prompt = 'Worm_Thres feasible? 0 = yes, or input another value to test: ';
    thres_flag = input(prompt);
    while thres_flag>0
        Segmentation('test',Folder,frame_seq,thres_flag,Worm_Area,wave_index);
        prompt = 'Worm_Thres feasible? 0 = yes, or input another value to test: ';
        Worm_Thres = thres_flag;
        thres_flag = input(prompt);
    end
    Segmentation(1,Folder,frame_seq,Worm_Thres,Worm_Area,wave_index);
%     Segmentation(1,Folder,frame_seq(18:end),Worm_Thres,Worm_Area,wave_index);
end

%% Correcting Segmentation
prompt = 'Have corrected worm segmentation? 0 = yes, other values = no: ';
continue_flag = input(prompt);
if continue_flag==0
   rmdir [waveFolder 'worm_region\];
   movefile [waveFolder 'temp\] [waveFolder 'worm_region\];
   ReformWormRegionTemp(waveFolder);
   UpdateRegionCheck(Folder,wave_index); 
end

%% Head position and calculate worm length and Calcium
prompt = 'What is the head position? ';
head_pos = input(prompt);
IntestineCenterline(waveFolder,frame_seq,head_pos);
DrawCenterline(waveFolder,frame_seq);
prompt = 'Reverse centelines? 0 = yes, other values = no: ';
reverse_flag = input(prompt);
if reverse_flag == 0
    prompt = 'Reverse seq = ?';
    reverse_seq = input(prompt);
    reverse_centerline([waveFolder 'centerline\'],frame_seq(reverse_seq));
end
I = WaveIntensity(Folder,waveFolder,frame_seq);
figure(128);imagesc(I);ylabel('Frame');colormap(jet);
saveas(gcf,[waveFolder 'waveIntensity.fig']);
save([waveFolder 'waveIntensity.mat'],'I');
L = CenterlineLength(Folder,wave_index);
% PlotLengthIntensity(waveFolder,wave_index,frame_rate,intestineFolder);

%% Intestine part of the centerline and Calcium
DrawWormSeg(Folder,wave_index);
prompt = 'What is the intestine range? ';
inte_range_wave = input(prompt);
if exist([Folder(1:19) 'inte_range.mat'],'file')
    load([Folder(1:19) 'inte_range.mat']);
end
inte_range(wave_index,:) = inte_range_wave;
save([Folder(1:19) char(name_elements(4))  ' inte_range.mat'],'inte_range');

TruncateCenterline([char(name_elements(3)),'-',char(name_elements(4))],wave_index);
update_plots(Folder,wave_index);








