%% plot EDC
clear
close all

%% HOM
%% RIR compressed SISO
for r = [20, 60, 88, 160, 200]
    [y,Fs] = audioread(strcat("..\data\audio\RIR_comp\RIR_comp_", num2str(r),".wav"));
    edc = t30(y,1);
    title(strcat("Energy Decay Curve with r = ",num2str(r)));
    saveas(gcf, strcat("..\data\images\PNGs\EDC_", num2str(r),".png"), 'png');
    savefig(strcat("..\data\images\Fig\EDC_", num2str(r)));
end

%% RIR compressed MIMO
for r = [100, 200, 350, 500]
    [y,Fs] = audioread(strcat("..\data\audio\RIR_comp\RIR_comp_MIMO_S1_", num2str(r),".wav"));
    edc = t30(y(:,1),1);
    title(strcat("Energy Decay Curve of first channel (MIMO) with r = ",num2str(r)));
    saveas(gcf, strcat("..\data\images\PNGs\EDC_MIMO_S1_", num2str(r),".png"), 'png');
    savefig(strcat("..\data\images\Fig\EDC_MIMO_S1_", num2str(r)));
end

%% original RIR
[RIR_matrix,Fs_2] = audioread("..\data\audio\original_RIR\rir-S1-R2-HOM1.wav");
y_1 = RIR_matrix(:,1);
[~, y_sub, ~] = rir_preprocessing(y_1, 0);
edc = t30(y_sub,1);
title("EDC of channel one");
saveas(gcf, strcat("..\data\images\PNGs\EDC_channel_1.png"), 'png');
savefig("..\data\images\Fig\EDC_channel_1");

%% ULA

%% RIR compressed MIMO
for r = [100, 200, 350, 500]
    [y,Fs] = audioread(strcat("..\data\audio\RIR_comp\RIR_comp_MIMO_ULA_S1_", num2str(r),".wav"));
    edc = t30(y(:,1),1);
    title(strcat("Energy Decay Curve of ULA first channel (MIMO) with r = ",num2str(r)));
    saveas(gcf, strcat("..\data\images\PNGs\EDC_MIMO_ULA_S1_", num2str(r),".png"), 'png');
    savefig(strcat("..\data\images\Fig\EDC_MIMO_ULA_S1_", num2str(r)));
end

%% original RIR
[RIR_matrix,Fs_2] = audioread("..\data\audio\original_RIR\rir-S1-ULA.wav");
y_1 = RIR_matrix(:,1);
[~, y_sub, ~] = rir_preprocessing(y_1, 0);
edc = t30(y_sub,1);
title("EDC of ULA channel one");
saveas(gcf, strcat("..\data\images\PNGs\EDC_ULA_channel_1.png"), 'png');
savefig("..\data\images\Fig\EDC_ULA_channel_1");