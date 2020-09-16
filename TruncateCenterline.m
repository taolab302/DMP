function TruncateCenterline(worm_name,wave_index)
    config;
%     eg: worm_name = '20191127-Intestine-8';
%         wave_index = [1 3 4];

    %load inte_range
    load(['G:\Backup\' worm_name(1:8) '\' worm_name(10:end) ' inte_range.mat']);
    for i = wave_index
        disp([worm_name ': wave ' num2str(i)]);
        wave_folder = ['G:\Backup\' worm_name(1:8) '\' worm_name(10:end) '-Wave\wave-' num2str(i) '\'];
        centerline_folder = [wave_folder 'centerline\'];
        centerline_inte_folder = [wave_folder 'centerline_inte\'];
        if ~exist(centerline_inte_folder,'dir')
            mkdir(centerline_inte_folder)
        end
        if ~exist([wave_folder 'centerline_inte_txt\'],'dir')
            mkdir([wave_folder 'centerline_inte_txt\'])
        end
        centerlines = dir([centerline_folder,'*.mat']);
        frame_num = length(centerlines);
        for j = 1:frame_num
            load([centerline_folder centerlines(j).name]);
            centerline = spline_fitting_partition(centerline(inte_range(i,1):inte_range(i,2),:), Partition_Num);
            % save centerline
            centerline_name = [centerline_inte_folder centerlines(j).name];
            save(centerline_name,'centerline');
            filename = [wave_folder 'centerline_inte_txt\' centerlines(j).name(1:end-4) '.txt'];
            dump_centerline(centerline,filename);
            disp(['finish: ' num2str(j) '/' num2str(frame_num)]);
        end
    end
    disp('Truncation Finished');
end