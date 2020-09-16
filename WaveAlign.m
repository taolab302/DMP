figure(128);
frame_rate = 8;
data = 1:8;
worm_name = '20191129-F8';
for i = 1:8
    load([worm_name '-wave-' num2str(data(i)) '-BocEvent.mat']);
    plot(((1:length(L))-pBocMax)/8,L_loess,'color',[0.5 0.5 0.5],'linewidth',1.5);hold on;
    hold on;plot((pBocStart-pBocMax)/frame_rate,L_loess(pBocStart),'rv','MarkerFaceColor','r');
    hold on;plot((aBocStart-pBocMax)/frame_rate,L_loess(aBocStart),'rv','MarkerFaceColor','r');
    hold on;plot((pBocMax-pBocMax)/frame_rate,L_loess(pBocMax),'rv','MarkerFaceColor','r');
    hold on;plot((aBocMax-pBocMax)/frame_rate,L_loess(aBocMax),'rv','MarkerFaceColor','r');
    hold on;plot((aBocEnd-pBocMax)/frame_rate,L_loess(aBocEnd),'rv','MarkerFaceColor','r');
    
    interp_x = double((int32(CaRise(data(i)))-1):(int32(CaRise(data(i)))+1));
    y = interp1(interp_x,L_loess(interp_x),CaRise(data(i)),'spline');
    line([CaRise(data(i))-pBocMax,CaRise(data(i))-pBocMax]/8,[y-1,y+1],'color','m','linewidth',1.5)
    
%     plot(([AVL(data(i),1):AVL(data(i),2)]-pBocMax_all(data(i)))/frame_rate...
%         ,L_loess_all(data(i),[AVL(data(i),1):AVL(data(i),2)]),'c');
end
ylabel('Worm Length');title(worm_name);xlabel('Time(s)')

