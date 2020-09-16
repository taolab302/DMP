function AVL_tracking(wave_index,int_pos)
%     clear;
    Folder = 'G:\Backup\20191129\Intestine-8\';
%     wave_index = 12;

    midtime = load([Folder(1:end-1) '.txt']);
    time_frame = midtime(wave_index,2);
%     close all
    frame_seq = (midtime(wave_index,1)-time_frame+1):(midtime(wave_index,1)+time_frame);
    neuron_pos = zeros(length(frame_seq),2);
    neuron_pos(1,:) = int_pos;
    
    waveFolder = [Folder(1:end-1) '-Wave\wave-' num2str(wave_index) '\'];
    output_name = [waveFolder,'AVL_pos.txt'];  
    imgs = dir([Folder,'*.tiff']);
    
    search_interval = 15;
    intensity_ratio = 0.3;
    
    for i = 2:length(frame_seq)
       frame_index = frame_seq(i);
       bw_img = imread([waveFolder 'worm_region\' num2str(frame_index) '.tiff']);  %read segmentation image
       worm_image = imread([Folder imgs(frame_index).name]);
       
       load([waveFolder 'centerline_inte\' num2str(frame_index-1) '.mat']);
       anchor_last = centerline(1,:);
       dir_last = centerline(2,:) - centerline(1,:);% 从尾部向前搜索
       dir_last = dir_last/norm(dir_last);

       load([waveFolder 'centerline_inte\' num2str(frame_index) '.mat']);
       anchor = centerline(1,:);
       dir_curr = centerline(2,:) - centerline(1,:);% 从尾部向前搜索
       dir_curr = dir_curr/norm(dir_curr);

       
%        theta = dir_curr-dir_last;
       pos = 4*((neuron_pos(i-1,:)/4-anchor_last)*[dir_curr/dir_last]+anchor);
       [neuron_pos(i,1),neuron_pos(i,2)] = UpdateNeuronPos(pos(1),pos(2),search_interval,intensity_ratio,worm_image);
       [neuron_pos(i,1),neuron_pos(i,2)] = UpdateNeuronPos(pos(1),pos(2),search_interval-5,intensity_ratio,worm_image); 
       
       disp(['frame ' num2str(frame_index) ': x = ',num2str(neuron_pos(i,1)),'  y = ',num2str(neuron_pos(i,2))])
    end

    fid = fopen(output_name,'w');  
    for j = 1:length(frame_seq)
        fprintf(fid,'%d    %d\n',neuron_pos(j,2),neuron_pos(j,1));
    end
    fclose(fid);

end