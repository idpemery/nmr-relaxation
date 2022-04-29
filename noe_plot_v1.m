clc
clear

% this script imports data from heteronuclear NOE intensity data %
  % and calculates hetNOE from saturated and unsaturated data %
% headers in the files are ok; take them directly from Sparky provided %
% the naming scheme matches: "noe4_sat.txt" and "noe4_unsat.txt" in reference %
% one of three hetNOE exeriments for which the Topspin expt number is "4" %

% list of residue numbers for which you have assignments and hetNOE data
peaks = importdata('peaklist_v1.txt');

% we collected hetNOE data in triplicate; the experiment numbers in Topspin
% were 4, 11, and 13 (for the unsplit data)
expnos = [4, 11, 13];

data = zeros(length(peaks), length(expnos));
for i = 1:length(expnos)
    file_unsat = sprintf('noe%d_unsat.txt', expnos(i));
    file_sat = sprintf('noe%d_sat.txt', expnos(i));
    temp_unsat = readtable(file_unsat);
    temp_sat = readtable(file_sat);
    unsat = table2array(temp_unsat(:, end));
    sat = table2array(temp_sat(:, end));
    rat = sat ./ unsat;

    data(:, i) = rat;

end

tdata = transpose(data);

% averages hetNOE across replicates and determines std.dev from the mean
ave_noe = mean(tdata);
std_ave = std(tdata);

noe_out = [peaks, transpose(ave_noe), transpose(std_ave)];

%% plotting stuff %%
hold on
figure(1);
plot(peaks, ave_noe, 'bo', peaks, ave_noe, 'k-');
errorbar(peaks, ave_noe, std_ave, 'k');
xlabel('residue');
title('hetNOE averages');
ylabel('NOE');

% uncomment the following lines to save plot and text file of the plotted values
%saveas(figure(1), 'protein_NOE.png');
%save('protein_noe.txt', 'noe_out', '-ascii', '-tabs');
