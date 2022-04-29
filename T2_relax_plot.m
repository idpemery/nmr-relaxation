clc
clear

 % This script fits decay curves from T2 relaxation experiments and %
% plots the final R1 value per residue to yield a relaxation profile %

% "vc_times.txt" contains list of delays (in ms) NOT counters
tms = importdata('vc_times.txt');
t = transpose(tms ./ 1000);

% peaks is the list of residue numbers for which you have assignment/relaxation data
peaks = importdata('peaklist.txt');
raw_data = importdata('T2_ints.txt');
data = raw_data ./ 10e9;

% T2 = params(1)
% I0 = params(2)

fit_array = zeros(length(t), length(peaks));
T2_array = zeros(length(peaks), 1);
for i = 1:length(peaks)

    guess = [0.2, 1];
    output = lsqcurvefit(@T2fit, guess, t, data(:,i));
    fit = T2fit(output, t);
    T2 = round(output(1), 6);

    fit_array(:,i) = fit;
    T2_array(i) = abs(T2);

    res = data - fit_array;
end

% plot a handful of decay curves for quality control %
for j = 1:15:length(peaks)

    figure(j);
    plot(t, data(:,j), 'ko', t, fit_array(:,j), 'k-');
    title(['residue number' ,num2str(peaks(j)), ' T2 sample']);
    ylabel('intensity (au)');
    %xlim([0, 400]);
    %ylim([0, 1]);

    text(0.35, 100000, ['T2 = ' (num2str(T2_array(j))) ' sec^{-1}'], 'HorizontalAlignment', 'center');

end

%calculate R2 (1/sec)
R2_array = 1 ./ T2_array;

R2_out = [peaks, R2_array];

% save R2 data to text file
save('protein_R2.txt', 'R2_out', '-ascii', '-tabs');

%% plotting stuff %%
figure(111);
plot(peaks, T2_array, 'bo', peaks, T2_array, 'k-');
ylim([0, 0.4]);
xlim([25, 170]);
title('T2 data');
xlabel('residue');
ylabel('T2 (sec)');
saveas(figure(111), 'protein_T2.png');
