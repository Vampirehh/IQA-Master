function out = NR-FQA(img)
addpath('utilities');

%%  transfer images into grayscale
I = im2double(rgb2gray(img));

%% Load kernel and set parameters
load('MaxPol_kernel.mat');
params.d = MaxPol_kernel;
params.moment_evaluation = [72, 8];

%% NR-FQA Score on the image
input_data.data = I;
score = Synthetic_MaxPol(input_data, params);

out = score;
end