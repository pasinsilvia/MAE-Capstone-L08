%% EDR
% calculate Energy Decay Relief of signal y
function edr = EDR (y,Fs)
    %% parameters
    y = y./norm(y,"fro");
    M = 128; % dimension time window
    L = 127; % overlap
    g = hann(M); % window
    Ndft = 2048; % dimension frequency window
    [H,f,t] = spectrogram(y,g,L,Ndft, Fs);
    H2 = abs(H.^2);
    
    %% EDR
    edr = fliplr(cumsum(fliplr(H2), 2));
    edr = 10*log10(edr);
    figure
    imagesc(t(1:end), f, edr);
    set(gca,'YDir','normal')
    title('Energy Decay Rate');
    xlabel('Time (s)'); 
    ylabel('Frequency (Hz)'); 
end
