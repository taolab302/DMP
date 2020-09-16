clear;
Folder = 'G:\Backup\20191129\Intestine-2\';
Worm_name = '20191129-F2-wave';
wave_index = 12;

waveFolder = [Folder(1:end-1) '-Wave\wave-' num2str(wave_index) '\'];
load([waveFolder 'wormLength.mat']);
save_name = [Worm_name '-' num2str(wave_index) '-BocEvent'];

frame_rate = 8;
interval_thre = 2; 
text_dist = 2;

L_loess_temp = smooth(L,0.1,'loess');
% L_loess = smooth(L_loess_temp,'moving',3);
L_loess = L_loess_temp;

[vllys,vlly_locs] = findpeaks(-L_loess);
vllys = -vllys;
[pks,pk_locs] = findpeaks(L_loess);
if length(vllys)>2
   for i = 1:length(vllys)
        if  (min(abs(vlly_locs(i)-pk_locs))<=interval_thre||vlly_locs(i)>=(length(L_loess)-8))...
                &&vllys(i)>min(vllys)
            vlly_locs(i) = 0;
        end
   end
end
vllys = vllys(vlly_locs>0);
vlly_locs = vlly_locs(vlly_locs>0);
[vllys,I] = sort(vllys);
% if abs(vlly_locs(I(1))-vlly_locs(I(2)))<interval_thre
%    vlly_locs = vlly_locs([round(mean(vlly_locs(I(1:2)))),3:end]); 
% end

if vlly_locs(I(1))<vlly_locs(I(2))
    pBocMax = vlly_locs(I(1));
    aBocMax = vlly_locs(I(2));
else
    pBocMax = vlly_locs(I(2));
    aBocMax = vlly_locs(I(1));
end
diff_L = diff(L_loess);
for pBocStart = pBocMax:(-1):2
    if diff_L(pBocStart)<0&&diff_L(pBocStart-1)>0
        break;
    end
end

for aBocStart = aBocMax:(-1):pBocMax
    if diff_L(aBocStart)<0&&diff_L(aBocStart-1)>0
        break;
    end
end

for aBocEnd = aBocMax:length(L_loess)-2
    if diff_L(aBocEnd)>0&&diff_L(aBocEnd+1)<0
        break;
    end
end


figure(128);clf;
plot((1:length(L_loess))/frame_rate,L_loess,'b');
hold on;plot(pBocStart/frame_rate,L_loess(pBocStart),'kv','MarkerFaceColor','k');
text(pBocStart/frame_rate,L_loess(pBocStart)+text_dist,'pBocStart');
hold on;plot(aBocStart/frame_rate,L_loess(aBocStart),'kv','MarkerFaceColor','k');
text(aBocStart/frame_rate,L_loess(aBocStart)+text_dist,'aBocStart');
hold on;plot(pBocMax/frame_rate,L_loess(pBocMax),'kv','MarkerFaceColor','k');
text(pBocMax/frame_rate,L_loess(pBocMax)-text_dist,'pBocMax');
hold on;plot(aBocMax/frame_rate,L_loess(aBocMax),'kv','MarkerFaceColor','k');
text(aBocMax/frame_rate,L_loess(aBocMax)-text_dist,'aBocMax');
hold on;plot(aBocEnd/frame_rate,L_loess(aBocEnd),'kv','MarkerFaceColor','k');
text(aBocEnd/frame_rate,L_loess(aBocEnd)+text_dist,'aBocEnd');
axis([0 length(L_loess)/frame_rate min(L_loess)-5 max(L_loess)+5]);
xlabel('Time(s)');ylabel('Worm Length');
hold off;

h = figure(128);
saveas(h,[save_name '.fig']);

save([save_name '.mat'],'aBocMax','pBocMax','pBocStart','aBocStart','aBocEnd','L','L_loess');