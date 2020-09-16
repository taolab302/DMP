function centerlineElong = ElongateCL(centerline,img)
  % 延长中心线抵达头尾边缘，img为二值图
  
    width = length(img(1,:));
  
  % toward head
  vHead = centerline(1,:)-centerline(2,:);
  vHead = vHead/norm(vHead);
  head = centerline(1,:);
    for i = 1:width
        temp = centerline(1,:) + i*vHead;
        if img(int32(temp(1)),int32(temp(2)))>0
            head = double(int32(temp));
        else 
            break;
        end
    end
    
   % toward tail
   vTail = centerline(end,:)-centerline(end-1,:);
   vTail = vTail/norm(vTail);
   tail = centerline(end,:);
    for i = 1:width
        temp = centerline(end,:) + i*vTail;
        if img(int32(temp(1)),int32(temp(2)))>0
            tail = double(int32(temp));
        else 
            break;
        end
    end

    % add to centerline
    centerlineElong = [head;centerline;tail;];
    
    % read configure file and get partition number
    config;
    centerlineElong = spline_fitting_partition(centerlineElong, Partition_Num);

end