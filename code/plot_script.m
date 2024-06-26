%% plot MSE and SDR
clear
close all

%% HOM
[RIR_matrix(:,:,1),Fs] = audioread("..\data\audio\original_RIR\rir-S1-R2-HOM1.wav");
[RIR_matrix(:,:,2),Fs] = audioread("..\data\audio\original_RIR\rir-S2-R2-HOM1.wav");

% SISO
channel = 1;
[~, y_sub_SISO, ~] = rir_preprocessing(RIR_matrix(:,channel), 0);
numInputs_SISO = size(y_sub_SISO,3);
numOutputs_SISO = size(y_sub_SISO,2);
size_SISO = size(y_sub_SISO,1);
% MIMO
numInputs_MIMO = size(RIR_matrix,3);
numOutputs_MIMO = size(RIR_matrix,2);
[~, y_sub_MIMO, ~] = rir_preprocessing_MIMO(RIR_matrix, 0, numInputs_MIMO, numOutputs_MIMO);
size_MIMO = size(y_sub_MIMO,1);

%% ULA
[RIR_matrix_ULA(:,:,1),Fs] = audioread("..\data\audio\original_RIR\rir-S1-ULA.wav");
[RIR_matrix_ULA(:,:,2),Fs] = audioread("..\data\audio\original_RIR\rir_S2-ULA.wav");

numInputs_ULA = size(RIR_matrix_ULA,3);
numOutputs_ULA = 8;
%first numOutputs channels
y1 = RIR_matrix_ULA(:,1:numOutputs_ULA,:); 
[~, y_sub_ULA, ~] = rir_preprocessing_MIMO(y1, 0, numInputs_ULA, numOutputs_ULA);
size_ULA = size(y_sub_ULA,1);

%% parameters SISO
r_min = 20;
step = 10;
r_max = 200;
r=r_min:step:r_max;

%% MSE vs Occupied Space
mse = load("savedData\MSE_SISO_Channel_1.mat");
mse = mse.mse;
figure;
p = plot(r.^2+numOutputs_SISO*r+numInputs_SISO*r+numOutputs_SISO*numInputs_SISO, log10(mse));
p.Marker = ".";
p.MarkerSize = 10;
xline(size_SISO*numOutputs_SISO*numInputs_SISO,'-',{'Original','File','Space'});
xlabel('Occupied space');
ylabel('log(MSE)');
title(strcat("MSE vs Occupied Space of channel ", num2str(channel)));
saveas(gcf, strcat("..\data\images\PNGs\MSEvsOccupiedSpace_channel_", num2str(channel),".png"), 'png');
savefig(strcat("..\data\images\Fig\MSEvsOccupiedSpace_channel_", num2str(channel)));

%% SDR vs OccupiedSpace
sdr = load("savedData\SDR_SISO_Channel_1.mat");
SDR = sdr.sdr;
figure;
p = plot(r.^2+numOutputs_SISO*r+numInputs_SISO*r+numOutputs_SISO*numInputs_SISO, SDR);
p.Marker = ".";
p.MarkerSize = 10;
xline(size_SISO*numOutputs_SISO*numInputs_SISO,'-',{'Original','File','Space'});
xlabel('Occupied space');
ylabel('SDR(dB)');
title(strcat("SDR vs Occupied Space of channel ",num2str(channel)));
saveas(gcf, strcat("..\data\images\PNGs\SDRvsOccupiedSpace_channel_", num2str(channel), ".png"), 'png');
savefig(strcat("..\data\images\Fig\SDRvsOccupiedSpace_channel_", num2str(channel)));

%% parameters MIMO
r_min = 20;
step = 80;
r_max = 500; 
r=r_min:step:r_max;

%% MSE vs OccupiedSpace
mse = load("savedData\MSE_MIMO.mat");
mse = mse.mse;
figure;
p = plot(r.^2+numOutputs_MIMO*r+numInputs_MIMO*r+numOutputs_MIMO*numInputs_MIMO, log10(mse));
p.Marker = ".";
p.MarkerSize = 10;
xline(size_MIMO*numOutputs_MIMO*numInputs_MIMO,'-',{'Original','File','Space'});
xlabel('Occupied space');
ylabel('log(MSE)');
title("MSE vs Occupied Space of MIMO");
saveas(gcf, "..\data\images\PNGs\MSEvsOccupiedSpace_MIMO.png", 'png');
savefig("..\data\images\Fig\MSEvsOccupiedSpace_MIMO");

%% SDR vs OccupiedSpace
sdr = load("savedData\SDR_MIMO.mat");
SDR = sdr.sdr;
figure;
p = plot(r.^2+numOutputs_MIMO*r+numInputs_MIMO*r+numOutputs_MIMO*numInputs_MIMO, SDR);
p.Marker = ".";
p.MarkerSize = 10;
xline(size_MIMO*numOutputs_MIMO*numInputs_MIMO,'-',{'Original','File','Space'});
xlabel('Occupied space');
ylabel('SDR(dB)');
title("SDR vs Occupied Space of MIMO");
saveas(gcf, "..\data\images\PNGs\SDRvsOccupiedSpace_MIMO.png", 'png');
savefig("..\data\images\Fig\SDRvsOccupiedSpace_MIMO");

%% parameters ULA
r_min = 20;
step = 80;
r_max = 500;
r=r_min:step:r_max;

%% MSE vs OccupiedSpace
mse = load("savedData\MSE_ULA.mat");
mse = mse.mse;
figure;
p = plot(r.^2+numOutputs_ULA*r+numInputs_ULA*r+numOutputs_ULA*numInputs_ULA, log10(mse));
p.Marker = ".";
p.MarkerSize = 10;
xline(size_ULA*numOutputs_ULA*numInputs_ULA,'-',{'Original','File','Space'});
xlabel('Occupied space');
ylabel('log(MSE)');
title("MSE vs Occupied Space of ULA");
saveas(gcf, "..\data\images\PNGs\MSEvsOccupiedSpace_ULA.png", 'png');
savefig("..\data\images\Fig\MSEvsOccupiedSpace_ULA");

%% SDR vs OccupiedSpace
sdr = load("savedData\SDR_ULA.mat");
SDR = sdr.sdr;
figure;
p = plot(r.^2+numOutputs_ULA*r+numInputs_ULA*r+numOutputs_ULA*numInputs_ULA, SDR);
p.Marker = ".";
p.MarkerSize = 10;
xline(size_ULA*numOutputs_ULA*numInputs_ULA,'-',{'Original','File','Space'});
xlabel('Occupied space');
ylabel('SDR(dB)');
title("SDR vs Occupied Space of ULA");
saveas(gcf, "..\data\images\PNGs\SDRvsOccupiedSpace_ULA.png", 'png');
savefig("..\data\images\Fig\SDRvsOccupiedSpace_ULA");


%% MSE
mse= load("savedData\MSE_SISO_Channel_1.mat");
mse_SISO = mse.mse;
mse = load("savedData\MSE_single_MIMO.mat");
mse_MIMO = mse.mse_single;
mse_MIMO = mse_MIMO(:,1,1);
mse = load("savedData\MSE_single_ULA.mat");
mse_ULA = mse.mse_single;
mse_ULA = mse_ULA(:,1,1);

%% SDR
sdr = load("savedData\SDR_SISO_Channel_1.mat");
SDR_SISO = sdr.sdr;
sdr = load("savedData\SDR_single_MIMO.mat");
SDR_MIMO = sdr.sdr_single(:,1,1);
sdr = load("savedData\SDR_single_ULA.mat");
SDR_ULA = sdr.sdr_single(:,1,1);

%% SISO CHANNEL ONE vs MIMO CHANNEL ONE
%% MSE vs OccupiedSpace
r_min = 20;
step = 10;
r_max = 200;
r=r_min:step:r_max;
figure;
p = plot(r.^2+numOutputs_SISO*r+numInputs_SISO*r+numOutputs_SISO*numInputs_SISO, log10(mse_SISO), '-b');
p.Marker = ".";
p.MarkerSize = 10;
xline(size_SISO*numOutputs_SISO*numInputs_SISO,'-b',{'Original','File','Space'});
xlabel('Occupied space');
ylabel('log(MSE)');
hold on
r_min = 20;
step = 80;
r_max = 500;
r=r_min:step:r_max;
p = plot(r.^2+numOutputs_MIMO*r+numInputs_MIMO*r+numOutputs_MIMO*numInputs_MIMO, log10(mse_MIMO), '-r');
p.Marker = ".";
p.MarkerSize = 10;
xline(size_MIMO*numOutputs_MIMO*numInputs_MIMO,'-r',{'Original','File','Space'});
title("MSE vs Occupied Space of SISO and MIMO");
saveas(gcf, "..\data\images\PNGs\MSEvsOccupiedSpace_SISO_MIMO.png", 'png');
savefig("..\data\images\Fig\MSEvsOccupiedSpace_SISO_MIMO");

%% SDR vs OccupiedSpace
r_min = 20;
step = 10;
r_max = 200;
r=r_min:step:r_max;
figure;
p = plot(r.^2+numOutputs_SISO*r+numInputs_SISO*r+numOutputs_SISO*numInputs_SISO, SDR_SISO, '-b');
p.Marker = ".";
p.MarkerSize = 10;
xline(size_SISO*numOutputs_SISO*numInputs_SISO,'-b',{'Original','File','Space'});
xlabel('Occupied space');
ylabel('SDR(dB)');
hold on
r_min = 20;
step = 80;
r_max = 500;
r=r_min:step:r_max;
p = plot(r.^2+numOutputs_MIMO*r+numInputs_MIMO*r+numOutputs_MIMO*numInputs_MIMO, SDR_MIMO, '-r');
p.Marker = ".";
p.MarkerSize = 10;
xline(size_MIMO*numOutputs_MIMO*numInputs_MIMO,'-r',{'Original','File','Space'});
title("SDR vs Occupied Space of SISO and MIMO");
saveas(gcf, "..\data\images\PNGs\SDRvsOccupiedSpace_SISO_MIMO.png", 'png');
savefig("..\data\images\Fig\SDRvsOccupiedSpace_SISO_MIMO");

%% SISO HOM vs MIMO HOM vs MIMO ULA

%% MSE vs OccupiedSpace
r_min = 20;
step = 10;
r_max = 200;
r=r_min:step:r_max;
figure;
p = plot(r.^2+numOutputs_SISO*r+numInputs_SISO*r+numOutputs_SISO*numInputs_SISO, log10(mse_SISO),'Color',"#0000A2");
p.Marker = ".";
p.MarkerSize = 10;
hold on
r_min = 20;
step = 80;
r_max = 500;
r=r_min:step:r_max;
p = plot(r.^2+numOutputs_MIMO*r+numInputs_MIMO*r+numOutputs_MIMO*numInputs_MIMO, log10(mse_MIMO), 'Color',"#BC272D");
p.Marker = ".";
p.MarkerSize = 10;
hold on
r_min = 20;
step = 80;
r_max = 500;
r=r_min:step:r_max;
p = plot(r.^2+numOutputs_ULA*r+numInputs_ULA*r+numOutputs_ULA*numInputs_ULA, log10(mse_ULA), 'Color', "#E9C716");
p.Marker = ".";
p.MarkerSize = 10;
xl = xline(size_SISO*numOutputs_SISO*numInputs_SISO,'-',{'Original','File','Space'});
xl.Color = "#0000A2";
xl = xline(size_MIMO*numOutputs_MIMO*numInputs_MIMO,'-',{'Original','File','Space'});
xl.Color = "#BC272D";
xl = xline(size_ULA*numOutputs_ULA*numInputs_ULA,'--',{'Original','File','Space'});
xl.LabelHorizontalAlignment = 'left';
xl.Color = "#E9C716";
legend({'HOM SISO','HOM MIMO', 'ULA'}, 'Location','southeast');
xlabel('Occupied space');
ylabel('log(MSE)');
xlim([0 256000])
title("MSE vs Occupied Space of SISO, MIMO and ULA");
saveas(gcf, "..\data\images\PNGs\MSEvsOccupiedSpace_SISO_MIMO_ULA.png", 'png');
savefig("..\data\images\Fig\MSEvsOccupiedSpace_SISO_MIMO_ULA");

%% SDR vs OccupiedSpace
r_min = 20;
step = 10;
r_max = 200;
r=r_min:step:r_max;
figure;
p = plot(r.^2+numOutputs_SISO*r+numInputs_SISO*r+numOutputs_SISO*numInputs_SISO, (SDR_SISO),'Color',"#0000A2");
p.Marker = ".";
p.MarkerSize = 10;
hold on
r_min = 20;
step = 80;
r_max = 500;
r=r_min:step:r_max;
p = plot(r.^2+numOutputs_MIMO*r+numInputs_MIMO*r+numOutputs_MIMO*numInputs_MIMO, (SDR_MIMO), 'Color',"#BC272D");
p.Marker = ".";
p.MarkerSize = 10;
hold on
r_min = 20;
step = 80;
r_max = 500;
r=r_min:step:r_max;
p = plot(r.^2+numOutputs_ULA*r+numInputs_ULA*r+numOutputs_ULA*numInputs_ULA, (SDR_ULA), 'Color', "#E9C716");
p.Marker = ".";
p.MarkerSize = 10;
xl = xline(size_SISO*numOutputs_SISO*numInputs_SISO,'-',{'Original','File','Space'});
xl.Color = "#0000A2";
xl = xline(size_MIMO*numOutputs_MIMO*numInputs_MIMO,'-',{'Original','File','Space'});
xl.Color = "#BC272D";
xl = xline(size_ULA*numOutputs_ULA*numInputs_ULA,'--',{'Original','File','Space'});
xl.LabelHorizontalAlignment = 'left';
xl.Color = "#E9C716";
legend({'HOM SISO','HOM MIMO', 'ULA'}, 'Location','southeast');
xlabel('Occupied space');
ylabel('SDR(dB)');
xlim([0 256000])
title("SDR vs Occupied Space of SISO, MIMO and ULA");
saveas(gcf, "..\data\images\PNGs\SDRvsOccupiedSpace_SISO_MIMO_ULA.png", 'png');
savefig("..\data\images\Fig\SDRvsOccupiedSpace_SISO_MIMO_ULA");