% preprocessing on signal y (one channel)
% flag == 1 if we want plot of t30

function [y1, y_sub, max_index] = rir_preprocessing(y, flag)
% resample at 8kHz
y_sub = resample(y,1,6);
% preringing set to 0
[~, max_index] = max(abs(y_sub));
y_sub(1:(max_index-1)) = 0;
% normalization
y_sub = y_sub ./ norm(y_sub , "fro");

% t30
cutoff_sample = t30(y_sub,flag);
% remove initial silence and tail
y1 = y_sub(max_index:cutoff_sample);
% normalization before ERA
y1 = y1 ./ norm(y1 , "fro");
end