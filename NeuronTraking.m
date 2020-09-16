clear;
Folder = 'G:\Backup\20191128\Intestine-3\';
wave_index = 1;
neuron_name = 'DVC';
int_pos = []; 

close all
frame_rate = 8;

imgs = dir([Folder,'*.tiff']);

waveFolder = [Folder(1:end-1) '-Wave\wave-' num2str(wave_index) '\'];
centerlineFolder = [waveFolder 'centerline\'];
    centerlines = dir([centerlineFolder '*.mat']);
    image_num = length(centerlines);
    time_frame = zeros(1,image_num);
    for i = 1:image_num
        time_frame(i) = str2num(centerlines(i).name(1:end-4));
    end
    time_frame = sort(time_frame);
    
    