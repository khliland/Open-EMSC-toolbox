function [EMSCMieMod]=make_DispersiveMie_mod(ZRef,ZAbs,BaseModFlag,NCOMP);
%make_DispersiveMie_mod
%[EMSCDisMod]=make_DispersiveMie_mod(ZRef,ZAbs,MieOpt,BaseModFlag,NCOMP,ZWeightsRef);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Paul Bassan, Achim Kohler                                                                        %
%  Center for Biospectroscopy and Data Modelling                                       %
%  Matforsk                                                                            %
%  Norwegian Food Research Institute                                                   %
%  Osloveien 1                                                                         %
%  1430 Ås                                                                             %
%  Norway                                                                              %
%                                                                                      %
%  21.02.08                                                                            %
%  revised 15.03.09                                                                    %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%                                                                                      %
%  Description                                                                         %
%                                                                                      %
%                                                                                      %
%  Input:   (Paul,to be revised)
%              ZRef           Reference spec to be corrected and afterwards
%                             used in the model
%              ZAbs 
%              BaseModFlag    1: MSC basic model
%                             2: EMSC basic model  
%
%              NCOMP          Number of components for Mie EMSC model
%
%
%
%              ZWeightsRef    weights for the reference spectrum
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:  
%              EMSCDisMod     
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


PCA_Centered=0;

[ZDis]=make_dismod_funcs(ZAbs);


norm=sqrt(ZRef.d*ZRef.d');
rnorm=ZRef.d/norm;
s=ZDis.d*rnorm';
ZDis.d=ZDis.d-s*rnorm;



%% decompose the set of Mie functions
if (PCA_Centered)
   pca_model=pca(ZDis);
else
   pca_model=pca_non_centered(ZDis);
end
  

%% Construct the Mie model with the new ref spec
if (BaseModFlag==1)     % MSC model
    [EMSCMieMod]=make_emsc_modfunc(ZRef,3);
elseif (BaseModFlag==2)     % Physical EMSC model
    [EMSCMieMod]=make_emsc_modfunc(ZRef,1);
end

for i=1:NCOMP
    AddSpec=[];
    AddSpec.v=pca_model.eigenvec.i;
    AddSpec.d(1,:)=pca_model.eigenvec.d(:,i)';
    AddSpec.i=['Dis ',pca_model.eigenvec.v(i,:)]
    [EMSCMieMod]=add_spec_to_EMSCmod(EMSCMieMod,AddSpec,2);
end

if (PCA_Centered) % Add the mean spectrum
    AddSpec=[];
    AddSpec.v=pca_model.eigenvec.i;
    AddSpec.d(1,:)=pca_model.average.d;
    AddSpec.i='Dis PCA mean';
    [EMSCMieMod]=add_spec_to_EMSCmod(EMSCMieMod,AddSpec,2);
end

% Keep the Dis model data
EMSCMieMod.Dis.PCAMod=pca_model;
EMSCMieMod.Dis.PCANCOMPused=NCOMP;
EMSCMieMod.Dis.Miefunction=ZDis;
EMSCMieMod.Dis.PCA_Centered=PCA_Centered;


