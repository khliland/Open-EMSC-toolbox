function [EMSCModel_extended]=add_spec_to_mod(EMSCModel,AddSpec,option);
%add_spec_to_mod             [EMSCModel_extended]=add_spec_to_mod(EMSCModel,AddSpec,option)
%
%                             'adds spectra to the EMSCModel (option is
%                             defined below) '
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Achim Kohler                                                                        %
%  Center for Biospectroscopy and Data Modelling                                       %
%  Matforsk                                                                            %
%  Norwegian Food Research Institute                                                   %
%  Osloveien 1                                                                         %
%  1430 Ås                                                                             %
%  Norway                                                                              %
%                                                                                      %
%  12.03.05                                                                            %
%                                                                                      %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%  function [EMSC]=add_spec_to_mod(EMSCModel,AddSpec,option);                          %
%                                                                                      %
%  Add spectra to the emsc modell                                                      %
%                                                                                      %
%                                                                                      %
%  Input:   EMSC modell functions (in EMSCModel structure)                             %
%           spectra as columns
%           AddSpec (good or bad spectra)
%           option=1: good spectra (if not stated default is 1)                        %
%           option=2: bad spectra                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:  EMSCModel structure extended by good spectra                               %
%           The EMSCModel structure contains the model with the following order:       %
%           [basic model functions,good spectra, bad spectra]                          %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




if (nargin==2)
    Option=1;   % default is good spectra
elseif (nargin==3)
    Option=option;
end

NgoodSpec=0;
NbadSpec=0;

if (Option==1)   % good spectra before bad spectra if present
    MModel=(EMSCModel.Model);
    BadSpectra=[];
    GoodSpectra=[];
    BasicModel=MModel(:,1:EMSCModel.NumBasicModelFunc);
    if (EMSCModel.NbadSpec>0)
        i1=EMSCModel.NumBasicModelFunc+EMSCModel.NgoodSpec+1;
        i2=EMSCModel.NumBasicModelFunc+EMSCModel.NgoodSpec+EMSCModel.NbadSpec;
        BadSpectra=MModel(:,i1:i2);
    end
    if (EMSCModel.NgoodSpec>0)
        i1= EMSCModel.NumBasicModelFunc+1;
        i2= EMSCModel.NumBasicModelFunc+EMSCModel.NgoodSpec;
        GoodSpectra= MModel(:,i1:i2);
    end

    MModel=[];
    MModel=[BasicModel,GoodSpectra,AddSpec,BadSpectra];
    
    [L,O]=size(AddSpec');
    NgoodSpec=EMSCModel.NgoodSpec+L;

elseif (Option==2) % bad spectra at the end
    MModel=(EMSCModel.Model);
    MModel=[MModel,AddSpec];
    [L,O]=size(AddSpec');
    NbadSpec=EMSCModel.NbadSpec+L
end


[L,O]=size(MModel');

EMSCModel_extended.Model=MModel;
EMSCModel_extended.NgoodSpec=NgoodSpec;          % N of good spectra  
EMSCModel_extended.NumBasicModelFunc=EMSCModel.NumBasicModelFunc;  % this defines the order of basic mod func
EMSCModel_extended.NbadSpec=NbadSpec;           % and bad spectra in Modell function
EMSCModel_extended.NModelFunc=L;         % total number of model functions
EMSCModel_extended.ModelVariables=EMSCModel.ModelVariables;


