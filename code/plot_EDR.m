%% plot EDR
clear
close all

%% HOM
%% RIR compressed SISO
for r = [20, 60, 88, 160, 200]
    [y,Fs] = audioread(strcat("..\data\audio\RIR_comp\RIR_comp_", num2str(r),".wav"));
    edr = EDR (y,Fs);
    title(strcat("Energy Decay Relief with r = ",num2str(r)));
    saveas(gcf, strcat("..\data\images\PNGs\EDR_", num2str(r),".png"), 'png');
    savefig(strcat("..\data\images\Fig\EDR_", num2str(r)));
end

%% RIR compressed MIMO
for r = [100, 200, 350, 500]
    [y,Fs] = audioread(strcat("..\data\audio\RIR_comp\RIR_comp_MIMO_S1_", num2str(r),".wav"));
    edr = EDR (y(:,1),Fs);
    title(strcat("Energy Decay Relief of first channel (MIMO) with r = ",num2str(r)));
    saveas(gcf, strcat("..\data\images\PNGs\EDR_MIMO_S1_", num2str(r),".png"), 'png');
    savefig(strcat("..\data\images\Fig\EDR_MIMO_S1_", num2str(r)));
end

%% original RIR
[RIR_matrix,Fs_2] = audioread("..\data\audio\original_RIR\rir-S1-R2-HOM1.wav");
y_1 = RIR_matrix(:,1);
[~, y_sub, ~] = rir_preprocessing(y_1, 0);
edr_matrix = EDR(y_sub,Fs);
title("Energy Decay Relief of original RIR (HOM)")
saveas(gcf, strcat("..\data\images\PNGs\EDR_matrix.png"), 'png');
savefig("..\data\images\Fig\EDR_matrix");

%% ULA 
%% RIR compressed MIMO
for r = [100, 200, 350, 500]
    [y,Fs] = audioread(strcat("..\data\audio\RIR_comp\RIR_comp_MIMO_ULA_S1_", num2str(r),".wav"));
    edr = EDR (y(:,1),Fs);
    title(strcat("Energy Decay Relief of ULA with r = ",num2str(r)));
    saveas(gcf, strcat("..\data\images\PNGs\EDR_MIMO_ULA_S1_", num2str(r),".png"), 'png');
    savefig(strcat("..\data\images\Fig\EDR_MIMO_ULA_S1_", num2str(r)));
end

%% original RIR
[RIR_matrix,Fs_2] = audioread("..\data\audio\original_RIR\rir-S1-ULA.wav");
y_1 = RIR_matrix(:,1);
[~, y_sub, ~] = rir_preprocessing(y_1, 0);
edr_matrix = EDR(y_sub,Fs);
title("Energy Decay Relief of original RIR (ULA)");
saveas(gcf, strcat("..\data\images\PNGs\EDR_matrix_ULA.png"), 'png');
savefig("..\data\images\Fig\EDR_matrix_ULA");