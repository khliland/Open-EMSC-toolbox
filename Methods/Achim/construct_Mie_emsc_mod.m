function [EMSCMieMod]=construct_Mie_emsc_mod(ZRef,MieOpt,BaseModFlag,NCOMP,NCOMPREF,AlphaMin,AlphaMax,NSpacingsAlpha,ZWeightsRef);
%construct_Mie_emsc_mod
%[EMSCMieMod]=construct_Mie_emsc_mod(ZRef,MieOpt,NCOMP,NCOMPREF,m0,r0,step,Nstep,ZWeightsRef);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Achim Kohler                                          %
%  Department of Mathematical Sciences and Technology (IMT)                            %
%  Norwegian University of Life Sciences                                               %
%  1432 Ås                                                                             %
%  Norway                                                                              %
%                                                                                      %
%  First version: 04.07.11                                                             %
%                                                                                      %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%                                                                                      %
%  Description                                                                         %
%                                                                                      %
%                                                                                      %
%  Input:   
%              ZRef           Reference spec to be corrected and afterwards
%                             used in the model
%              MieOpt=1;      1: approximation formula of Van De Hulst
%                             2: approximation formula of  Walstra
%              BaseModFlag    1: MSC basic model
%                             2: EMSC basic model  
%
%              NCOMP          Number of components for Mie EMSC model
%              NCOMPREF       Number of components for Mie EMSC model for
%                             the reference spectrum
%              m0             refractive index ratio (inside/ouside)
%              r0             theoretical radius of the sphere (units: micrometer)
%              step           defines the alpha spacing for the calculation
%                             the Mie model functions
%              Nstep          number of steps for the alpha values
%              ZWeightsRef    weights for the reference spectrum
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:  
%              EMSCMieMod     
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% internal parameters
PlotRefSpecRes=1;
PCA_Centered=0;    % 1: centered 0: uncentered % Mie PCA model


%% Calculate the Mie model functions
gamma=0;
alpha_values=linspace(AlphaMin,AlphaMax,NSpacingsAlpha); 

NVar=size(ZRef.d,2);
ZMie.d=zeros(NSpacingsAlpha,NVar);

MinOfn=3;
icount=0;
ZRefIndex=ZRef; % dummy refractive index spectrum
    
%% Loop for matrix of realisations of model
for id=1:length(alpha_values);    

    alpha=alpha_values(id);

    icount=icount+1;
        
         
    ZQ=Res_Mie_Spec_scaled(ZRefIndex,alpha,gamma);
                
                
    % Create names for model functions
    AlphaRounded(icount)=round(alpha*10000000)/10;
         

    ZMie.d(icount,:)=ZQ.d;


end                     % End of Mie loop
ZMie.i=num2str(AlphaRounded');
ZMie.v=ZRef.v;

    

%% decompose the set of Mie functions
if (PCA_Centered)
   pca_model=pca(ZMie);
else
   pca_model=pca_non_centered(ZMie);
   %pca_model=pca_neg_trunc(ZMie);
end
  

%% Establish Mie Model for the reference spectrum
[Nx Ny]=size(ZRef.d);
Baseline=ones(1,Ny);

yRef.d=(pca_model.eigenvec.d(:,1:NCOMPREF))';
yRef.v=pca_model.eigenvec.i;
yRef.i=pca_model.eigenvec.v(1:NCOMPREF,:);
    
if (PCA_Centered) % For centred PCA: Add the mean spectrum to yRef
    yRef.d(NCOMPREF+1,:)=pca_model.average.d;
    yRef.i(NCOMPREF+1,:)='average   ';
end

% Add a baseline
yRef.d(NCOMPREF+PCA_Centered+1,:)=Baseline';
yRef.i(NCOMPREF+PCA_Centered+1,:)='Baseline  ';

    
    
%% weighting for reference spectrum    
RefSpectrumWeighted=ZRef.d(1,:).*ZWeightsRef.d(1,:);
[N M]=size(yRef.d);
for i=1:N
    yRefWeighted.d(i,:)=yRef.d(i,:).*ZWeightsRef.d(1,:);
end

%% Least squares for correcting the reference spectrum
P= lscov(yRefWeighted.d',RefSpectrumWeighted');
    

%% Calculate the estimated Mie extinction and Mie corrected Ref spectrum
ZScatter.d=zeros(1,M);
ZScatter.v=yRef.v;
ZScatter.i='ScatterSpec';
for j=1:(NCOMPREF+PCA_Centered+1)
    ZScatter.d(1,:)=ZScatter.d(1,:)+P(j)*yRef.d(j,:);
end
NewRefSpec=ZRef.d(1,:)-ZScatter.d(1,:);


%% Construct the Mie model with the new ref spec
if (BaseModFlag==1)     % MSC model
    [EMSCMieMod]=make_emsc_modfunc(ZRef,3);
    EMSCMieMod.Model(:,2:2)=NewRefSpec';
elseif (BaseModFlag==2)     % Physical EMSC model
    [EMSCMieMod]=make_emsc_modfunc(ZRef,1);
    EMSCMieMod.Model(:,4:4)=NewRefSpec';
end

for i=1:NCOMP
    AddSpec=[];
    AddSpec.v=pca_model.eigenvec.i;
    AddSpec.d(1,:)=pca_model.eigenvec.d(:,i)';
    AddSpec.i=['Mie ',pca_model.eigenvec.v(i,:)]
    [EMSCMieMod]=add_spec_to_EMSCmod(EMSCMieMod,AddSpec,2);
end

if (PCA_Centered) % Add the mean spectrum
    AddSpec=[];
    AddSpec.v=pca_model.eigenvec.i;
    AddSpec.d(1,:)=pca_model.average.d;
    AddSpec.i='Mie PCA mean';
    [EMSCMieMod]=add_spec_to_EMSCmod(EMSCMieMod,AddSpec,2);
end

% Keep the Mie model data
EMSCMieMod.Mie.PCAMod=pca_model;
EMSCMieMod.Mie.PCANCOMPused=NCOMP;
EMSCMieMod.Mie.Miefunction=ZMie;
EMSCMieMod.Mie.PCA_Centered=PCA_Centered;


    
%% Plot the results for the reference spectrum 
if (PlotRefSpecRes==1)
 
        figure;
        FontSize=8;
        set(gcf,'Color',[1 1 1]);
                
        subplot(2,2,1);
        plot(str2num(ZRef.v),ZRef.d(:,:)','k');
        hold on;
        plot(str2num(ZScatter.v),ZScatter.d(:,:)','k');
        axis tight;
        xlabel('Wavenumber [cm^-^1]','FontSize',8);
        ylabel('Absorption','FontSize',8);
        title(texlabel('Ref. spectrum'),'FontSize',8);
        set(gca,'XDir','reverse');
        
        subplot(2,2,2);
        plot(str2num(ZRef.v),NewRefSpec','k');
        axis tight;
        xlabel('Wavenumber [cm^-^1]','FontSize',8);
        ylabel('Absorption','FontSize',8);
        title(texlabel('Corrected ref. spectrum'),'FontSize',8);
        set(gca,'XDir','reverse');
        
        subplot(2,2,3);
        for iplot=1:NCOMPREF
            plot(str2num(pca_model.eigenvec.i(:,:)),pca_model.eigenvec.d(:,iplot),'r');
            hold on;
        end
        axis tight;
        xlabel('Wavenumber [cm^-^1]','FontSize',8);
        ylabel('Loadings','FontSize',8);
        title(texlabel('Loadings'),'FontSize',8);
        set(gca,'XDir','reverse');
        
        subplot(2,2,4);
        plot(str2num(ZMie.v),ZMie.d,'k-');
        axis tight;
        set(gcf,'Color',[1 1 1]);
        xlabel('Wavenumber [cm^-^1]','FontSize',8);
        ylabel('Mie extinction','FontSize',8);
        set(gca,'XDir','reverse');
        title(texlabel('Mie model Spectra'),'FontSize',8);

        figure;
        plot(str2num(ZMie.v),ZMie.d,'k-');
        axis tight;
        set(gcf,'Color',[1 1 1]);
        xlabel('Wavenumber [cm^-^1]','FontSize',8);
        ylabel('Mie extinction','FontSize',8);
        set(gca,'XDir','reverse');
        title(texlabel('Mie model Spectra'),'FontSize',8);

        
        %% Calculate explained variance
        [N M]=size(pca_model.score.v);
        ExpVarChar=pca_model.score.v(:,7:end-1);
        ExpVar=str2num(ExpVarChar(1:end,:));
        ExpVarCum=zeros(N);
        iExpVar=1:N;
        for i=1:N
            if (i>1)
                ExpVarCum(i)=ExpVarCum(i-1)+ExpVar(i);            
            else
                ExpVarCum(i)=ExpVar(i);
            end
        end
        
        figure
        subplot(1,2,1);
        plot(iExpVar(1:min(10,N)),ExpVarCum(1:min(10,N)),'k');
        axis tight;
        xlabel('#components','FontSize',8);
        ylabel('Explained variance','FontSize',8);
        title(texlabel('Explained variance for Mie model'),'FontSize',8);
        set(gcf,'Color',[1 1 1]);
        
        subplot(1,2,2);
        plot(str2num(ZWeightsRef.v),ZWeightsRef.d,'r');
        axis tight;
        set(gcf,'Color',[1 1 1]);
        xlabel('Wavenumber [cm^-^1]','FontSize',8);
        ylabel('Weights','FontSize',8);
        set(gca,'XDir','reverse');
        title(texlabel('Reference Weights'),'FontSize',8);


end
