filename = 'F:\Tao\Defecation\DMP-Archive.xlsx';
row_num = 152;
Folder = 'G:\Backup\';
tic
[~,~,worm_info] = xlsread(filename,'sheet1',['a1:c' num2str(row_num)]);
worm_info(1,4) = {'frame_num'};
worm_info(1,5) = {'start_row'};
% toc

seg_num = 49;

centerline_num = 0;
centerlines = zeros(1,seg_num,2);

for i = 2:row_num
    worm_name = char(worm_info(i,1));
    wave_index = cell2mat(worm_info(i,2));
    disp([worm_name ' wave ' num2str(wave_index)]);
    wave_folder = [Folder ,worm_name(1:8),'\',worm_name(10:end),'-Wave\wave-',num2str(wave_index),'\'];
    centerlines = dir([wave_folder,'centerline\','*.mat']);
    frame_num = length(centerlines);
    worm_info(i,4) = num2cell(frame_num);
    worm_info(i,5) = num2cell(centerline_num+1);
    for j = 1:frame_num
        load([wave_folder 'centerline\' centerlines(j).name]);
        centerline_num = centerline_num+1;
        centerlines_all(centerline_num,:,:) =centerline;
    end

end

theta_array = ComputeTheta(centerlines_all); % theta = (frame_num*seg_num)
toc;