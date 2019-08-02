clear all;
[data,param]=ReadHyperSpec('LHData');        %���ú����õ��߹���ͼ�����ά���ݺ���ز���
data = hyperNormalize(data);
%% data0Ϊ��ά���ݣ�data1Ϊ��ά���ݣ�data2Ϊ��׼������ݣ�data3Ϊ�������
data0=reshape(data,param.lines,param.samples,param.bands);
data1=reshape(data0,param.samples*param.lines,param.bands);    %����άͼ��ת��Ϊ��άͼ��
data4 = data1';  

%% �����ݽ���k��ֵ���࣬��Ϊ15��
classum=15;
opts = statset('Display','final','MaxIter',200);
idx=kmeans(data1,classum,'Options',opts);    
%load('idx_SDData_15', 'idx');
%% ͳ��ÿһ�������
N=zeros(classum,1);
for i = 1:classum
    N(i) = length(find(idx == i));
end

%% ÿһ���ڲ�ͬά�ȵľ�ֵ
immean=zeros(classum,param.bands);
for i = 1:classum  
    immean(i,:) = mean(data1(find(idx == i),:));
end

%% �����ֵ�
P=25;
D=[];
for k = 1:classum
    if(N(k) < P)
        continue;
    end
    kdata = data1(find(idx == k),:);
    X = kdata - repmat(mean(kdata), size(kdata,1), 1);
    covk = (X'*X)./(size(X,1)-1);
    invcovk = inv(covk);
%     covs = cov(data1(find(idx == k), :));
    PD = [];
    for i = 1:N(k)
       PD(i) = kdata(i,:)*invcovk*kdata(i,:)';
    end
    [AscPD, index] = sort(PD);
    for i = 1:P
        D = [D; kdata(index(i),:)];
    end
end
fprintf('the dictionary is constructed succeed\n');

%% �Ż�
%[S,E] = LADMAP(data4, D', 0.05, 0.1);

[S,E] = lrra(data4,D',0.1);
[M, N, L] = size(data);

img = zeros(M*N,1);
for i = 1:M*N
    img(i) =  sqrt(sum(E(:, i).^2));
%     if img(i) > 4*10^13
%         img(i) = 0;
%     else 
%         img(i) = 255;
%     end
end
img = reshape(img', M, N, 1);
figure; imshow(img);
figure; imagesc(img); title('Results'); axis image;
    colorbar;

src = imread('LHDataGt.bmp');
% 
% % RX Anomly Detector
r = zeros(M*N, 1);
r = RxDetector(data4);
r = hyperConvert3d(r.', M, N, 1);
figure; imagesc(r); title('RX Detector Results'); axis image;
    colorbar;



AUC(src(:), img(:))
hold on
AUC(src(:), r(:))
legend('LRR','RX');
