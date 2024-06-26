%% ERA evaluation in case MIMO HOM
clear
close all

%% MIMO parameters
numInputs = 2;
numOutputs = 8;
r_min = 20;
step = 80;
r_max = 500;
plot_edc = 0;

%% original RIR
[RIR_matrix(:,:,1),Fs] = audioread("..\data\audio\original_RIR\rir-S1-R2-HOM1.wav");
[RIR_matrix(:,:,2),Fs] = audioread("..\data\audio\original_RIR\rir-S2-R2-HOM1.wav");

%% preprocessing on original matrix
% y_sub: GROUND TRUTH signal
% y: signal pre-ERA
% max_index: index of maximum
[y, y_sub, max_index] = rir_preprocessing_MIMO(RIR_matrix, plot_edc, numInputs, numOutputs);

%% ERA parameters
YY = permute(y,[2 3 1]);
mco = floor((length(YY)-1)/2);

%% HSV
[~,~,~,~,HSVs] = ERA(YY,mco,mco,numInputs,numOutputs,1);
figure;
plot(HSVs);
title(strcat("HSVs of MIMO"));
saveas(gcf, strcat("..\data\images\PNGs\HSVs_MIMO.png"), 'png');
savefig(strcat("..\data\images\Fig\HSVs_MIMO"));

%% MSE AND SDR
r=r_min:step:r_max;
% mse
mse = zeros(size(r));
% mse for single channel
mse_single = zeros(length(r), numOutputs, numInputs);
% sdr
sdr = zeros(size(r));
% sdr for single channel
sdr_single = zeros(length(r), numOutputs, numInputs);
Es = sum(abs(y_sub(:)).^2);
% cycling for different r
for rr = r
    % ERA application
    [Ar,Br,Cr,Dr,~] = ERA(YY,mco,mco,numInputs,numOutputs,rr);
    sysERA = ss(Ar,Br,Cr,Dr,-1);
    % reduced impulse response
    [y2,~] = impulse(sysERA, 0:1:length(y_sub)-1);

    for i=1:numOutputs
        for j=1:numInputs
            % reintroduce initial delay
            y2(end-max_index(i,j)+2:end, i, j) = 0;
            y2(:, i, j) =  circshift(y2(:,i,j), max_index(i,j)-1, 1);
            y2(:,i,j) = y2(:,i,j) ./ norm(y2(:,i,j) , "fro");
            % mse for single channel
            mse_single((rr-r_min)/step+1,i,j) = mean((y_sub(:,i,j)-y2(:,i,j)).^2);
            % SDR for single channel
            Ed = sum((abs(y2(:,i,j)-y_sub(:,i,j))).^2)+1e-7;
            Es_single = sum(abs(y_sub(:,i,j)).^2);
            SDR = 10 * log10(Es_single ./ Ed);
            sdr_single((rr-r_min)/step+1,i,j) = SDR;
        end
    end

    %% MSE
    mmse = mean((y_sub(:)-y2(:)).^2);
    mse((rr-r_min)/step+1) = mmse;
    disp(strcat("MSE multichannel with r = ",num2str(rr), ": ", num2str(mse((rr-r_min)/step+1))));
    %% SDR
    Ed = sum((abs(y2(:)-y_sub(:))).^2)+1e-7;
    SDR = 10 * log10(Es ./ Ed);
    sdr((rr-r_min)/step+1) = SDR;
    disp(strcat("SDR multichannel with r = ",num2str(rr), ": ", num2str(sdr((rr-r_min)/step+1))));
end

%%
save("savedData\MSE_single_MIMO.mat", "mse_single");
save("savedData\MSE_MIMO.mat","mse");
save("savedData\SDR_single_MIMO.mat", "sdr_single");
save("savedData\SDR_MIMO.mat","sdr");    