 function [EMSCModelFinal]=make_emsc_rep_mod_cv(ZFTIRSel,SamplesNameStart,SamplesNameEnd,EMSCOption,NComp,EMSCWeights,plotid)
%make_emsc_rep_mod_cv [ZCorrectedF,ZResidualsF,ZParametersF]=make_emsc_rep_mod_cv(ZFTIRSel,SamplesNameStart,SamplesNameEnd,EMSCOption,NComp,EMSCWeights,plotid)
%
%                    'establishes the EMSC model'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Achim Kohler                                          %
%  Department of Mathematical Sciences and Technology (IMT)                            %
%  Norwegian University of Life Sciences                                               %
%  1432 Ås                                                                             %
%  Norway                                                                              %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%                                                                                      %
%  Description                                                                         %
%                                                                                      %
%                                                                                      %
%  Input:                                                                              %  
%                                                                                      %
%  EMSCOption= 1 (full phys EMSC), 2 (baseline + linear), 3  (baseline)                % 
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:                                                                             %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  first version: 07.03.08   Ako                                                       %
%  revised version: 03.08.11   Ako                                                     %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



PCA_Centered=0;
ModelSize=98.0;   % ModelSize defines the explained variance to be covered by the rep. model

% find samples with only one replicate
g=create_group1(ZFTIRSel,SamplesNameStart,SamplesNameEnd);
i1=find(g.g.d==1);

if (~isempty(i1))
    [Ni1,Mi1]=size(i1);
    for i=1:Ni1
        strainnum(i)=find(g.d==i1(i));
    end
    ZSaisir=deleterow(ZFTIRSel,strainnum);
else
    ZSaisir=ZFTIRSel;
end



% Calculate the sample group identifier
gSampleGroup=create_group1(ZSaisir,SamplesNameStart,SamplesNameEnd);
N=size(gSampleGroup.g.i,1);


if (plotid)
    figure;
    set(gcf,'Color',[1 1 1]);
end


%% Establish the matrix of replicate variatio
for i=1:N
   % Find replicates for this sample
   ZSelected=select_from_identifier(ZSaisir,SamplesNameStart,gSampleGroup.g.i(i,:)); % ??? more general
   [nRep,nVar]=size(ZSelected.d);

   [EMSCModel]=make_emsc_modfunc(ZSelected,EMSCOption);
   [ZCorrected,ZResidualsUncorrected,EMSCParam]=cal_emsc(ZSelected,EMSCModel,EMSCWeights);
   
   
   % Compute replicate means and corected residuals
   MeanZCorrected.d=mean(ZCorrected.d,1);
   MeanZCorrected.i='Mean Z corrected';
   MeanZCorrected.v=ZSelected.v;

   % Residuals to be used for the EMSC subspace model
   ZResidualsCorrected=ZCorrected;
   ZResidualsCorrected.d=ZCorrected.d-ones(nRep,1)*MeanZCorrected.d;

     
    
   %% Compute mean and residuals around corrected mean for this sample
   if (i==1)
       DeviationsCorrected=ZResidualsCorrected;
   else
       DeviationsCorrected=appendrow(DeviationsCorrected,ZResidualsCorrected); 
   end

   if (plotid)
       PlotReplicates(ZSelected,ZCorrected,MeanZCorrected,...
       ZResidualsCorrected,SamplesNameStart,SamplesNameEnd,EMSCModel,EMSCWeights);
%       pause(0.5);
   end
end


%% Weight before PCA 
NDev=size(DeviationsCorrected.d,1);
for i=1:NDev
    DeviationsCorrected.d(i,:)=DeviationsCorrected.d(i,:).*EMSCWeights.d;
end



%% Initialise
%???????????????
[y,i2]=min(abs(str2num(ZFTIRSel.v)-700));
[y,i1]=min(abs(str2num(ZFTIRSel.v)-1800));
size([i1:i2],2);

SumMSE.d=zeros(NComp,size([i1:i2],2));
SumMMSE.d=zeros(NComp,size([i1:i2],2));


%% Here the cross-validation loop starts
for i=1:N
    % Find replicates for this sample
    ZSaisir_m=select_from_identifier(ZSaisir,SamplesNameStart,gSampleGroup.g.i(i,:));
    ZSaisir_mm=delete_from_identifier(ZSaisir,SamplesNameStart,gSampleGroup.g.i(i,:));
    DeviationsCorrected_mm=delete_from_identifier(DeviationsCorrected,SamplesNameStart,gSampleGroup.g.i(i,:));
   
    [nRep,nVar]=size(ZSelected.d);

    [EMSCModel_mm]=make_emsc_modfunc(ZSaisir_mm,EMSCOption);
    
    if (PCA_Centered)
        pca_model=pca(DeviationsCorrected_mm);
    else
        pca_model=pca_non_centered(DeviationsCorrected_mm);
    end
    
    for j=1:NComp
        
        EMSCModelAll=EMSCModel_mm;
        for k=1:j
            AddSpec=[];
            AddSpec.v=pca_model.eigenvec.i;
            AddSpec.d(1,:)=pca_model.eigenvec.d(:,k)';
            AddSpec.i=['Rep ',pca_model.eigenvec.v(k,:)];
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
        
        %% correct the left out samples
        [ZCorrectedF_m,ZResidualsF,ZParametersF]=cal_emsc(ZSaisir_m,EMSCModelFinal,EMSCWeights);
        [ZCorrectedF_mm,ZResidualsF,ZParametersF]=cal_emsc(ZSaisir_mm,EMSCModelFinal,EMSCWeights);
        
        Zall=appendrow(ZCorrectedF_m,ZCorrectedF_mm);
        
        
        [~,MMSE]=estimate_rep_var(ZCorrectedF_m,SamplesNameStart,SamplesNameEnd,700,1800);
        [MSE,~]=estimate_rep_var(Zall,SamplesNameStart,SamplesNameEnd,700,1800);
        
        
        SumMMSE.d(j,:)=MMSE.d(1,:)+SumMMSE.d(j,:); % One MMSE per compoment
        
        SumMSE.d(j,:)=MSE.d(1,:)+SumMSE.d(j,:); % One MMSE per compoment
        
    end
    'Segment', N;
    
    MSE_MMSE=SumMSE.d(:,:)./SumMMSE.d(:,:);
        
    figure;
    plot(str2num(MMSE.v),MSE_MMSE(1,:));
    xlabel('Wavenumber [cm^-^1]','FontSize',8);
    ylabel('Discriminative Power','FontSize',8);
    set(gcf,'Color',[1 1 1]);
   
end

SumMMSETot.d=SumMMSE.d/N;   
SumMSETot.d=SumMSE.d/N;


MSE_MMSE=SumMSETot.d(:,:)./SumMMSETot.d(:,:);
        
figure;
plot(str2num(MMSE.v),MSE_MMSE(1,:));
xlabel('Wavenumber [cm^-^1]','FontSize',8);
ylabel('Discriminative Power','FontSize',8);
set(gcf,'Color',[1 1 1]);
        
        
        
        
        
   Mean_MSE_MMSE=mean(MSE_MMSE,2);
        

   figure;
   plot(Mean_MSE_MMSE);
   xlabel('#components','FontSize',8);
   ylabel('Reproducibility','FontSize',8);
   set(gcf,'Color',[1 1 1]);

   
