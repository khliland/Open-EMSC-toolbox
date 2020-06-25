 function [EMSCModelFinal]=make_emsc_rep_mod(ZFTIRSel,SamplesNameStart,SamplesNameEnd,EMSCOption,NComp,EMSCWeights,plotid)
%make_emsc_rep_mod [ZCorrectedF,ZResidualsF,ZParametersF]=make_emsc_rep_mod(ZFTIRSel,SamplesNameStart,SamplesNameEnd,EMSCOption,NComp,EMSCWeights,plotid)
%
%                    'establishes the EMSC model'
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
%  07.03.08                                                                            %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  EMSCOption= 1 (full phys EMSC), 2 (baseline + linear), 3  (baseline)                % 
%                                                                                      %
%                                                                                      %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%                                                                                      % 
%  status: working                                                                     %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% todo
% write header
% check if ZCorrecteds{i} is needed

PCA_Centered=0;
NCompMod=NComp;   % dummy, only active in cases where the explained variance does not exceed ModelSize
ModelSize=70.0;   % ModelSize defines the explained variance to be covered by the rep. model

% find samples with only one replicate
g=create_group1(ZFTIRSel,SamplesNameStart,SamplesNameEnd);
i1=find(g.g.d==1);

if (~isempty(i1))
    [Ni1,Mi1]=size(i1);
    for i=1:Ni1
        strainnum(i)=find(g.d==i1(i));
    end
    ZSaisir=deleterow(ZFTIRSel,strainnum);
    % Calculate the sample group identifier
    gSampleGroup=create_group1(ZSaisir,SamplesNameStart,SamplesNameEnd);
else
    ZSaisir=ZFTIRSel;
    gSampleGroup = g;
end
N=size(gSampleGroup.g.i,1);

%% First loop: cal EMSC model for every rep. group
if (plotid)
    figure;
    set(gcf,'Color',[1 1 1]);
end

ZSaisir.v = str2num(ZSaisir.v);
ls  = size(gSampleGroup.g.i,2);
aux = ZSaisir.i(:,SamplesNameStart:ls);
DeviationsCorrected = ZSaisir;
for i=1:N
   % Find replicates for this sample
   str = gSampleGroup.g.i(i,:);
   eq = find(sum((aux==repmat(str,size(aux,1),1)),2)==ls);
   ZSelected = selectrow(ZSaisir,eq);
%    ZSelected=select_from_identifier(ZSaisir,SamplesNameStart,gSampleGroup.g.i(i,:)); % ??? more general
    nRep = length(eq);
%    [nRep,nVar]=size(ZSelected.d);

   [EMSCModel]=make_emsc_modfunc_num(ZSelected,EMSCOption);
   [ZCorrected,ZResidualsUncorrected,EMSCParam]=cal_emsc(ZSelected,EMSCModel,EMSCWeights);

   % Compute replicate means and corected residuals
   MeanZCorrected.d=mean(ZCorrected.d,1);
   MeanZCorrected.i='Mean Z corrected';MeanZCorrected.v=ZSelected.v;

   % Residuals to be used for the EMSC subspace model
   ZResidualsCorrected=ZCorrected;
   ZResidualsCorrected.d=ZCorrected.d-ones(nRep,1)*MeanZCorrected.d;

   SampleName=ZSelected.i(1,SamplesNameStart:SamplesNameEnd);
      
   % Collect results
   ZCorrecteds{i}=ZCorrected;   
   EMSCModels{i}=EMSCModel;
   EMSCParams{i}=EMSCParam;
   ZResidualsCorrecteds.d{i}=ZResidualsCorrected.d;
    
   %% Compute mean and residuals around corrected mean for this sample
   MeanZCorrecteds.d(i,:)=MeanZCorrected.d;
   MeanZCorrecteds.i(i,:)=MeanZCorrected.i;
   DeviationsCorrected.d(eq,:) = ZResidualsCorrected.d;
%    if (i==1)
%        DeviationsCorrected=ZResidualsCorrected;
%    else
%        DeviationsCorrected=appendrow(DeviationsCorrected,ZResidualsCorrected); 
%    end

   if (plotid)
       PlotReplicates(ZSelected,ZCorrected,MeanZCorrected,...
       ZResidualsCorrected,SamplesNameStart,SamplesNameEnd,EMSCModel,EMSCWeights);
%       pause(0.5);
   end
        
end

MeanZCorrecteds.v=ZFTIRSel.v; %add variable names
TotalMeanZCorrected=mean(MeanZCorrecteds.d);

[EMSCModelAll]=make_emsc_modfunc(ZFTIRSel,EMSCOption);

%% Weight before PCA 
NDev=size(DeviationsCorrected.d,1);
for i=1:NDev
    DeviationsCorrected.d(i,:)=DeviationsCorrected.d(i,:).*EMSCWeights.d;
end

if (PCA_Centered)
    pca_model=pca(DeviationsCorrected);
else
    pca_model=pca_non_centered(DeviationsCorrected);
end


%% Calculate explained variance
[N M]=size(pca_model.score.v);
ExpVarChar=pca_model.score.v(:,M-5:end-1);
ExpVar=str2num(ExpVarChar(1:end,:));
ExpVarCum=zeros(N,1);
iExpVar=1:N;
for i=1:N
    if (i>1)
        ExpVarCum(i)=ExpVarCum(i-1)+ExpVar(i);            
    else
        ExpVarCum(i)=ExpVar(i);
    end
    if (ExpVarCum(i)>=ModelSize)
        NCompMod=i;
        break
    end
end



for i=1:NCompMod
    AddSpec=[];
    AddSpec.v=pca_model.eigenvec.i;
    AddSpec.d(1,:)=pca_model.eigenvec.d(:,i)';
    AddSpec.i=['Rep ',pca_model.eigenvec.v(i,:)];
    [EMSCModelAll]=add_spec_to_EMSCmod(EMSCModelAll,AddSpec,2);
end

% Add the mean spectrum
if (PCA_Centered)
    AddSpec=[];
    AddSpec.v=pca_model.eigenvec.i;
    AddSpec.d(1,:)=pca_model.average.d;
    AddSpec.i='Rep PCA mean';
    [EMSCModelAll]=add_spec_to_EMSCmod(EMSCModelAll,AddSpec,2);
end

EMSCModelFinal=EMSCModelAll;

% Save Mie model data
EMSCModelFinal.Rep.PCAMod=pca_model;
EMSCModelFinal.Rep.PCANCOMPused=NCompMod;
EMSCModelFinal.Rep.Deviations=DeviationsCorrected;
EMSCModelFinal.Rep.PCA_Centered=PCA_Centered;


%% Calculate explained variance
[N M]=size(pca_model.score.v);
ExpVarChar=pca_model.score.v(:,M-5:end-1);
ExpVar=str2num(ExpVarChar(1:end,:));
ExpVarCum=zeros(N,1);
iExpVar=1:N;
for i=1:N
    if (i>1)
        ExpVarCum(i)=ExpVarCum(i-1)+ExpVar(i);            
    else
        ExpVarCum(i)=ExpVar(i);
    end
end


EMSCModelFinal.Rep.ExpVarCum=ExpVarCum;

if (plotid)
    figure
    plot(iExpVar(1:15),ExpVarCum(1:15),'k');
    axis tight;
    xlabel('#components','FontSize',8);
    ylabel('Explained variance','FontSize',8);
    title(texlabel('Explained variance for Replicate model'),'FontSize',8);
    set(gcf,'Color',[1 1 1]);
end
