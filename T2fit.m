function relax_fit_T2 = T2fit(params, t)

% T2 fitting model came from page 294 of Keeler
%
% Use with "T2_relax_plot.m" script to fit T2 relaxation data
% (after parsing with "relax_parse.m")
%
% T2 = params(1)
% I0 = params(2)

relax_fit_T2 = (params(2) .* exp(-t ./ abs(params(1))));

end
