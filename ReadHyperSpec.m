function [data,param]=ReadHyperSpec(imgfilename)
%��������ȡimg��ʽ��ǰ����imgͼ����ʽ����'.img'��׺����
if length(imgfilename)>=4
    switch strcmp(imgfilename(length(imgfilename)-3:end), '.img')
    case 0
        hdrfilename=strcat(imgfilename, '.hdr');
    case 1
        hdrfilename=strcat(imgfilename(1: (length(imgfilename)-4)), '.hdr');
    otherwise
        fprintf('Unknown FileType');
        exit();
    end
else
    hdrfilename=strcat(imgfilename, '.hdr');
end
%�������
param.lines = 0;
param.samples = 0;
param.bands = 0;

fidin=fopen(hdrfilename);

while ~feof(fidin)                                      % �ж��Ƿ�Ϊ�ļ�ĩβ               
    tword=fscanf(fidin,'%s/r/n');
    if strcmp(tword,'samples')                          % �õ�����
        fscanf(fidin,'%s/r/n');
        param.samples = str2double(fscanf(fidin,'%s/r/n'));
    end 
    if strcmp(tword,'lines')                            % �õ�����
        fscanf(fidin,'%s/r/n');
        param.lines = str2double(fscanf(fidin,'%s/r/n'));
    end 
    if strcmp(tword,'bands')                            % �õ�������
        fscanf(fidin,'%s/r/n');
        param.bands = str2double(fscanf(fidin,'%s/r/n'));
    end 
    if strcmp(tword,'data')                             % �õ���������
        fscanf(fidin,'%s/r/n');
        fscanf(fidin,'%s/r/n');
        type = str2double(fscanf(fidin,'%s/r/n'));
        switch(type)
            case 1
                param.data_type = 'uint8';
                param.normalpar = 2^8-1;
            case 2
                param.data_type = 'int16';
                param.normalpar = 2^15-1;
            case 3
                param.data_type = 'int32';
                param.normalpar = 2^31-1;
            case 4
                param.data_type = 'float32';
                param.normalpar = 1;
            case 5
                param.data_type = 'double';
                param.normalpar = 1;
            case 12
                param.data_type = 'uint16';
                param.normalpar = 2^16-1;
            case 13
                param.data_type = 'uint32';
                param.normalpar = 2^32-1;
            otherwise
                fprintf('Unknown File Type :%d',type);
                exit();
        end
    end 
    if strcmp(tword,'interleave')                       % �õ���ʽ
        fscanf(fidin,'%s/r/n');
        param.interleave = fscanf(fidin,'%s/r/n');
    end 
end 
fclose(fidin);
disp(param.lines);
disp(param.samples);
disp(param.bands);
%��ȡͼ���ļ�
data = multibandread(imgfilename ,[param.lines, param.samples, param.bands],param.data_type,0,param.interleave,'ieee-le',{'Band','Direct',1:1:param.bands});
data = double(data);
end

