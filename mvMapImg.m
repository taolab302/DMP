clear;
Folder = 'G:\Backup\20191129\Intestine-14\';
wave_index = 16;

% close all
frame_rate = 8;

MapFolder = [Folder(1:end-1) '-Map\'];

map_imgs = dir([MapFolder,'*.tiff']);

waveFolder = [Folder(1:end-1) '-Wave\wave-' num2str(wave_index) '\'];
centerlineFolder = [waveFolder 'centerline\'];
WaveMapFolder = [waveFolder 'map_img\'];
if ~exist(WaveMapFolder,'dir')
    mkdir(WaveMapFolder);
end
    centerlines = dir([centerlineFolder '*.mat']);
    image_num = length(centerlines);
    time_frame = zeros(1,image_num);
    for i = 1:image_num
        time_frame(i) = str2num(centerlines(i).name(1:end-4));
    end
    time_frame = sort(time_frame);
if isempty(dir([WaveMapFolder '*.tiff']))
    for i = time_frame
        copyfile([MapFolder map_imgs(i).name],[WaveMapFolder num2str(i) '.tiff']);
        disp(['copy: ' num2str(i) '  ' num2str(i-time_frame(1)+1) '/' num2str(length(time_frame))]);
    end
end
