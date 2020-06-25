function spectra = preprocess(spectra, method, parameter, variables)
%% Perform preprocessing on spectra
% Method:
%    0 Flip left/right
%    1 Reflectance to absorbance
%    2 Derivative
%    3 Normalize
%    4 SNV
%    5 MSC
%    6 EMSC
%    7 Poly. baseline
%    8 ALS baseline

if method == 1
    spectra = fliplr(spectra);
elseif method == 2
    spectra = reflectanceToAbsorbance(spectra);
elseif method == 3
    spectra = derivative(spectra,parameter);
elseif method == 4
    spectra = normalizeSpectra(spectra);
elseif method == 5
    spectra = SNV(spectra);
elseif method == 6
    spectra = EMSC(spectra,3,num2str(variables));
elseif method == 7
    %  option=0: only baseline (no MSC/EMSC)                                               %
    %  If option is not defined or 1: default is EMSC with linear and quadratic effect     %
    %  option=2: MSC plus linear                                                           %
    %  option=3: MSC                                                                       %
    %  option=4: EMSC + cubic                                                              %
    %  option=5: EMSC + cubic + fourth order                                               %
    %  option=6: EMSC + cubic + fourth order + fifth order (not defined)                   %
    %  option=7: EMSC + cubic + fourth order + fifth order + sixth order
    if parameter > 2
        par = parameter+1;
    elseif parameter == 2
        par = 1;
    elseif parameter == 1
        par = 2;
    end
    spectra = EMSC(spectra,par,num2str(variables));
elseif method == 8
    % Polynomial baseline correction
    spectra = subbackmod(spectra, variables', parameter, 0.01, 0);
elseif method == 9
    % ALS baseline correction
    baseline = als_baseline(spectra,parameter,0.05);
    spectra = spectra-baseline;
end