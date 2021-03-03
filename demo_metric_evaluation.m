%% DEMO FOR UNDERWATER IMAGE QUALITY ASSESSMENT
%  Created by Yafei.
%  DLMUCAI Lab.

%% Please cite the following refferences: 
% Blur Metric: F. Crete, T. Dolmiere, P. Ladret, et al. The blur effect: perception and estimation with a new no-reference perceptual blur metric, HVEI 2007
% PCQI: S. Wang, K. Ma, H. Yeganeh, et al. A patch-structure representation method for quality assessment of contrast changed images, IEEE SPL 2015
% UIQM: K. Panetta, C. Gao, and S. Agaian. Human-visual-system-inspired underwater image quality measures, IEEE JOE 2016
% UCIQE: M. Yang and A. Sowmya, An underwater color image quality evaluation metric, IEEE TIP 2015

%% Parameters
clear; close all; clc;
addpath('./tools/Metrics');
% original_path = './DING/original/';
% restored_path = './DING/fusion/';
original_path = '';
restored_path = '';
dataset_name = '';
str_name = '';
file_name = dir(fullfile([original_path,'*.jpg']));%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization
mse_err = zeros(1, length(file_name));
peaksnr = zeros(1, length(file_name));
ssimval = zeros(1, length(file_name));
blur_A = zeros(1, length(file_name));
entropy_A = zeros(1, length(file_name));
mpcqi = zeros(1, length(file_name));
UIQM_norm = zeros(1, length(file_name));
colrfulness = zeros(1, length(file_name));
sharpness = zeros(1, length(file_name));
contrast = zeros(1, length(file_name));
UCIQE_norm = zeros(1, length(file_name));

%% Output CSV file: open
fid = fopen(['EVALUATION',dataset_name,str_name,'.csv'],'a');
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n','Name','MSE(*1000)','PSNR(dB)','SSIM','Blur','ENTROPY','PCQI',...
    'UIQM','UCIQE');

%% Evaluations
for num = 1 : length(file_name)
    tic;
    tmp_name = file_name(num).name;
    im_ref_name = [original_path,file_name(num).name];
    tmp_out_name = [tmp_name(1:end-4),str_name,tmp_name(end-3:end)];
%     im_rest_name = [restored_path,tmp_name(1:end-4),str_name,'.jpg'];%%%%%%%%%%%%%%%%%%%%%%%%%%%
    im_rest_name = [restored_path,tmp_name(1:end-4),str_name,tmp_name(end-3:end)];%%%%%%%%%%%%%%%%%%%%%%%%%
%     im_rest_name = [restored_path,str_name,tmp_name(1:end-4),tmp_name(end-3:end)];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ref = imread(im_ref_name);
    A = imread(im_rest_name);
    %% Mean-squared error (MSE)
    mse_err(num) = immse(A, ref);

    % 
    %% Peak Signal-to-Noise Ratio (PSNR)
    [peaksnr(num), snr] = psnr(A, ref);    
    %% Structural Similarity Index (SSIM)
    [ssimval(num), ssimmap] = ssim(A,ref);
    %% Blur Metric
    blur_ref = blurMetric(ref);
    blur_A(num) = blurMetric(A);
    %% Entropy
    entropy_ref = entropy(ref);
    entropy_A(num) = entropy(A);
    %% Patch-based Contrast Quality Index(PCQI)
    [mpcqi(num), pcqi_map]=PCQI(ref, A);
    %% UIQM
    [UIQM_ref, colrfulness_ref, sharpness_ref, contrast_ref] = UIQM(ref);
    [UIQM_norm(num), colrfulness(num), sharpness(num), contrast(num)] = UIQM(A);
    %% UCIQE
    UCIQE_ref = UCIQE(ref);
    UCIQE_norm(num) = UCIQE(A);

    fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n',tmp_out_name,num2str(mse_err(num)/1000),num2str(peaksnr(num)),num2str(ssimval(num)),...
    num2str(blur_A(num)),num2str(entropy_A(num)),num2str(mpcqi(num)),num2str(UIQM_norm(num)),num2str(UCIQE_norm(num)));
    toc;
    disp(num);
end

%% Mean value
MSE_mean = mean(mse_err)/1000;
PSNR_mean = mean(peaksnr);
SSIM_mean = mean(ssimval);
blur_mean = mean(blur_A);
entropy_mean = mean(entropy_A);
PCQI_mean = mean(mpcqi);
UIQM_mean = mean(UIQM_norm);
UCIQE_mean = mean(UCIQE_norm);

%% Output CSV file: close
fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s\n','AVERAGE',num2str(MSE_mean),num2str(PSNR_mean),num2str(SSIM_mean),...
num2str(blur_mean),num2str(entropy_mean),num2str(PCQI_mean),num2str(UIQM_mean),num2str(UCIQE_mean));
fclose(fid);

%% Save MAT file
save(['EVALUATION',dataset_name,str_name,'.mat']);
