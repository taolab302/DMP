function I = WaveIntensity(imgFolder,Folder,frame_seq)
    image_names = dir([imgFolder '*.tiff']);
    image_num = length(frame_seq);
    I = zeros(image_num,49);
    for i = 1:image_num

       frame_index = frame_seq(i);        disp(['frame: ' num2str(frame_index)])
       bw_img = imread([Folder 'worm_region\' num2str(frame_index) '.tiff']);
       img = imread([imgFolder image_names(frame_index).name]);
       img = double(imresize(img,[512,512]));
       load([Folder 'centerline\' num2str(frame_index) '.mat']);
       [left,right,centerline] = ExtractBoundaries(bw_img,centerline);
       for j = 1:49
           x = [left(j,1) left(j+1,1) right(j+1,1) right(j,1)];
           y = [left(j,2) left(j+1,2) right(j+1,2) right(j,2)];
            bw = poly2mask(y,x,512,512);
            I(i,j) = sum(sum(img.*bw))/sum(sum(bw));
       end

            
        
    end



end