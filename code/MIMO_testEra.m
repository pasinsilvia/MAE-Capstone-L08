%% application of ERA (MIMO HOM) saving the compressed RIRs
clear
close all

%% MIMO parameters
numInputs = 2;
numOutputs = 8;
plot_edc = 0;
Fs_sub = 8000;

%% original RIR
[RIR_matrix(:,:,1),Fs] = audioread("..\data\audio\original_RIR\rir-S1-R2-HOM1.wav");
[RIR_matrix(:,:,2),Fs] = audioread("..\data\audio\original_RIR\rir-S2-R2-HOM1.wav");

%% preprocessing on original matrix
% y_sub: GROUND TRUTH signal
% y: signal pre-ERA
% max_index: index of maximum
[y, y_sub, max_index] = rir_preprocessing_MIMO(RIR_matrix, plot_edc, numInputs, numOutputs);

%% application of ERA with different r
YY = permute(y,[2 3 1]);
mco = floor((length(YY)-1)/2);
for rr = [100, 200, 350, 500]
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
        end
    end
    %figure
    %stairs(y_sub(:,1,1) ./ norm(y_sub(:,1,1) , "fro"),'LineWidth',2);
    %hold on
    %stairs(y2(:,1,1),'LineWidth',1.2); 

    % save RIRs
    audiowrite(strcat("..\data\audio\RIR_comp\RIR_comp_MIMO_S1_", num2str(rr), ".wav"), y2(:,:,1), Fs_sub);
    audiowrite(strcat("..\data\audio\RIR_comp\RIR_comp_MIMO_S2_", num2str(rr), ".wav"), y2(:,:,2), Fs_sub);
end     