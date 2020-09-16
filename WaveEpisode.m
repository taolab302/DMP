% global_I = image_intensities;
Folder = 'G:\Backup\20191128\';
worm_index = 2;

load([Folder 'Intestine-' num2str(worm_index) 'Global_I.mat'])

global_I(global_I<max(global_I)*0.67) = 0;
% global_I(global_I<max(global_I)*0.35) = 0;
global_Is = smooth(global_I,'moving',3);
[~,img_Ipks] = findpeaks(global_Is);
figure;plot(global_Is);hold on;

time(:,1) = img_Ipks;
time(:,3) = 0;
% peak_selected = [431 849 1294 1726 2145 2620 2985 3394 3808 4196 4486 4837]'*8;
% 
% for i = 1:length(peak_selected)
%     selected_index = find(abs(img_Ipks-peak_selected(i))==min(abs(img_Ipks-peak_selected(i))));
%     time(selected_index,3) = 1;   % this wave is handy for processing
% end

time(:,1) = time(:,1)+10;
time(:,2) = 50;

% plot(time(time(:,3)==1,1),global_Is(time(time(:,3)==1,1)),'ro')

time_name = [Folder 'Intestine-' num2str(worm_index) '.txt'];
 fid = fopen(time_name,'w');  
            for j = 1:length(img_Ipks)
                fprintf(fid,'%d    %d	%d\n',time(j,1),time(j,2),time(j,3));
            end
 fclose(fid);
        