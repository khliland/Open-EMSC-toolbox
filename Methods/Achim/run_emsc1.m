function [ZCorrected,ZResiduals,ZParameters,WNIndex]=run_emsc1(ZSaisir,EMSCModel,WNIntervals);
%run_emsc  [ZCorrected,ZResiduals,ZParameters]=run_emsc(ZSaisir,EMSCModel,WNIntervals)
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
%  function [ZCorrected,ZResiduals,ZParameters]=run_emsc(ZSaisir,EMSCModel,WNIntervals)     %
%                                                                                      %
%  Runs emsc using emsc basic model fucntions and constituent difference spectra       %
%                                                                                      %
%                                                                                      %
%  Input:   saisire structure                                                          %
%           EMSC modell functions (in EMSC structure)                                  %                      
%                                                                                      %
%  Output:  saisir structures for ZCorrected,ZResiduals,ZParameters                    %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    % model functions and spectra need always to have the same dimensions
    [NZ MZ]=size(ZSaisir.d);
    [NE ME]=size(EMSCModel.ModelVariables);
    if (MZ~=NE)
        error('model functions and spectra do not have the same dimensions')
    end

    % check the input: in which spectral region is the model defined
    Test=str2num(ZSaisir.v);
    if (nargin==3) 
        [NI MI]=size(WNIntervals);
        WNIndex=[];
        for i=1:NI % number of intervalls
            [y,i1]=min(abs(Test-WNIntervals(i,1)));
            [y,i2]=min(abs(Test-WNIntervals(i,2)));
            Add=i1:i2;
            WNIndex=[WNIndex Add];
        end
        ZSaisirSel=selectcol(ZSaisir,WNIndex);
        Model=EMSCModel.Model(WNIndex,:);
        
    elseif (nargin==2)
        ZSaisirSel=ZSaisir;
        Model=EMSCModel.Model;
    else
        error('number of input parameters not correct')
    end    
    
    
    [Nx Ny]=size(ZSaisir.d);
    ZResiduals=zeros(Nx,Ny);
    ZCorrected=zeros(Nx,Ny);
    [N M]=size(EMSCModel.Model);
    ZParameters=zeros(Nx,M);

    
   
    for i=1:Nx
        
         ZTemp=ZSaisirSel.d(i,:);
         if (max(abs(ZTemp))==0)
             P=[];
         else
            P = lscov(Model,ZTemp');
         end
         ZTemp=ZSaisir.d(i,:);
         ZCorrectedTemp=ZTemp;
         if (~isempty(P))
             for k=1:(EMSCModel.NumBasicModelFunc-1)   % last modell function is m
                 ModFunc=(EMSCModel.Model(:,k))';
                 ZCorrectedTemp=ZCorrectedTemp-ModFunc.*P(k);
             end
             if (EMSCModel.NbadSpec>0)
                 for k=(EMSCModel.NumBasicModelFunc+EMSCModel.NgoodSpec+1):M   % bad spectra
                     ModFunc=(EMSCModel.Model(:,k))';
                     ZCorrectedTemp=ZCorrectedTemp-ModFunc.*P(k);
                 end
             end
             ZCorrectedTemp=ZCorrectedTemp./P(EMSCModel.NumBasicModelFunc); % correct multipl. eff.
             ZCorrected(i,:)=ZCorrectedTemp;

             ZResidualsTemp=ZTemp;            
             for k=1:M
                 ModFunc=(EMSCModel.Model(:,k))';
                 ZResidualsTemp=ZResidualsTemp-ModFunc.*P(k);
             end
         
             ZCorrected(i,:)=ZCorrectedTemp;
             ZResiduals(i,:)=ZResidualsTemp;
             ZParameters(i,:)=P;
         else
             ZCorrected(i,:)=ZCorrectedTemp;
             ZResiduals(i,:)=0;
             ZParameters(i,:)=0;
         end
             
    end
    
    % put the sets in saisir structures
    ZCorrected=matrix2saisir(ZCorrected);
    ZCorrected.v=ZSaisir.v;
    [N M]=size(ZCorrected.d);
    ZCorrected.i=ZSaisir.i;
    
    ZResiduals=matrix2saisir(ZResiduals);
    ZResiduals.v=ZSaisir.v;
    [N M]=size(ZResiduals.d);
    ZResiduals.i=ZSaisir.i;
    
    ZParameters=matrix2saisir(ZParameters);
    %ZParameters.v=;
    ZParameters.i=ZSaisir.i;
    [N M]=size(ZParameters.d);
    %ZParameters.i=num2str((1:N)');
    


