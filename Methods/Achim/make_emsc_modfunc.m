function [EMSC]=make_emsc_modfunc(Zsaisir,option)
%make_emsc_modfunc   [EMSC]=make_emsc_modfunc(Zsaisir,option)
%
%  Establishes the basic EMSC model without any extensions in addition to
%  polynomials
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Achim Kohler                                                                        %
%  Center for Biospectroscopy and Data Modelling                                       %
%  Nofima Mat                                                                          %
%  Norwegian Food Research Institute                                                   %
%  Osloveien 1                                                                         %
%  1430 Ås                                                                             %
%  Norway                                                                              %
%                                                                                      %
%  12.03.05                                                                            %
%  18.03.09 short revision                                                             %                                                                                      %
%                                                                                      %
%  todo: normalise polynomial functions (not really necessary)                         %
%                                                                                      %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%  function [EMSC]=make_emsc_modfunc(Zsaisir,option);                                  %
%                                                                                      %
%  option=0: only baseline (no MSC/EMSC)                                               %
%  If option is not defined or 1: default is EMSC with linear and quadratic effect     %
%  option=2: MSC plus linear                                                           %
%  option=3: MSC                                                                       %
%  option=4: EMSC + cubic                                                              % 
%  option=5: EMSC + cubic + fourth order                                               % 
%  option=6: EMSC + cubic + fourth order + fifth order (not defined)                   % 
%  option=7: EMSC + cubic + fourth order + fifth order + sixth order                   %
%                                                                                      %
%  MeanScaling: Scale the Mean spectrum to the same size as the other basic EMSC par.  %                                                                                     %
%                                                                                      %
%                                                                                      %
%  Creates the basic emsc modell fucntions:                                            %
%  baseline,linear,quadratic,reference (in this oder)                                  %
%                                                                                      %
%                                                                                      %
%  Input:   Zsaisir                                                                    %
%                                                                                      %
%  Output:  EMSC structure with modell functions (see def. at end of file)             % 
%                                                                                      %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MeanScaling=0;


% check the input
if (nargin==1)
    %default: all model function
    Option=1;
elseif (nargin==2)
    Option=option;
end


%% Calculate the basic model functions
[Nx Ny]=size(Zsaisir.d);
WaveNum=str2num(Zsaisir.v);
Start=WaveNum(1);
End=WaveNum(Ny);

C=0.5*(Start+End);
M0=2.0/(Start-End);
M=4.0/((Start-End)*(Start-End));

WaveNumT    = WaveNum';
Baseline    = ones(1,Ny);
Mean=mean(Zsaisir.d,1);

%% If necessary the mean spectrum can be scaled here! 
if (MeanScaling)
    MaxVal=max(Mean);
    MinVal=min(Mean);
    Mean=Mean/(MaxVal-MinVal);
end

%% collect the basic model functions
if (Option==0)
    MModel=Baseline;
    ModelSpecNames='Baseline        ';
elseif (Option==1)
    Linear      = M0*(Start-WaveNumT)-1;
    Quadratic   = M*(WaveNumT-C).^2;
    MModel=[Baseline;Linear;Quadratic;Mean];
    ModelSpecNames=['Baseline        '; ...
        'Linear          '; ...
        'Quadratic       '; ...
        'Reference       '];
elseif (Option==2)
    Linear      = M0*(Start-WaveNumT)-1;
    MModel=[Baseline;Linear;Mean];
    ModelSpecNames=['Baseline        '; ...
        'Linear          '; ...
        'Reference       '];
elseif (Option==3)
    MModel=[Baseline;Mean]; % MSC
    ModelSpecNames=['Baseline        '; ...
        'Reference       '];
elseif (Option==4)
    Linear      = M0*(Start-WaveNumT)-1;
    Quadratic   = M*(WaveNumT-C).^2;
    Cubic       = M*(1/(Start-End))*(WaveNumT-C).^3;
    MModel=[Baseline;Linear;Quadratic;Cubic;Mean];
    ModelSpecNames=['Baseline        '; ...
        'Linear          '; ...
        'Quadratic       '; ...
        'Cubic           '; ...
        'Reference       '];
elseif (Option==5)
    Linear      = M0*(Start-WaveNumT)-1;
    Quadratic   = M*(WaveNumT-C).^2;
    Cubic       = M*(1/(Start-End))*(WaveNumT-C).^3;
    FourthOrder = M*M*(WaveNumT-C).^4;
    MModel=[Baseline;Linear;Quadratic;Cubic;FourthOrder;Mean];
    ModelSpecNames=['Baseline        '; ...
        'Linear          '; ...
        'Quadratic       '; ...
        'Cubic           '; ...
        'fourth order    '; ...
        'Reference       '];
elseif (Option==6)
    Linear      = M0*(Start-WaveNumT)-1;
    Quadratic   = M*(WaveNumT-C).^2;
    Cubic       = M*(1/(Start-End))*(WaveNumT-C).^3;
    FourthOrder = M*M*(WaveNumT-C).^4;
    FifthOrder  = M*M*M0*(WaveNumT-C).^5;
    MModel=[Baseline;Linear;Quadratic;Cubic;FourthOrder;FifthOrder;Mean];
    ModelSpecNames=['Baseline        '; ...
        'Linear          '; ...
        'Quadratic       '; ...
        'Cubic           '; ...
        'fourth order    '; ...
        'fifth order     '; ...
        'Reference       '];
elseif (Option==7)
    Linear      = M0*(Start-WaveNumT)-1;
    Quadratic   = M*(WaveNumT-C).^2;
    Cubic       = M*(1/(Start-End))*(WaveNumT-C).^3;
    FourthOrder = M*M*(WaveNumT-C).^4;
    FifthOrder  = M*M*M0*(WaveNumT-C).^5;
    SixthOrder  = M*M*M*(WaveNumT-C).^6;
    MModel=[Baseline;Linear;Quadratic;Cubic;FourthOrder;FifthOrder;SixthOrder;Mean];
    ModelSpecNames=['Baseline        '; ...
        'Linear          '; ...
        'Quadratic       '; ...
        'Cubic           '; ...
        'fourth order    '; ...
        'fifth order     '; ...
        'sixth order     '; ...
        'Reference       '];
    
end
[L,O]=size(MModel);

EMSC.Model=MModel';
EMSC.ModelSpecNames=ModelSpecNames;
EMSC.NumBasicModelFunc=L;  % this defines the order of basic mod func
EMSC.NgoodSpec=0;          % Number of good spectra  
EMSC.NbadSpec=0;           % Number of bad spectra in Modell function
EMSC.NModelFunc=L;         % total number of model functions
EMSC.ModelVariables=Zsaisir.v;

