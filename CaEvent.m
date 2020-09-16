function [Ca_start,Ca_rise,Ca_max] = CaEvent(I)
    frame_num = length(I(:,1));
    seg_num = length(I(1,:));
    Ca_start = zeros(seg_num,1);
    Ca_max = zeros(seg_num,1);
    Ca_rise = zeros(seg_num,1);
    stds = zeros(frame_num,1);
    means = zeros(frame_num,1);
    
    for i = 1:seg_num
        for j  = 1:frame_num
        stds(j,1) = std(I(1:j,i));
        means(j,1) = mean(I(1:j,i));
        end
        test = I(:,i)-means-3*stds;
        for j  = 1:frame_num
            if test(j)>0&&test(j+1)>0
            Ca_start(i) = j;
            break;
            end
        end
    end
    for i = 1:49
        Ca_max(i) = find(I(:,i)==max(I(:,i)));
    end
    for i = 1:seg_num
        diff_I = diff(I(:,i));
        Ca_rise(i) = find(diff_I==max(diff_I(Ca_start(i):Ca_max(i))));
    end
end
