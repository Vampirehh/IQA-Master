%% README
%=========================================================================%
% BRISQUE: A quality score of the image. The score typically has a value
%          between 0 and 100 (0 represents the best quality, 100 the worst).
%
% CCF: The larger the value, the better.

% CPBDM: CPBD_compute.m computes the CPBD based Sharpness Metric 
%       given an input grayscale image.

% FADE: The smaller the value, the better.

% ILNIQE: The smaller the value, the better.

% JNBM: JNBM_compute.m computes the JNB based Sharpness Metric 
%       given an input grayscale image.

% LPC: no-reference sharpness objective score of the input
%       image. 1 means very sharp, and 0 means very blurred.

% NIQE: A quality score of the image. Higher value represents a lower quality.

% SSEQ: A quality score of the image. The score typically has a value
%         between 0 and 100 (0 represents the best quality, 100 the worst).

% R: R.m is used to calculate the blind assessment indicates and image 
%    visibility. The larger the value, the better.

% NR-FQA: score no-reference (NR) image sharpness assessment (ISA) 
%         of synthetically blurred images. Note that high score value 
%         indicates more blurriness in input image. 
%=========================================================================%












clear; close all; clc;
%%
%=================================<addpath>===============================%
addpath('./tools/Dehaze/BRISQUE');
addpath('./tools/Dehaze/CCF');
addpath('./tools/Dehaze/CPBDM');
addpath('./tools/Dehaze/FADE');
addpath('./tools/Dehaze/ILNIQE');
addpath('./tools/Dehaze/JNBM');
addpath('./tools/Dehaze/LPC');
addpath('./tools/Dehaze/NIQE');
addpath('./tools/Dehaze/ROBUST');
addpath('./tools/Dehaze/SSEQ');
addpath('./tools/Dehaze/R')
addpath('./tools/Dehaze/NR-FQA')
%=========================================================================%

%%
%=================================<Parameters>=============================%
original_path = 'E:\DLMU\数据集\Other\RTTS雾数据集\JPEGImages\';
restored_path = 'E:\DLMU\WGX\LS\Image-Dehazing-and-Exposure-\RTTS_IDE_results\'; 
dataset_name = '_RTTS_'; 
str_name = 'IDE_';
file_name = dir(fullfile([original_path,'*.png']));
%=========================================================================%

%%
%===========================<Initialization>==============================%
brisque = zeros(1, length(file_name));
ccf = zeros(1, length(file_name));
cpbdm = zeros(1, length(file_name));
fade = zeros(1, length(file_name));
ilniqe = zeros(1, length(file_name));
jnbm = zeros(1, length(file_name));
lpc_val = zeros(1, length(file_name));
niqe = zeros(1, length(file_name));
robust = zeros(1, length(file_name));
sseq = zeros(1, length(file_name));
r = zeros(1,length(file_name));
nr_fqa = zeros(1,length(file_name));
%=========================================================================%


%%
%=============================<Evaluations>===============================%
fid = fopen(['EVALUATION',dataset_name,str_name,'.csv'],'a');
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Name','BRISQUE','CCF','CPBDM','FADE','JNBM',...
    'LPC','ILNIQE','NIQE','SSEQ','ROBUST','R','NR-FQA');

cd('./tools/Dehaze/ILNIQE')
templateModel = load('templatemodel.mat');
templateModel = templateModel.templateModel;
mu_prisparam = templateModel{1};
cov_prisparam = templateModel{2};
meanOfSampleData = templateModel{3};
principleVectors = templateModel{4};
cd('../../../')


for num = 1 : length(file_name)
    tic;
    tmp_name = file_name(num).name;
    im_ori_name = [original_path,file_name(num).name];
    tmp_out_name = [tmp_name(1:end-4),str_name,tmp_name(end-3:end)];
    %     im_rest_name = [restored_path,tmp_name(1:end-4),str_name,'.jpg'];%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     im_rest_name = [restored_path,tmp_name(1:end-4),str_name,tmp_name(end-3:end)];%%%%%%%%%%%%%%%%%%%%%%%%%
        im_rest_name = [restored_path,str_name,tmp_name(1:end-4),tmp_name(end-3:end)];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Ori = imread(im_ori_name);
    A = imread(im_rest_name);       
    cd('./tools/Dehaze/BRISQUE')
    brisque(num) = brisquescore(A);
    cd('../../../')
    ccf(num) = CCF(A);
    A_gray = rgb2gray(A);
    cpbdm(num) = CPBD_compute(A_gray);
    fade(num) = FADE(A);
    % ilniqe(num) = computequality(A,mu_prisparam,cov_prisparam,principleVectors,meanOfSampleData);
    jnbm(num) =  JNBM_compute(A_gray);
    lpc_val(num) = lpc_color(A);
    cd('./tools/Dehaze/niqe_release')
    niqe(num) = clac_niqe(A);
    cd('../../../')
    
    sseq(num) = SSEQ(A);
    cd('./tools/Dehaze/ILNIQE')
    ilniqe(num) = computequality(A,mu_prisparam,cov_prisparam,principleVectors,meanOfSampleData);
    cd('../../../')

    robust(num) = 0;  % !!! Debugging has not been successful. 
    
    cd('./tools/Dehaze/R')
    r(num) = R(Ori,A);
    cd('../../../')

    cd('./tools/Dehaze/NR-FQA')
    nr_fqa(num) = NR_FQA(A);
    cd('../../../')
    
    
    fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',tmp_out_name,num2str(brisque(num)),num2str(ccf(num)),num2str(cpbdm(num)),...
        num2str(fade(num)),num2str(jnbm(num)),num2str(lpc_val(num)),num2str(ilniqe(num)),num2str(niqe(num)),num2str(sseq(num)),...
        num2str(robust(num)),num2str(r(num)),num2str(nr_fqa(num)));
    toc;
    disp(num);
end
%=========================================================================%



%% Mean value
brisque_mean = mean(brisque);
ccf_mean = mean(ccf);
cpbdm_mean = mean(cpbdm);
fade_mean = mean(fade);
ilniqe_mean = mean(ilniqe);
jnbm_mean = mean(jnbm);
lpc_val_mean = mean(lpc_val);
niqe_mean = mean(niqe);
robust_mean = mean(robust);
sseq_mean = mean(sseq);
r_mean = mean(r);
nr_fqa_mean = mean(nr_fqa);

%% Output CSV file: close
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,s%\n','Mean_value',num2str(brisque_mean),num2str(ccf_mean),num2str(cpbdm_mean),...
    num2str(fade_mean),num2str(jnbm_mean),num2str(lpc_val_mean),num2str(ilniqe_mean),num2str(niqe_mean),num2str(sseq_mean),...
    num2str(robust_mean),num2str(r_mean),num2str(nr_fqa_mean));
fclose(fid);

%% Save MAT file
save(['EVALUATION_',dataset_name,str_name,'.mat']);
