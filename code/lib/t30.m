%% t30
% calculate t30 of signal y
% flag == 1 to plot EDC
function [cutoff_sample] = t30(y, flag)

h2 = y.^2; 
cs = cumsum(h2);
edc = h2 + cs(end) - cs;
edc_db = 10.*log10(edc);
if(flag==1)
    figure;
    plot(edc_db);
    title("Energy decay curve of signal");
end
index_5 = find(edc_db<-5, 1);
index_35 = find(edc_db<-35,1);
cutoff_sample = (index_35-index_5)*2;
end