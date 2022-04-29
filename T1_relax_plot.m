clc
clear

   % This script fits decay curves from T1 relaxation experiments and %
  % plots the final R1 value per residue to yield a relaxation profile %

% "vd_list_ord.txt" contains list of delays (in ms)
tms = importdata('vd_list_ord.txt');
t = tms ./ 1000;

% peaks is the list of residue numbers for which you have assignment/relaxation data
peaks = importdata('peaklist_v1.txt');
raw_data = importdata('T1_ints.txt');
data = raw_data ./ 10e9;

% T1 = params(1)
% I0 = params(2)

fit_array = zeros(length(t), length(peaks));
T1_array = zeros(length(peaks), 1);
for i = 1:length(peaks)

    guess = [1, max(data(:,i))];
    output = lsqcurvefit(@T1fit, guess, t, data(:,i));
    fit = T1fit(output, t);
    T1 = round(output(1), 6);

    fit_array(:,i) = fit;
    T1_array(i) = abs(T1);

end

% plot a handful of decay curves for quality control
for j = 1:15:length(peaks)

    figure(j);
    plot(t, data(:,j), 'ko', t, fit_array(:,j), 'k-');
    title(['residue number' ,num2str(peaks(j)), ' T1 sample']);
    ylabel('intensity (au)');
    %xlim([0, 400]);
    %ylim([0, 1]);

    text(0.35, 100000, ['T1 = ' (num2str(T1_array(j))) ' sec^{-1}'], 'HorizontalAlignment', 'center');

end

%calculate R1 (1/sec)
R1_array = 1 ./ T1_array;

R1_out = [peaks, R1_array];

% save R1 data to text file
save('protein_R1.txt', 'R1_out', '-ascii', '-tabs');

%% plotting stuff (I got lazy because ultimately I will just export the data as
%   a text file and replot in python)
plot(peaks, T1_array, 'bo', peaks, T1_array, 'k-');
