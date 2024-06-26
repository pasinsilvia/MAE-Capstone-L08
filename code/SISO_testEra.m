%% application of ERA (SISO HOM) saving the compressed RIRs
clear
close all

%% SISO parameters
numInputs = 1;
numOutputs = 1;
channel = 1;
plot_edc = 0;
Fs_sub = 8000;

%% original RIR
[RIR_matrix,Fs] = audioread("..\data\audio\original_RIR\rir-S1-R2-HOM1.wav");

%% preprocessing on one channel
% y_sub: GROUND TRUTH signal
% y: signal pre-ERA
% max_index: index of maximum
[y, y_sub, max_index] = rir_preprocessing(RIR_matrix(:,channel), plot_edc);

%% application of ERA with different r
YY = permute(y,[2 3 1]);
mco = floor((length(YY)-1)/2);
for rr = [20, 60, 88, 160, 200]
    [Ar,Br,Cr,Dr,~] = ERA(YY,mco,mco,numInputs,numOutputs,rr);
    sysERA = ss(Ar,Br,Cr,Dr,-1);
    % reduced impulse response
    [y2,~] = impulse(sysERA, 0:1:length(y_sub)-1);
    % reintroduce initial delay
    y2(end-max_index+2:end) = 0;
    y2 = circshift(y2, max_index-1, 1);
    y2 = y2 ./ norm(y2 , "fro");
    %figure
    %stairs(y_sub, 'LineWidth',2);
    %hold on
    %stairs(y2,'LineWidth',1.2);

    % save RIR
    audiowrite(strcat("..\data\audio\RIR_comp\RIR_comp_", num2str(rr), ".wav"), y2, Fs_sub);
end