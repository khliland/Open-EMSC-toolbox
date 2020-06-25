function [EMSCDisMod]=make_straylight_mod(ZRef,BaseModFlag,NCOMP,nu0,Width0,I0);
%make_straylight_mod
%[EMSCDisMod]=make_straylight_mod_mod(ZRef,BaseModFlag,NCOMP,nu0,Width0,I0);
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
%  23.02.08                                                                            %
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
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% internal parameters
PCA_Centered=1; % 1: centered 0: not defined


   
%% Model for estimation of Ref spec.
if (BaseModFlag==1)       % MSC
    [EMSCDisMod]=make_emsc_modfunc(ZRef,3);
    EMSCDisMod.Model(:,2:2)=ZRef.d(1,:)';
elseif (BaseModFlag==2)       % EMSC
    [EMSCDisMod]=make_emsc_modfunc(ZRef,1);
    EMSCDisMod.Model(:,4:4)=ZRef.d(1,:)';
end

LorentzLineM=cal_Lorentz_line_1deriv(ZRef.v,nu0,Width0,I0);
for j=1:8
    Width=(j-1)*10+Width0;
    %for i=1:1
        %nu=nu0+i*10;
        [LorentzLine]=cal_Lorentz_line_1deriv(ZRef.v,nu0,Width,I0);
        LorentzLineM=appendrow(LorentzLineM,LorentzLine);
    %end
end
PCA_Lorentz=pca(LorentzLineM)
    
AddSpec=[];

for i=1:NCOMP
    AddSpec=[];
    AddSpec.v=PCA_Lorentz.eigenvec.i;
    AddSpec.d(1,:)=PCA_Lorentz.eigenvec.d(:,i)';
    AddSpec.i=['Dis ',PCA_Lorentz.eigenvec.v(i,:)]
    [EMSCDisMod]=add_spec_to_EMSCmod(EMSCDisMod,AddSpec,2);
end

% Add the mean spectrum
if (PCA_Centered)
    AddSpec=[];
    AddSpec.v=PCA_Lorentz.eigenvec.i;
    AddSpec.d(1,:)=PCA_Lorentz.average.d;
    AddSpec.i='Dis PCA mean';
    [EMSCDisMod]=add_spec_to_EMSCmod(EMSCDisMod,AddSpec,2);
end

% Save dispersive artefact model data
EMSCDisMod.Dis.PCAMod=PCA_Lorentz;
EMSCDisMod.Dis.PCANCOMPused=NCOMP;
EMSCDisMod.Dis.Disfunction=LorentzLineM;
EMSCDisMod.Dis.PCA_Centered=PCA_Centered;

figure;
plot(str2num(LorentzLineM.v),LorentzLineM.d,'k-');
set(gcf,'Color',[1 1 1]);
xlabel('Wavenumber [cm^-^1]','FontSize',8);
ylabel('Mie extinction','FontSize',8);
set(gca,'XDir','reverse');
title(texlabel('Dispersive artefact model Spectra'),'FontSize',8);
        

   