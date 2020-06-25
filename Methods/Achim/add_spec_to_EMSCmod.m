function [EMSCModel_extended]=add_spec_to_EMSCmod(EMSCModel,ZAddSpec,option);
%add_spec_to_mod             [EMSCModel_extended]=add_spec_to_EMSCmod(EMSCModel,AddSpec,option)
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
%           AddSpec (saisir structure, good or bad spectra)
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


AddSpec=ZAddSpec.d';

if (nargin==2)
    Option=1;   % default is good spectra
elseif (nargin==3)
    Option=option;
end

NgoodSpec=EMSCModel.NgoodSpec;
NbadSpec=EMSCModel.NbadSpec;

if (Option==1)   % put good spectra before bad spectra if present
    MModel=(EMSCModel.Model);
    BadSpectra=[]; BadSpectraNames=[];
    GoodSpectra=[]; GoodSpectraNames=[];
    
    BasicModel=MModel(:,1:EMSCModel.NumBasicModelFunc);
    BasicModNames=EMSCModel.ModelSpecNames(1:EMSCModel.NumBasicModelFunc,:);
    BasicModNames=addspace(BasicModNames,16,1);
    % Select the bad spectra from the old model
    if (EMSCModel.NbadSpec>0)
        i1=EMSCModel.NumBasicModelFunc+EMSCModel.NgoodSpec+1;
        i2=EMSCModel.NumBasicModelFunc+EMSCModel.NgoodSpec+EMSCModel.NbadSpec;
        BadSpectra=MModel(:,i1:i2);
        BadSpectraNames=EMSCModel.ModelSpecNames(i1:i2,:);
        BadSpectraNames=addspace(BadSpectraNames,16,1);
        
    end
    % Select the bad spectra from the old model
    if (EMSCModel.NgoodSpec>0)
        i1= EMSCModel.NumBasicModelFunc+1;
        i2= EMSCModel.NumBasicModelFunc+EMSCModel.NgoodSpec;
        GoodSpectra= MModel(:,i1:i2);
        GoodSpectraNames=EMSCModel.ModelSpecNames(i1:i2,:);
        GoodSpectraNames=addspace(GoodSpectraNames,16,1);
    end

    % Establish the new model
    MModel=[];
    MModel=[BasicModel,GoodSpectra,AddSpec,BadSpectra];
    
    
    AddSpectraNames=addspace(ZAddSpec.i,16,1);
    ModelSpecNames=[BasicModNames,
                    GoodSpectraNames,
                    AddSpectraNames,
                    BadSpectraNames];
    
    [L,O]=size(AddSpec');
    NgoodSpec=NgoodSpec+L;

elseif (Option==2) % put bad spectra at the end
    MModel=(EMSCModel.Model);
    MModel=[MModel,AddSpec];
    
    ModelNamesOld=addspace(EMSCModel.ModelSpecNames,16,1);
    AddSpectraNames=addspace(ZAddSpec.i,16,1);
    
    ModelSpecNames=[ModelNamesOld,
                    AddSpectraNames];
    
    [L,O]=size(AddSpec');
    NbadSpec=NbadSpec+L;
else
     error('Option not correct');
 
end


[L,O]=size(MModel');
EMSCModel_extended=EMSCModel;
EMSCModel_extended.ModelSpecNames=ModelSpecNames;
EMSCModel_extended.Model=MModel;
EMSCModel_extended.NgoodSpec=NgoodSpec;          % N of good spectra  
EMSCModel_extended.NumBasicModelFunc=EMSCModel.NumBasicModelFunc;  % this defines the order of basic mod func
EMSCModel_extended.NbadSpec=NbadSpec;           % and bad spectra in Modell function
EMSCModel_extended.NModelFunc=L;         % total number of model functions
EMSCModel_extended.ModelVariables=EMSCModel.ModelVariables;


