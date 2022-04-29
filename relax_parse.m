clc
clear

  % generates an array of the combined intensity columns for all delays %
 % pwd should contain .txt files outputted from Sparky (headers are ok) %
% ie, the file containing peak heights for the 250 ms timepoint is called %
                            % 250ms.txt %
% follow the above naming scheme when saving the peak heights in Sparky %
   % formatted such that columns are delays and rows are residues %

% t is delay time (in seconds); should be in increasing order
t = importdata('vd_list_ord.txt');
% peaks is the list of residue numbers for which you have assignment/relaxation data
peaks = importdata('peaklist_v1.txt');

data = zeros(length(peaks), length(t));
for i = 1:length(t)

    filename = sprintf('%dms.txt', t(i));
    temp = readtable(filename);
    ints = table2array(temp(:, end));

    data(:,i) = ints;
end

t1data = transpose(data);

% uncomment the following line to save table of ints as text file
%save('t1_ints.txt', 't1data', '-ascii', '-tabs');
