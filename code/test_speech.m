%% application of RIRs to speech signals
clear
close all

%% test speech
[male_speech,Fs0] = audioread("..\data\audio\testAudio\male\male_speech.wav");
[female_speech,Fs1] = audioread("..\data\audio\testAudio\female\female_speech.wav");

% resample at 8kHz
Fs_sub = 8000;
male_speech = resample(male_speech, Fs_sub, Fs0);
female_speech = resample(female_speech, Fs_sub, Fs1);

audiowrite("..\data\audio\testAudio\male\male_8000.wav", male_speech, Fs_sub);
audiowrite("..\data\audio\testAudio\female\female_8000.wav", female_speech, Fs_sub);

%%
destinationFolder = '..\data\audio\testAudio';
%% HOM
[RIR_matrix(:,:,1),Fs] = audioread("..\data\audio\original_RIR\rir-S1-R2-HOM1.wav");
[RIR_matrix(:,:,2),Fs] = audioread("..\data\audio\original_RIR\rir-S2-R2-HOM1.wav");

%% SISO no ERA
% y_sub: ground truth
[~, y_sub, ~] = rir_preprocessing(RIR_matrix(:,1,1),0);
% convolution
result_male = conv(male_speech,y_sub);
result_female = conv(female_speech, y_sub);

file_male = fullfile(destinationFolder, 'male\SISO_noera_mono\test_SISO_noera_male.wav');
file_female = fullfile(destinationFolder, 'female\SISO_noera_mono\test_SISO_noera_female.wav');    
audiowrite(file_male, result_male, Fs_sub);
audiowrite(file_female, result_female, Fs_sub);

%% SISO with ERA
for r = [20, 60, 88, 160, 200]
    % compressed RIR
    [y,Fs] = audioread(strcat("..\data\audio\RIR_comp\RIR_comp_", num2str(r),".wav"));
    % convolution
    result_male = conv(y,male_speech);
    result_female = conv(y, female_speech);

    file_male = fullfile(destinationFolder, sprintf(strcat("male/SISO_mono/test_SISO_male_", num2str(r),".wav")));
    file_female = fullfile(destinationFolder, sprintf(strcat("female/SISO_mono/test_SISO_female_", num2str(r),".wav")));
    audiowrite(file_male, result_male, Fs_sub);
    audiowrite(file_female, result_female, Fs_sub);
end

%% MIMO no ERA (16 channels)
numInputs = size(RIR_matrix,3);
numOutputs = size(RIR_matrix,2);
% y_sub_MIMO: ground truth
[~, y_sub_MIMO, ~] = rir_preprocessing_MIMO(RIR_matrix, 0, numInputs, numOutputs);

for i =1:numOutputs
    for j = 1: numInputs
        % convolution
        result_male = conv(y_sub_MIMO(:,i,j),male_speech);
        result_female = conv(y_sub_MIMO(:,i,j),female_speech);
        
        file_male = fullfile(destinationFolder, sprintf('male/MIMO_noera_mono/test_MIMO_S%d_noera_male_%d.wav', j,i));
        file_female = fullfile(destinationFolder, sprintf('female/MIMO_noera_mono/test_MIMO_S%d_noera_female_%d.wav', j,i));
        audiowrite(file_male, result_male, Fs_sub);
        audiowrite(file_female, result_female, Fs_sub);
    end
end

%% MIMO Stereo no ERA (6th and 8th capsule)
input = 1;
channels = [6,8];
stereo_male = zeros(size(y_sub_MIMO,1)+size(male_speech,1)-1,2);
stereo_female = zeros(size(y_sub_MIMO,1)+size(female_speech,1)-1,2);
for i=channels
    % convolution
    result_male = conv(y_sub_MIMO(:,i,input),male_speech);
    result_female = conv(y_sub_MIMO(:,i,input),female_speech);
    stereo_male(:,i) = result_male;
    stereo_female(:,i) = result_female;
end
stereo_male = stereo_male(:,channels);
stereo_female = stereo_female(:,channels);

file_male_stereo = fullfile(destinationFolder, sprintf('male/MIMO_noera_stereo/test_MIMO_noera_male_stereo.wav'));
file_female_stereo = fullfile(destinationFolder, sprintf('female/MIMO_noera_stereo/test_MIMO_noera_female_stereo.wav'));
audiowrite(file_male_stereo, stereo_male, Fs_sub);
audiowrite(file_female_stereo, stereo_female, Fs_sub);

%% MIMO with ERA (first channel)
for r = [100, 200, 350, 500]
    % compressed RIR
    [y,Fs] = audioread(strcat("..\data\audio\RIR_comp\RIR_comp_MIMO_S1_", num2str(r),".wav"));
    y1 = y(:,1,1);
    % convolution
    result_male = conv(y1,male_speech);
    result_female = conv(y1, female_speech);

    file_male = fullfile(destinationFolder, sprintf(strcat("male/MIMO_mono/test_MIMO_S1_male_", num2str(r),".wav")));
    file_female = fullfile(destinationFolder, sprintf(strcat("female/MIMO_mono/test_MIMO_S1_female_", num2str(r),".wav")));
    audiowrite(file_male, result_male, Fs_sub);
    audiowrite(file_female, result_female, Fs_sub);
end

%% MIMO Stereo with ERA (6th and 8th capsule)
input = 1;
channels = [6,8];
for r = [100, 200, 350, 500]
    % compressed RIR
    [y,Fs] = audioread(strcat("..\data\audio\RIR_comp\RIR_comp_MIMO_S1_", num2str(r),".wav"));
    stereo_male = zeros(size(y,1)+size(male_speech,1)-1,2);
    stereo_female = zeros(size(y,1)+size(female_speech,1)-1,2);
    for i=channels
        % convolution
        result_male = conv(y(:,i,input),male_speech);
        result_female = conv(y(:,i,input),female_speech);
        stereo_male(:,i) = result_male;
        stereo_female(:,i) = result_female;
    end
    stereo_male = stereo_male(:,channels);
    stereo_female = stereo_female(:,channels);
    
    file_male_stereo = fullfile(destinationFolder, sprintf('male/MIMO_stereo/test_MIMO_S1_male_stereo_%d.wav',r));
    file_female_stereo = fullfile(destinationFolder, sprintf('female/MIMO_stereo/test_MIMO_S1_female_stereo%d.wav',r));
    audiowrite(file_male_stereo, stereo_male, Fs_sub);
    audiowrite(file_female_stereo, stereo_female, Fs_sub);
end

%% ULA
[RIR_matrix_ULA(:,:,1),Fs] = audioread("..\data\audio\original_RIR\rir-S1-ULA.wav");
[RIR_matrix_ULA(:,:,2),Fs] = audioread("..\data\audio\original_RIR\rir_S2-ULA.wav");

%% MIMO no ERA (16 channels)
numInputs = size(RIR_matrix_ULA,3);
numOutputs = 8;
% y_sub_MIMO: ground truth
[~, y_sub_MIMO, ~] = rir_preprocessing_MIMO(RIR_matrix_ULA(:,1:numOutputs,:), 0, numInputs, numOutputs);

for i =1:numOutputs
    for j = 1: numInputs
        % convolution
        result_male = conv(y_sub_MIMO(:,i,j),male_speech);
        result_female = conv(y_sub_MIMO(:,i,j),female_speech);
        % normalization
        result_male = 10 * result_male ./ norm(result_male, "fro");
        result_female = 10 * result_female ./ norm(result_female, "fro");
       
        file_male = fullfile(destinationFolder, sprintf('male/ULA_MIMO_noera_mono/test_MIMO_ULA_S%d_noera_male_%d.wav', j,i));
        file_female = fullfile(destinationFolder, sprintf('female/ULA_MIMO_noera_mono/test_MIMO_ULA_S%d_noera_female_%d.wav', j,i));
        audiowrite(file_male, result_male, Fs_sub);
        audiowrite(file_female, result_female, Fs_sub);
    end
end

%% MIMO Stereo no ERA (1st and 8th capsule)
input = 1;
channels = [1,8];
stereo_male = zeros(size(y_sub_MIMO,1)+size(male_speech,1)-1,2);
stereo_female = zeros(size(y_sub_MIMO,1)+size(female_speech,1)-1,2);
for i=channels
    % convolution
    result_male = conv(y_sub_MIMO(:,i,input),male_speech);
    result_female = conv(y_sub_MIMO(:,i,input),female_speech);
    % normalization
    result_male = 10* result_male ./ norm(result_male, "fro");
    result_female = 10 * result_female ./ norm(result_female, "fro");
    stereo_male(:,i) = result_male;
    stereo_female(:,i) = result_female;
end
stereo_male = stereo_male(:,channels);
stereo_female = stereo_female(:,channels);

file_male_stereo = fullfile(destinationFolder, sprintf('male/ULA_MIMO_noera_stereo/test_ULA_MIMO_noera_male_stereo.wav'));
file_female_stereo = fullfile(destinationFolder, sprintf('female/ULA_MIMO_noera_stereo/test_ULA_MIMO_noera_female_stereo.wav'));
audiowrite(file_male_stereo, stereo_male, Fs_sub);
audiowrite(file_female_stereo, stereo_female, Fs_sub);

%% MIMO with ERA (first channel)
for r = [100, 200, 350, 500]
    % compressed RIR
    [y,Fs] = audioread(strcat("..\data\audio\RIR_comp\RIR_comp_MIMO_ULA_S1_", num2str(r),".wav"));
    y1 = y(:,1,1);
    % convolution
    result_male = conv(y1,male_speech);
    result_female = conv(y1, female_speech);
    % normalization
    result_male = 10* result_male ./ norm(result_male, "fro");
    result_female = 10* result_female ./ norm(result_female, "fro");
    
    file_male = fullfile(destinationFolder, sprintf(strcat("male/ULA_MIMO_mono/test_MIMO_ULA_S1_male_", num2str(r),".wav")));
    file_female = fullfile(destinationFolder, sprintf(strcat("female/ULA_MIMO_mono/test_MIMO_ULA_S1_female_", num2str(r),".wav")));
    audiowrite(file_male, result_male, Fs_sub);
    audiowrite(file_female, result_female, Fs_sub);
end

%% MIMO Stereo with ERA (1st and 8th capsule)
input = 1;
channels = [1,8];
for r = [100, 200, 350, 500]
    % compressed RIR
    [y,Fs] = audioread(strcat("..\data\audio\RIR_comp\RIR_comp_MIMO_ULA_S1_", num2str(r),".wav"));
    stereo_male = zeros(size(y,1)+size(male_speech,1)-1,2);
    stereo_female = zeros(size(y,1)+size(female_speech,1)-1,2);
    for i=channels
        % convolution
        result_male = conv(y(:,i,input),male_speech);
        result_female = conv(y(:,i,input),female_speech);
        % normalization
        result_male = 10 * result_male ./ norm(result_male, "fro");
        result_female = 10 * result_female ./ norm(result_female, "fro");

        stereo_male(:,i) = result_male;
        stereo_female(:,i) = result_female;
    end
    stereo_male = stereo_male(:,channels);
    stereo_female = stereo_female(:,channels);

    file_male_stereo = fullfile(destinationFolder, sprintf('male/ULA_MIMO_stereo/test_MIMO_ULA_S1_male_stereo_%d.wav',r));
    file_female_stereo = fullfile(destinationFolder, sprintf('female/ULA_MIMO_stereo/test_MIMO_ULA_S1_female_stereo%d.wav',r));
    audiowrite(file_male_stereo, stereo_male, Fs_sub);
    audiowrite(file_female_stereo, stereo_female, Fs_sub);
end