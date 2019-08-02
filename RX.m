function outputimage=RX(A)
[m,n,q]=size(A);
newimage= reshape( A,m*n,q);
lastimage=newimage';
meanRow=mean(lastimage,2);%��ÿһ�еľ�ֵ
% meanRow=round(meanRow);%ȡ��
% C=zeros(q,q);
% for i=1:m*n 
%      lastimage(:,i)= lastimage(:,i)-meanRow;
%     
% C= lastimage*lastimage'+C; 
% Csum=C;
% end
% Wcov=Csum/(m*n);%Э�������

for i=1:m*n 
     lastimage(:,i)= lastimage(:,i)-meanRow;
end
Wcov=cov(lastimage');
invWcov=inv(Wcov)/(m*n-1);


rx=zeros(1,m*n);
for i=1:m*n
    rx(i)=lastimage(:,i)'* invWcov *lastimage(:,i);  
end
outputimage=reshape(rx,m,n);
outputimage=mat2gray(outputimage);



