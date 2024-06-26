% preprocessing on signal y (multichannel)
% flag == 1 if we want plot of t30

function [y_n, y_sub, max_index] = rir_preprocessing_MIMO(y, flag, numInputs, numOutputs)
% resampling at 8kHz
y_sub = resample(y,1,6);

max_index = zeros(numOutputs, numInputs);
cutoff_samples = zeros(numOutputs, numInputs);

for i = 1 : numOutputs
    for j = 1 : numInputs
        % preringing set to 0
        [~, max_index(i,j)] = max(abs(y_sub(:, i, j)));
        y_sub(1:(max_index(i,j)-1),i,j) = 0;
        % normalization
        y_sub(:,i,j) = y_sub(:,i,j) ./ norm(y_sub(:,i,j) , "fro");
        % t30
        cutoff_samples(i,j) = t30(y_sub(:, i, j),flag);
    end
end
% max cutoff sample between all channels
max_cutoff = max(cutoff_samples(:));
y_n = zeros(max_cutoff, numOutputs, numInputs);

for i = 1 : numOutputs
    for j = 1 : numInputs
        % remove initial silence and tail
        y_n(:,i,j) = y_sub(max_index(i,j):max_index(i,j)+max_cutoff-1,i,j);
        % normalization before ERA
        y_n(:,i,j) = y_n(:,i,j) ./ norm(y_n(:,i,j) , "fro");
    end
end
end