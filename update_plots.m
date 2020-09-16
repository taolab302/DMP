function update_plots(Folder,wave_index)

% Folder = 'G:\Backup\20191129\Intestine-14\';
% wave_index = [1:16];

frame_rate = 8;
midtime = load([Folder(1:end-1) '.txt']);
intestineFolder = [Folder(1:end-1) '-Wave\'];

for i = wave_index
   disp(['update: wave-' num2str(i)])
   clf(figure(128));
   waveFolder = [Folder(1:end-1) '-Wave\wave-' num2str(i) '\'];
   time_frame = midtime(i,2);
   frame_seq = (midtime(i,1)-time_frame+1):(midtime(i,1)+time_frame);
   I = WaveIntensity_inte(Folder,waveFolder,frame_seq);
   save([waveFolder 'waveIntensity.mat'],'I');
   PlotLengthIntensity(waveFolder,i,frame_rate,intestineFolder);
end
end