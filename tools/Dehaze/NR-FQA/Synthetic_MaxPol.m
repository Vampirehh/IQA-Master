function [score] = Synthetic_MaxPol(input_block, params)

%%
input_image = input_block.data;
[m, n] = size(input_image);
N = m*n;

%%
d = params.d;
moment_evaluation = params.moment_evaluation;
score = 0;
for n_ord = 1: numel(d)
    i_BP_v = imfilter(input_image, d{n_ord}', 'symmetric', 'conv');
    i_BP_h = imfilter(input_image, d{n_ord}, 'symmetric', 'conv');
    
    
    %%
    v = [abs(i_BP_v(:)); abs(i_BP_h(:))];
    [pdf, x] = histcounts(v, 150); % 250 for BID, 150 for CID
    pdf = normal(pdf);
    %
    cdf = cumsum(pdf)/sum(pdf);
    %  find sigma approximate
    threshold = .9;
    indx = cdf < threshold;
    sigma_apprx = x(sum(indx))/max(x);
    %c = min(.45, 1 - min(.96, 8*sigma_apprx));
    c = (1-tanh(50*(sigma_apprx-.095)))/2*.41+.04;
    
    %%
    p_norm = 1/2;
    %p_norm = (443/sqrt(N))^6;
    feature_map = (abs(i_BP_h).^p_norm + abs(i_BP_v).^p_norm).^(1/p_norm);
    
    %%
    number_of_pixels = round(c*N);
    feature_map = sort(feature_map(:), 'descend');
    feature_map = feature_map(1: number_of_pixels);
    
    %%
    val = moment(feature_map, moment_evaluation(n_ord));
    val = -log10(val);
    score = score + val;
end
if score == Inf
    score = 120;
end
