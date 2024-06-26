%% ERA evaluation in case SISO HOM
clear
close all

%% SISO parameters
numInputs = 1;
numOutputs = 1;
r_min = 20;
step = 10;
r_max = 200;
channel = 1;
plot_edc = 0;

%% original RIR
[RIR_matrix,Fs] = audioread("..\data\audio\original_RIR\rir-S1-R2-HOM1.wav");

%% preprocessing on one channel
% y_sub: GROUND TRUTH signal
% y: signal pre-ERA
% max_index: index of maximum
[y, y_sub, max_index] = rir_preprocessing(RIR_matrix(:,channel), plot_edc);

%% parameters ERA
YY = permute(y,[2 3 1]);
mco = floor((length(YY)-1)/2);

%% HSV
[~,~,~,~,HSVs] = ERA(YY,mco,mco,numInputs,numOutputs,1);
figure;
plot(HSVs);
title(strcat("HSVs of channel ",num2str(channel)));
saveas(gcf, strcat("..\data\images\PNGs\HSVs_channel_", num2str(channel), ".png"), 'png');
savefig(strcat("..\data\images\Fig\HSVs_channel_", num2str(channel)));

%% MSE AND SDR
r=r_min:step:r_max;
% mse
mse = zeros(size(r));
% sdr
sdr = zeros(size(r));
Es = sum(abs(y_sub).^2);
% cycling for different r 
for rr = r
    % ERA application
    [Ar,Br,Cr,Dr,~] = ERA(YY,mco,mco,numInputs,numOutputs,rr);
    sysERA = ss(Ar,Br,Cr,Dr,-1);
    % reduced impulse response
    [y2,~] = impulse(sysERA, 0:1:length(y_sub)-1);
    % reintroduce initial delay
    y2(end-max_index+2:end) = 0;
    y2 = circshift(y2, max_index-1, 1);
    y2 = y2 ./ norm(y2 , "fro"); 

    %% MSE
    mmse = mean((y_sub-y2).^2);
    mse((rr-r_min)/step+1) = mmse;
    disp(strcat("MSE of channel ", num2str(channel)," with r = ",num2str(rr), ": ", num2str(mse((rr-r_min)/step+1))));
    %% SDR
    Ed = sum((abs(y2(:)-y_sub(:))).^2)+1e-7;
    SDR = 10 * log10(Es ./ Ed);
    sdr((rr-r_min)/step+1) = SDR;
    disp(strcat("SDR of channel ", num2str(channel)," with r = ",num2str(rr), ": ", num2str(sdr((rr-r_min)/step+1))));
end
%%
save(strcat("savedData\MSE_SISO_Channel_", num2str(channel),".mat"),"mse");
save(strcat("savedData\SDR_SISO_Channel_", num2str(channel),".mat"),"sdr");