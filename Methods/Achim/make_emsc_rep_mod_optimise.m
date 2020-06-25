 function [EMSCModelFinal]=make_emsc_rep_mod_optimise(ZCal,ZVal,SamplesNameStart,SamplesNameEnd,EMSCOption,NComp,EMSCWeights,plotid)
%make_emsc_rep_mod_cv [ZCorrectedF,ZResidualsF,ZParametersF]=make_emsc_rep_mod_optimise(ZCal,ZVal,SamplesNameStart,SamplesNameEnd,EMSCOption,NComp,EMSCWeights,plotid)
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
%  revised version: 05.08.11   Ako                                                     %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ToDo
%
% 1. Should the MSE be made on strain/cultivation level ????
%
% 2. Which range should be used for validation (MSE average)
%
%

WN1_validation=700;
WN2_validation=1800;


ModelSize=98.0;   % ModelSize defines the explained variance to be covered by the rep. model

% find samples with only one replicate
g=create_group1(ZCal,SamplesNameStart,SamplesNameEnd);
i1=find(g.g.d==1);

if (~isempty(i1))
    [Ni1,Mi1]=size(i1);
    for i=1:Ni1
        strainnum(i)=find(g.d==i1(i));
    end
    ZSaisir=deleterow(ZCal,strainnum);
else
    ZSaisir=ZCal;
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
[y,i2]=min(abs(str2num(ZVal.v)-WN1_validation));
[y,i1]=min(abs(str2num(ZVal.v)-WN2_validation));
size([i1:i2],2);

MSEallComp.d=zeros(NComp,size([i1:i2],2));
MMSEallComp.d=zeros(NComp,size([i1:i2],2));


% %% Here the cross-validation loop starts
% % for i=1:N
% %     % Find replicates for this sample
% %     ZSaisir_m=select_from_identifier(ZSaisir,SamplesNameStart,gSampleGroup.g.i(i,:));
% %     ZSaisir_mm=delete_from_identifier(ZSaisir,SamplesNameStart,gSampleGroup.g.i(i,:));
% %     DeviationsCorrected_mm=delete_from_identifier(DeviationsCorrected,SamplesNameStart,gSampleGroup.g.i(i,:));
% %    
% %     [nRep,nVar]=size(ZSelected.d);
% % 
% %     [EMSCModel_mm]=make_emsc_modfunc(ZSaisir_mm,EMSCOption);
    
pca_model=pca_non_centered(DeviationsCorrected);
    
[EMSCModel]=make_emsc_modfunc(ZCal,EMSCOption);


%% j=1: EMSC physical, j=2 Average spec only
for j=1:NComp
    
    EMSCModelAll=EMSCModel;
    
    if (j>1)
        for k=1:(j-1)
            AddSpec=[];
            AddSpec.v=pca_model.eigenvec.i;
            AddSpec.d(1,:)=pca_model.eigenvec.d(:,k)';
            AddSpec.i=['Rep ',pca_model.eigenvec.v(k,:)];
            [EMSCModelAll]=add_spec_to_EMSCmod(EMSCModelAll,AddSpec,2);
        end
    end
    
    % Add the mean spectrum
    if (0)
        AddSpec=[];
        AddSpec.v=pca_model.eigenvec.i;
        AddSpec.d(1,:)=pca_model.average.d;
        AddSpec.i='Rep PCA mean';
        [EMSCModelAll]=add_spec_to_EMSCmod(EMSCModelAll,AddSpec,2);
    end
    
    EMSCModelFinal=EMSCModelAll;
    
    %% correct the left out samples
    [ZCorrectedF,ZResidualsF,ZParametersF]=cal_emsc(ZVal,EMSCModelFinal,EMSCWeights);
    
    
    [MSE,MMSE]=estimate_rep_var(ZCorrectedF,1,10,WN1_validation,WN2_validation);
    
    
    MMSEallComp.d(j,:)=MMSE.d(1,:); % One MMSE per compoment
    
    MSEallComp.d(j,:)=MSE.d(1,:); % One MMSE per compoment
    
end

Comp=[1:20];
MSE_MMSE=MSE;
MSE_MMSE.d=MSEallComp.d(:,:)./MMSEallComp.d(:,:);



        
figure;
plot(str2num(MMSE.v),MSE_MMSE.d(10:12,:));
xlabel('Wavenumber [cm^-^1]','FontSize',8);
ylabel('Discriminative Power','FontSize',8);
set(gcf,'Color',[1 1 1]);
       

[y,i2]=min(abs(str2num(MSE.v)-982));
Minima=selectcol(MSE_MMSE,i2);       
[Y,I] =max(Minima.d);
        
        
        
Mean_MSE_MMSE=mean(MSE_MMSE.d,2);


figure;
plot(Mean_MSE_MMSE);
xlabel('#components','FontSize',8);
ylabel('Reproducibility','FontSize',8);
set(gcf,'Color',[1 1 1]);


for i=2:NComp
    
   Improvement(i-1)= (Mean_MSE_MMSE(i)-Mean_MSE_MMSE(i-1))/Mean_MSE_MMSE(1);
    
end
[Ident]=find(Improvement>0.02);

NBadSpec=size(Ident,2);

EMSCModelFinal=EMSCModel;

for i=1:NBadSpec
    AddSpec=[];
    AddSpec.v=pca_model.eigenvec.i;
    k=Ident(1,i);
    AddSpec.d(1,:)=pca_model.eigenvec.d(:,k)';
    AddSpec.i=['Rep ',pca_model.eigenvec.v(k,:)];
    [EMSCModelFinal]=add_spec_to_EMSCmod(EMSCModelFinal,AddSpec,2);
end

[ZCorrectedF,ZResidualsF,ZParametersF]=cal_emsc(ZVal,EMSCModelFinal,EMSCWeights);
[MSE,MMSE]=estimate_rep_var(ZCorrectedF,1,10,WN1_validation,WN2_validation);
MMSEOpt=MMSE.d(1,:); % One MMSE per compoment
MSEOpt=MSE.d(1,:); % One MMSE per compoment
MSE_MMSEOpt=MSEOpt./MMSEOpt;


mean(MSE_MMSEOpt)










   
