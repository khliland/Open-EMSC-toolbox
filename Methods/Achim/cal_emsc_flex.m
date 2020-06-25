function [ZCorrected,ZResiduals,ZParameters]=cal_emsc_flex(ZSaisir,EMSCModel,varargin)
%cal_emsc  [ZCorrected,ZResiduals,ZParameters]=cal_emsc_flex(ZSaisir,EMSCModel,varargin)
%
% KHL rewrite and extension of Achims code.
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


%% Extra arguments and defaults
names = {'ZWeights' 'WavelengthCovariance' 'RankReduce' 'WaveDepScatCoef' 'AbsorbDepScatCoef'};
dflts = {     false              false            false             false               false};

[ZWeights, WavelengthCovariance, RankReduce, WaveDepScatCoef, AbsorbDepScatCoef] = match_arguments(names,dflts,varargin{:});



%% check if model functions and spectra have the same dimensions
    [NZ, MZ]=size(ZSaisir.d);
    [NE, ~]=size(EMSCModel.ModelVariables);
    if (MZ~=NE)
        error('model functions and spectra do not have the same dimensions')
    end

%% use weights in case they are defined:
    if ~islogical(ZWeights)
        ZSaisirSel=ZSaisir;
        [WN,~]=size(ZWeights.d);
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
        
        
    else
        ZSaisirSel=ZSaisir;
%     else
%         error('number of input parameters not correct')
    end    
    
%% initialise and weight the model    
    [Nx, Ny]=size(ZSaisir.d);
    Residuals=zeros(Nx,Ny);
    Corrected=zeros(Nx,Ny);
    [~, M]=size(EMSCModel.Model);
    Parameters=zeros(Nx,M);
    Model=EMSCModel.Model;
    if ~islogical(ZWeights) 
        [WN,~]=size(ZWeights.d);
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
    else
        Model=EMSCModel.Model;
%     else
%         error('number of input parameters not correct')
    end   
    
    
% Handle all spectra in one go to save time
PP = all(ZSaisirSel.d==0,2);

if any(PP)
    if ~islogical(WavelengthCovariance)
        Parameters0  = lscov(Model,ZSaisirSel.d(~PP,:)', WavelengthCovariance)';
    elseif ~islogical(RankReduce)
        Model = bsxfun(@times, Model, RankReduce{1});
        [U,S,P] = svd(Model,'econ');
        T = U*S;
        if RankReduce{2} < 1
            s = diag(S); s = s./sum(s);
            T = T(:,1:find(cumsum(s) >= RankReduce{2}));
            P = P(:,1:find(cumsum(s) >= RankReduce{2}));
            disp([num2str(size(P,2)) ' dimension(s)'])
        else
            T = T(:,1:RankReduce{2});
            P = P(:,1:RankReduce{2});
        end
        Parameters0 = (P/(T'*T)*T'*ZSaisirSel.d(~PP,:)')';
    elseif AbsorbDepScatCoef
        Model = [Model bsxfun(@times,Model(:,2:end),Model(:,end))];
        Parameters0  = lscov(Model,ZSaisirSel.d(~PP,:)')';
    elseif WaveDepScatCoef
        Model = [Model bsxfun(@times,Model(:,2:end),Model(:,2)-mean(Model(:,2)))];
        Parameters0  = lscov(Model,ZSaisirSel.d(~PP,:)')';
    else
        Parameters0  = lscov(Model,ZSaisirSel.d(~PP,:)')';
    end
    Parameters0(:,end) = abs(Parameters0(:,end));
%     Parameters0  = (Model\ZSaisirSel.d(~PP,:)')';
    
    k=1:(EMSCModel.NumBasicModelFunc-1);
    Corrected0 = ZSaisir.d(~PP,:)-Parameters0(:,k)*EMSCModel.Model(:,k)';
    if (EMSCModel.NbadSpec>0)
        k=(EMSCModel.NumBasicModelFunc+EMSCModel.NgoodSpec+1):M;   % bad spectra
        Corrected0 = Corrected0-Parameters0(:,k)*EMSCModel.Model(:,k)';
    end
    Corrected0=bsxfun(@times,Corrected0,1./Parameters0(:,EMSCModel.NumBasicModelFunc)); % correct multipl. eff.
    
    k=1:M;
    Residuals0=ZSaisir.d(~PP,:)-Parameters0(:,k)*EMSCModel.Model(:,k)';
    Corrected(PP,:)   = ZSaisir.d(PP,:);
    Corrected(~PP,:)  = Corrected0;
    Residuals(~PP,:)  = Residuals0;
    Residuals(PP,:)   = 0;
    Parameters(~PP,:) = Parameters0;
    Parameters(PP,:)  = 0;
    
    ZCorrected.d=Corrected;
    ZCorrected.v=ZSaisir.v;
    ZCorrected.i=ZSaisir.i;
    
    ZResiduals.d=Residuals;
    ZResiduals.v=ZSaisir.v;
    ZResiduals.i=ZSaisir.i;
    
    ZParameters.d=Parameters;
    ZParameters.v=EMSCModel.ModelSpecNames;
    ZParameters.i=ZSaisir.i;
else
    if ~islogical(WavelengthCovariance)
        Parameters0  = lscov(Model,ZSaisirSel.d', WavelengthCovariance)';
    elseif ~islogical(RankReduce)
        Model = bsxfun(@times, Model, RankReduce{1});
        [U,S,P] = svd(Model,'econ');
        T = U*S;
        if RankReduce{2} < 1
            s = diag(S); s = s./sum(s);
            T = T(:,1:find(cumsum(s) >= RankReduce{2}));
            P = P(:,1:find(cumsum(s) >= RankReduce{2}));
            disp([num2str(size(P,2)) ' dimension(s)'])
        else
            T = T(:,1:RankReduce{2});
            P = P(:,1:RankReduce{2});
        end
        Parameters0 = (P/(T'*T)*T'*ZSaisirSel.d')';
    elseif AbsorbDepScatCoef
        Model = [Model bsxfun(@times,Model(:,2:end),Model(:,end))];
        Parameters0  = lscov(Model,ZSaisirSel.d')';
    elseif WaveDepScatCoef
        Model = [Model bsxfun(@times,Model(:,2:end),Model(:,2)-mean(Model(:,2)))];
        Parameters0  = lscov(Model,ZSaisirSel.d')';
    else
        Parameters0  = lscov(Model,ZSaisirSel.d')';
    end
    Parameters0(:,end) = abs(Parameters0(:,end));
%     Parameters0a  = (Model\ZSaisirSel.d')';
    
    k=1:(EMSCModel.NumBasicModelFunc-1);
    Corrected0 = ZSaisir.d-Parameters0(:,k)*EMSCModel.Model(:,k)';
    if (EMSCModel.NbadSpec>0)
        k=(EMSCModel.NumBasicModelFunc+EMSCModel.NgoodSpec+1):M;   % bad spectra
        Corrected0 = Corrected0-Parameters0(:,k)*EMSCModel.Model(:,k)';
    end
    Corrected0=bsxfun(@times,Corrected0,1./Parameters0(:,EMSCModel.NumBasicModelFunc)); % correct multipl. eff.
    
    k=1:M;
    Residuals0=ZSaisir.d-Parameters0(:,k)*EMSCModel.Model(:,k)';
    ZCorrected.d=Corrected0;
    ZCorrected.v=ZSaisir.v;
    ZCorrected.i=ZSaisir.i;
    
    ZResiduals.d=Residuals0;
    ZResiduals.v=ZSaisir.v;
    ZResiduals.i=ZSaisir.i;
    
    ZParameters.d=Parameters0;
    ZParameters.v=EMSCModel.ModelSpecNames;
    ZParameters.i=ZSaisir.i;
end
%    
%     for i=1:Nx
%         
%          ZTemp=ZSaisirSel.d(i,:);
%          if (max(abs(ZTemp))==0)
%              P=[];
%          else
%             P = lscov(Model,ZTemp');
%          end
%          ZTemp=ZSaisir.d(i,:);
%          CorrectedTemp=ZTemp;
%          if (~isempty(P))
%              for k=1:(EMSCModel.NumBasicModelFunc-1)   % last modell function is m
%                  ModFunc=(EMSCModel.Model(:,k))';
%                  CorrectedTemp=CorrectedTemp-ModFunc.*P(k);
%              end
%              if (EMSCModel.NbadSpec>0)
%                  for k=(EMSCModel.NumBasicModelFunc+EMSCModel.NgoodSpec+1):M   % bad spectra
%                      ModFunc=(EMSCModel.Model(:,k))';
%                      CorrectedTemp=CorrectedTemp-ModFunc.*P(k);
%                  end
%              end
%              CorrectedTemp=CorrectedTemp./P(EMSCModel.NumBasicModelFunc); % correct multipl. eff.
%              Corrected(i,:)=CorrectedTemp;
% 
%              ResidualsTemp=ZTemp;            
%              for k=1:M
%                  ModFunc=(EMSCModel.Model(:,k))';
%                  ResidualsTemp=ResidualsTemp-ModFunc.*P(k);
%              end
%          
%              Corrected(i,:)=CorrectedTemp;
%              Residuals(i,:)=ResidualsTemp;
%              Parameters(i,:)=P;
%              
%          else
%              Corrected(i,:)=CorrectedTemp;
%              Residuals(i,:)=0;
%              Parameters(i,:)=0;
%          end
%              
%     end
%     
%     % put the sets in saisir structures
%     ZCorrected=matrix2saisir(Corrected);
%     ZCorrected.v=ZSaisir.v;
%     [N M]=size(ZCorrected.d);
%     ZCorrected.i=ZSaisir.i;
%     
%     ZResiduals=matrix2saisir(Residuals);
%     ZResiduals.v=ZSaisir.v;
%     [N M]=size(ZResiduals.d);
%     ZResiduals.i=ZSaisir.i;
%     
%     ZParameters=matrix2saisir(Parameters);
%     ZParameters.v=EMSCModel.ModelSpecNames;
%     ZParameters.i=ZSaisir.i;
%     [N M]=size(ZParameters.d);
% 
%     

    

end