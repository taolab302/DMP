function [coeff, score, fractional_sigma, data_cov] = PCA_Reduction(data)
% use pca to process data, each column is one frame of worm theta

% use matlab PCA
% if ~isempty(data)
% 	[coeff,score,latent] = pca(data'); % 
%     fractional_sigma = cumsum(latent)/sum(latent);
% else
%     coeff = [];
%     score = [];
%     fractional_sigma = [];
% end

% % use svd to do PCA, the input is mean covaraince matrix
if ~isempty(data)
    data = data - repmat(mean(data),length(data(:,1)),1);
    data_cov = data * data';
    [~,S,V] = svd(data_cov); %����ʵ�Գƾ�����U��V���ͣ���������ֻ�������Ų��
    latent = diag(S);
    fractional_sigma = cumsum(latent)/sum(latent);
    coeff = V;
    score = V*data;
else
    coeff = [];
    score = [];
    fractional_sigma = [];
end

end