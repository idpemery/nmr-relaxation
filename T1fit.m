function relax_fit_T1 = T1fit(params, t)

% T1 fitting model came from page 294 of Keeler
%
% Use with "T1_relax_plot.m" script to fit T1 relaxation data
% (after parsing with "relax_parse.m")
%
% T1 = params(1)
% I0 = params(2)

relax_fit_T1 = (params(2) .* exp(-t ./ abs(params(1))));

end
