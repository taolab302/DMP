function Worm = SVD_I(worm_name,wave_seq)
    % eg. worm_name = '20191127-F1'
    Folder = 'G:\Analysis\Normalized I\';
    load([Folder worm_name ' inte_range.mat'],'inte_range');
    Worm = struct([]);
    for i = 1:length(wave_seq)
        wave_index = wave_seq(i);
        load([Folder worm_name '-wave ' num2str(wave_index) '.mat'],'I_normalize');
        sigma = 1;
        gausFilter = fspecial('gaussian', [3,3], sigma);
        Worm(i).I_gaus= imfilter(I_normalize, gausFilter, 'replicate');
        [Worm(i).Ui,Worm(i).Si,Worm(i).Vi] = svd(Worm(i).I_gaus(:,inte_range(wave_index,1):inte_range(wave_index,2)));
    end    
end