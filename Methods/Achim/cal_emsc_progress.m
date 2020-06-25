function [ZCorrected,ZResiduals,ZParameters]=cal_emsc_progress(ZSaisir,EMSCModel,h,ZWeights)
%cal_emsc  [ZCorrected,ZResiduals,ZParameters]=cal_emsc(ZSaisir,EMSCModel,ZWeights)
%
%           'runs EMSC on ZSaisir using the EMSCModel defined by make_emsc_modfunc
%           model functions can be added to EMSCModel by add_spec_to_mod'
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
%  function [ZCorrected,ZResiduals,ZParameters]=run_emsc(ZSaisir,EMSCModel,ZWeights)     %
%                                                                                      %
%  Runs emsc using emsc basic model fucntions and constituent difference spectra       %
%                                                                                      %
%                                                                                      %
%  Input:   ZSaisir: saisire structure                                                 %
%           EMSC modell functions (in EMSC structure)                                  %                      
%           ZWeights: saisire structure
%
%                                                                                      %
%  Output:  saisir structures for ZCorrected,ZResiduals,ZParameters                    %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% check if model functions and spectra have the same dimensions
    [NZ MZ]=size(ZSaisir.d);
    [NE ME]=size(EMSCModel.ModelVariables);
    if (MZ~=NE)
        error('model functions and spectra do not have the same dimensions')
    end

%% use weights in case they are defined:
    if (nargin==4) 
        ZSaisirSel=ZSaisir;
        [WN,WM]=size(ZWeights.d);
        if (WN>1)
            for i=1:NZ
                %% ???????????????????????????????????????????????????????
                ZSaisirSel.d(i,:)=ZSaisir.d(i,:).*ZWeights.d(2,:);  %%???
            end
        else
            for i=1:NZ
                ZSaisirSel.d(i,:)=ZSaisir.d(i,:).*ZWeights.d;
            end
        end
        
        
    elseif (nargin==3)
        ZSaisirSel=ZSaisir;
    else
        error('number of input parameters not correct')
    end    
    
%% initialise and weight the model    
    [Nx Ny]=size(ZSaisir.d);
    waitbar(0,h,['Correcting spectra (' num2str(0) '%)']);
    Residuals=zeros(Nx,Ny);
    Corrected=zeros(Nx,Ny);
    [N M]=size(EMSCModel.Model);
    Parameters=zeros(Nx,M);
    Model=EMSCModel.Model;
    if (nargin==4) 
        [WN,WM]=size(ZWeights.d);
        if (WN>1)
            for i=1:M
                %% ???????????????????????????????????????????????????????
                Model(:,i)=EMSCModel.Model(:,i).*ZWeights.d(i,:)';  %%??????
            end
        else
            for i=1:M
                Model(:,i)=EMSCModel.Model(:,i).*ZWeights.d';
            end
        end
    elseif (nargin==3)
        Model=EMSCModel.Model;
    else
        error('number of input parameters not correct')
    end   
    
    
    upd = round(1:(Nx-1)/99:Nx);
    for i=1:Nx
        [ism,prc] = ismember(i,upd);
        if ism
            waitbar(i,h,['Correcting spectra (' num2str(prc) '%)']);
        end
        
         ZTemp=ZSaisirSel.d(i,:);
         if (max(abs(ZTemp))==0)
             P=[];
         else
            P = lscov(Model,ZTemp');
         end
         ZTemp=ZSaisir.d(i,:);
         CorrectedTemp=ZTemp;
         if (~isempty(P))
             for k=1:(EMSCModel.NumBasicModelFunc-1)   % last modell function is m
                 ModFunc=(EMSCModel.Model(:,k))';
                 CorrectedTemp=CorrectedTemp-ModFunc.*P(k);
             end
             if (EMSCModel.NbadSpec>0)
                 for k=(EMSCModel.NumBasicModelFunc+EMSCModel.NgoodSpec+1):M   % bad spectra
                     ModFunc=(EMSCModel.Model(:,k))';
                     CorrectedTemp=CorrectedTemp-ModFunc.*P(k);
                 end
             end
             CorrectedTemp=CorrectedTemp./P(EMSCModel.NumBasicModelFunc); % correct multipl. eff.
             Corrected(i,:)=CorrectedTemp;

             ResidualsTemp=ZTemp;            
             for k=1:M
                 ModFunc=(EMSCModel.Model(:,k))';
                 ResidualsTemp=ResidualsTemp-ModFunc.*P(k);
             end
         
             Corrected(i,:)=CorrectedTemp;
             Residuals(i,:)=ResidualsTemp;
             Parameters(i,:)=P;
             
         else
             Corrected(i,:)=CorrectedTemp;
             Residuals(i,:)=0;
             Parameters(i,:)=0;
         end
             
    end
    
    % put the sets in saisir structures
%     ZCorrected=matrix2saisir(Corrected);
    ZCorrected.d = Corrected;
    ZCorrected.v=ZSaisir.v;
    [N M]=size(ZCorrected.d);
    ZCorrected.i=ZSaisir.i;
    
%     ZResiduals=matrix2saisir(Residuals);
    ZResiduals.d = Residuals;
    ZResiduals.v=ZSaisir.v;
    [N M]=size(ZResiduals.d);
    ZResiduals.i=ZSaisir.i;
    
    ZParameters=matrix2saisir(Parameters);
    ZParameters.v=EMSCModel.ModelSpecNames;
    ZParameters.i=ZSaisir.i;
    [N M]=size(ZParameters.d);


    

    

end