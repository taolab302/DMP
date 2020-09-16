%% Sub-functions
function thetas = ComputeTheta(centerlines)
% compute the theta along cemterline

% c_num = length(dir([centerline_folder,'*.mat']));
c_num = length(centerlines(:,1,1));
for i=1:c_num
    if mod(i,100)==0
       disp(['        ',num2str(i)])
    end
%     c_name = [centerline_folder num2str(i) '.mat'];
%     load(c_name);
    
centerline = [centerlines(i,:,1);centerlines(i,:,2);]';

    if i==1
        p_num = length(centerline);
        thetas = zeros(p_num, c_num);
        dela = 1.0/(p_num-1.0);
        a0=0.0:dela:1.;
        npt1 = p_num+2;
        delb = 1.0/(npt1-1.0);
        b0=0.0:delb:1.;
    end
    
    px = csapi(a0,centerline(:,1),b0);
    py = csapi(a0,centerline(:,2),b0);
    pxdiff = px(2:npt1)-px(1:npt1-1);
    pydiff = py(2:npt1)-py(1:npt1-1);
    pdiff  = sqrt(pxdiff.^2+pydiff.^2);
    sarc   = zeros(size(b0)); % arclength s
    for j=1:npt1-1
        sarc(j+1) = sarc(j) + pdiff(j);
    end;
    slength = max(sarc);
    sarc = sarc/slength;
    sx = csapi(sarc,px,b0);
    sy = csapi(sarc,py,b0); % now the curve is parametrized by arclength
    % sxdiff=sx(2:npt1)-sx(1:npt1-1);
    % sydiff=sy(2:npt1)-sy(1:npt1-1);
    % sdiff=sqrt(sxdiff.^2+sydiff.^2); %code to check sx and sy
    
    % compute angle
    dsx = circshift(sx,[0 -1])-circshift(sx,[0 1]);
    dsy = circshift(sy,[0 -1])-circshift(sy,[0 1]);
    thetasarc = atan2(dsy,dsx);
    thetaunw  = unwrap(thetasarc);
    thetas(:,i)   = thetaunw(2:npt1-1);
end

end