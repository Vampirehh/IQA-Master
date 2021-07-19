%%
clear all;
close all;
clc;

%% 
addpath('utilities');
fprintf(['==> Note that high score value indicates more blurriness in input image \n']);

%% Load image and covnert to grayscale image with single values
blurry_image = imread([pwd, filesep, 'data', filesep, 'blurry_image.bmp']);
original_image = imread([pwd, filesep, 'data', filesep, 'original_image.bmp']);

%%  transfer images into grayscale
original_image = im2double(rgb2gray(original_image));
blurry_image = im2double(rgb2gray(blurry_image));

%% Load kernel and set parameters
load('MaxPol_kernel.mat');
params.d = MaxPol_kernel;
params.moment_evaluation = [72, 8];

%% NR-FQA Score on original image
input_data.data = original_image;
score_original = Synthetic_MaxPol(input_data, params);
fprintf(['NR-FQA score original image = ', num2str(score_original), '\n']);

%% NR-FQA Score on original image
input_data.data = blurry_image;
score_blurry = Synthetic_MaxPol(input_data, params);
fprintf(['NR-FQA score blurry image = ', num2str(score_blurry), '\n']);
