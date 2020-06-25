function [EMSCStrayMod]=MakeLocalStraylightModel(ZRef,ZAbsStray,BaseModFlag,NCOMP);
%MakeLocalStraylightModel
%[EMSCStrayMod]=MakeLocalStraylightModel(ZRef,ZAbsStray,BaseModFlag,NCOMP);
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
%  17.02.09                                                                            %
%                                                                                      %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%                                                                                      %
%  Description                                                                         %
%                                                                                      %
%                                                                                      %
%  Input:   
%              
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:  
%
%
%  History:  
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% internal parameters
PCA_Centered=1; % 1: centred 0: non centered


   
%% Model for estimation of Ref spec.
if (BaseModFlag==1)       % MSC
    [EMSCStrayMod]=make_emsc_modfunc(ZRef,3);
    EMSCStrayMod.Model(:,2:2)=ZRef.d(1,:)';
elseif (BaseModFlag==2)       % EMSC
    [EMSCStrayMod]=make_emsc_modfunc(ZRef,1);
    EMSCStrayMod.Model(:,4:4)=ZRef.d(1,:)';
end


if (PCA_Centered)
    PCA_StrayLight=pca(ZAbsStray);
else
    PCA_StrayLight=pca_non_centered(ZAbsStray);
end
    
AddSpec=[];

for i=1:NCOMP
    AddSpec=[];
    AddSpec.v=PCA_StrayLight.eigenvec.i;
    AddSpec.d(1,:)=PCA_StrayLight.eigenvec.d(:,i)';
    AddSpec.i=['SL  ',PCA_StrayLight.eigenvec.v(i,:)];
    [EMSCStrayMod]=add_spec_to_EMSCmod(EMSCStrayMod,AddSpec,2);
end
% 
% % Add the mean spectrum
% if (PCA_Centered)
%     AddSpec=[];
%     AddSpec.v=PCA_StrayLight.eigenvec.i;
%     AddSpec.d(1,:)=PCA_StrayLight.average.d;
%     AddSpec.i='SL  PCA mean';
%     [EMSCStrayMod]=add_spec_to_EMSCmod(EMSCStrayMod,AddSpec,2);
% end

% Save straylight model data
EMSCStrayMod.SL.PCAMod=PCA_StrayLight;
EMSCStrayMod.SL.PCANCOMPused=NCOMP;
EMSCStrayMod.SL.SLfunction=ZAbsStray;
EMSCStrayMod.SL.PCA_Centered=PCA_Centered;

        

   