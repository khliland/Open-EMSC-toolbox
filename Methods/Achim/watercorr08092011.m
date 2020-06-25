%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Achim Kohler                                                                        %
%  Department of Mathematical Sciences and Technology (IMT)                            %
%  Norwegian University of Life Sciences                                               %
%  1432 Ås                                                                             %
%  Norway                                                                              %
%                                                                                      %
%  First version: 21.06.11                                                             %
%  Second version: 08.09.11                                                            %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Input:                                                                              %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:                                                                             %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    


close all;
clear all;


%% Set path to ako's functions
Akos=genpath('D:\ako\saisir\ako_functions');
addpath(Akos,'D:\ako\saisir\saisir');


%% Set parameters for plotting
PlotScores=1;
PlotSpectra=1;
PlotLoadings=1;

%% Load the data of the heat treatment experiment
DirNameSaisir='D:\ako\foulum\heattreatment\unscrambler_sep04\data\';
ZFTIR=LoadFromUnscrambler(DirNameSaisir,'Foulum_complete_rawspec_corr_310804');
ZTemp=LoadFromUnscrambler(DirNameSaisir,'Temp');
ZTempR=LoadFromUnscrambler(DirNameSaisir,'TempR');
ZAnimal=LoadFromUnscrambler(DirNameSaisir,'Animal');
ZFTIR.i=[num2str(ZTempR.d) num2str(ZAnimal.d)];

%% Load the flushing data
DirNameSaisir='D:\ako\foulum\heattreatment\flushing\data\';
ZFLUSH=LoadFromUnscrambler(DirNameSaisir,'flushing170304');
UpperWnEMSC=1000.0;
LowerWnEMSC=4000.0;
[y,i2]=min(abs(str2num(ZFLUSH.v)-UpperWnEMSC));
[y,i1]=min(abs(str2num(ZFLUSH.v)-LowerWnEMSC));
ZFLUSH=selectcol(ZFLUSH,[i1:i2]);



%% Replace this by a weighted EMSC ???, possibly using a higher polynomial order?
%% Define Weights for EMSC
M=size(ZFTIR.d,2);
ZWeights.d=ones(1,M);
ZWeights.i='SpecWeights';
ZWeights.v=ZFTIR.v;

[y,i2]=min(abs(str2num(ZWeights.v)-2200));
[y,i1]=min(abs(str2num(ZWeights.v)-2450));
ZWeights.d(1,i1:i2)=0.00000001;

[EMSCModel]=make_emsc_modfunc(ZFTIR);
[Zprocessed,ZResiduals,ZParameters]=cal_emsc(ZFTIR,EMSCModel,ZWeights);  

[EMSCModelZFLUSH]=make_emsc_modfunc(ZFLUSH);
[ZFLUSH,ZResiduals,ZParameters]=cal_emsc(ZFTIR,EMSCModelZFLUSH,ZWeights);  

%% For Plotting
if (PlotSpectra)
    
    % Plot the loadings    
    figure;
    plot(str2num(ZFLUSH.v),EMSCModel.Model(:,4),'b');
    hold on;
    plot(str2num(ZFLUSH.v),ZWeights.d','r');
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    axis tight,set(gca,'XDir','reverse');
    title(texlabel('Average spectrum'));
    
    UpperWnEMSC=2500.0;
    LowerWnEMSC=4000.0;
    [y,i2]=min(abs(str2num(ZFLUSH.v)-UpperWnEMSC));
    [y,i1]=min(abs(str2num(ZFLUSH.v)-LowerWnEMSC));
    ZFLUSH2=selectcol(ZFLUSH,[i1:i2]);
    figure;
    subplot(1,2,1);
    plot(str2num(ZFLUSH.v),ZFLUSH.d');
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    axis tight,set(gca,'XDir','reverse');
    title(texlabel('H2O spectra'));
    subplot(1,2,2);
    plot(str2num(ZFLUSH2.v),ZFLUSH2.d');
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    axis tight,set(gca,'XDir','reverse');
    title(texlabel('H2O spectra'));
end


%% For Plotting
if (PlotSpectra)
    UpperWnEMSC=1000.0;
    LowerWnEMSC=2100.0;
    [y,i2]=min(abs(str2num(ZFTIR.v)-UpperWnEMSC));
    [y,i1]=min(abs(str2num(ZFTIR.v)-LowerWnEMSC));
    Zprocessed1=selectcol(ZFTIR,[i1:i2]);
    UpperWnEMSC=2500.0;
    LowerWnEMSC=4000.0;
    [y,i2]=min(abs(str2num(Zprocessed.v)-UpperWnEMSC));
    [y,i1]=min(abs(str2num(Zprocessed.v)-LowerWnEMSC));
    Zprocessed2=selectcol(Zprocessed,[i1:i2]);

    UpperWnEMSC=1000.0;
    LowerWnEMSC=4000.0;
    [y,i2]=min(abs(str2num(Zprocessed.v)-UpperWnEMSC));
    [y,i1]=min(abs(str2num(Zprocessed.v)-LowerWnEMSC));
    Zprocessed3=selectcol(Zprocessed,[i1:i2]);

    figure;
    plot(str2num(Zprocessed2.v),Zprocessed2.d');
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    axis tight;
    xlabel('Wavenumber [cm^-^1]','FontSize',12);
    ylabel('Absorption','FontSize',12);
    set(gca,'XDir','reverse');
    title(texlabel('without H2O corr'));
    
    figure;
    plot(str2num(Zprocessed3.v),Zprocessed3.d');
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    axis tight;
    xlabel('Wavenumber [cm^-^1]','FontSize',12);
    ylabel('Absorption','FontSize',12);
    set(gca,'XDir','reverse');
    title(texlabel('without H2O corr'));
    
    
    [y,i1]=min(abs(str2num(Zprocessed1.v)-1654));
    figure;
    plot(ZTempR.d,Zprocessed1.d(:,i1),'.');
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    axis tight;
    xlabel('Wavenumber [cm^-^1]','FontSize',12);
    ylabel('Absorption','FontSize',12);
    set(gca,'XDir','reverse');
    title(texlabel('1654'));
    
end


%%  Index the water variation
[y,i3450]=min(abs(str2num(Zprocessed2.v)-3450.0));
Abs3450=Zprocessed2.d(:,i3450);
index(find(Abs3450<0.23))=0;
index(find(Abs3450>0.23))=1;
IndexExp=num2str(index');
Zprocessed.i=[Zprocessed.i IndexExp];

%Zprocessed1=saisir_derivative(Zprocessed,2,9,2);
Zprocessed1=Zprocessed;

UpperWn=1600.0; 
LowerWn=1700.0;  
[y,i2]=min(abs(str2num(Zprocessed.v)-UpperWn));
[y,i1]=min(abs(str2num(Zprocessed.v)-LowerWn));
Zprocessed2=selectcol(Zprocessed,[i1:i2]);
    
pcamodel=pca(Zprocessed2);
pcamodel2=pca(Zprocessed);

%% plot scores without water correction
if (PlotScores)
    figure;
    carte_couleur1(pcamodel.score,1,2,1,4);
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    xaxis=axis;
    line([xaxis(1) xaxis(2)],[0 0],'color','k');
    line([0 0],[xaxis(3) xaxis(4)],'color','k');
    title(texlabel('without water correction 1600-1700'));
    
    figure;
    carte_couleur1(pcamodel.score,1,2,6,6);
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    xaxis=axis;
    line([xaxis(1) xaxis(2)],[0 0],'color','k');
    line([0 0],[xaxis(3) xaxis(4)],'color','k');
    title(texlabel('without water correction 1600-1700'));
    
end


if (PlotLoadings)
    figure;
    plot(str2num(pcamodel.eigenvec.i),pcamodel.eigenvec.d(:,1),'r');
    hold on;
    plot(str2num(pcamodel.eigenvec.i),pcamodel.eigenvec.d(:,2),'g');
    hold on;
    plot(str2num(pcamodel.eigenvec.i),pcamodel.eigenvec.d(:,3),'b');
    hold on;
    set(gcf,'Color',[1 1 1]);
    set(gca,'XDir','reverse');
    xlabel('Wavenumber [cm^-^1]','FontSize',12);
    ylabel('Loadings','FontSize',12);
    FontSize=12;
    axis tight
    title(texlabel('loadings for EMSC processed (without water correction)'));
    legend('L1','L2');
end


%% Calculate the water/water vapor variation matrix
[n m]=size(ZFLUSH.d);
for i=2:n
    Diff.d(i-1,:)=ZFLUSH.d(i,:)-ZFLUSH.d(1,:);
    SampleN(i-1)=i;
end
Diff.v=ZFLUSH.v;
Diff.i=num2str(SampleN);
pca_model_diff=pca_non_centered(Diff);


%% Calculate and plot the explained variances

[N M]=size(pca_model_diff.score.v);
ExpVarChar=pca_model_diff.score.v(:,7:end-1);
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

figure;
plot(iExpVar(1:4),ExpVarCum(1:4),'k');
set(gcf,'Color',[1 1 1]);
xlabel('#components','FontSize',12);
ylabel('Explained variance','FontSize',12);


%% Plot the loadings for the water vapor variation
figure;
plot(str2num(pca_model_diff.eigenvec.i),pca_model_diff.eigenvec.d(:,1),'r');
hold on;
plot(str2num(pca_model_diff.eigenvec.i),pca_model_diff.eigenvec.d(:,2),'g');
hold on;
set(gcf,'Color',[1 1 1]);
set(gca,'XDir','reverse');
xlabel('Wavenumber [cm^-^1]','FontSize',12);
ylabel('Loadings','FontSize',12);
FontSize=12;
axis tight
title(texlabel('loadings'));
legend('L1','L2');



%% Build the extended EMSC model with loadings
EMSC_extended=EMSCModel;
for i=1:2
    AddSpec=[];
    AddSpec.v=pca_model_diff.eigenvec.i;
    
    AddSpec.i=['H2O ',pca_model_diff.eigenvec.v(i,:)]
    if (i==1)
        AddSpec.d(1,:)=pca_model_diff.eigenvec.d(:,i)';
        %AddSpec=saisir_derivative(AddSpec,2,31,0);
        
        
        figure;
        plot(str2num(AddSpec.v),AddSpec.d');
        set(gcf,'Color',[1 1 1]);
        FontSize=12;
        axis tight;
        xlabel('Wavenumber [cm^-^1]','FontSize',12);
        ylabel('Absorption','FontSize',12);
        set(gca,'XDir','reverse');
        title(texlabel('smoothed loading'));
        
    else
        AddSpec.d(1,:)=pca_model_diff.eigenvec.d(:,i)';
    end
    [EMSC_extended]=add_spec_to_EMSCmod(EMSC_extended,AddSpec,2);
end
[Zprocessed,ZResiduals,ZParameters]=cal_emsc(Zprocessed,EMSC_extended,ZWeights);


%For Plotting
UpperWnEMSC=1000.0;
LowerWnEMSC=2100.0;
[y,i2]=min(abs(str2num(ZFTIR.v)-UpperWnEMSC));
[y,i1]=min(abs(str2num(ZFTIR.v)-LowerWnEMSC));
Zprocessed1=selectcol(ZFTIR,[i1:i2]);
UpperWnEMSC=2500.0;
LowerWnEMSC=4000.0;
[y,i2]=min(abs(str2num(Zprocessed.v)-UpperWnEMSC));
[y,i1]=min(abs(str2num(Zprocessed.v)-LowerWnEMSC));
Zprocessed2=selectcol(Zprocessed,[i1:i2]);
UpperWnEMSC=1000.0;
LowerWnEMSC=4000.0;
[y,i2]=min(abs(str2num(Zprocessed.v)-UpperWnEMSC));
[y,i1]=min(abs(str2num(Zprocessed.v)-LowerWnEMSC));
Zprocessed3=selectcol(Zprocessed,[i1:i2]);

if (PlotSpectra)
    figure;
    plot(str2num(Zprocessed2.v),Zprocessed2.d');
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    axis tight;
    xlabel('Wavenumber [cm^-^1]','FontSize',12);
    ylabel('Absorption','FontSize',12);
    set(gca,'XDir','reverse');
    title(texlabel('with H2O corr'));
    
    figure;
    plot(str2num(Zprocessed3.v),Zprocessed3.d');
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    axis tight;
    xlabel('Wavenumber [cm^-^1]','FontSize',12);
    ylabel('Absorption','FontSize',12);
    set(gca,'XDir','reverse');
    title(texlabel('with H2O corr'));
    
   [y,i1]=min(abs(str2num(Zprocessed1.v)-1654));
    figure;
    plot(ZTempR.d,Zprocessed1.d(:,i1),'.');
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    axis tight;
    xlabel('Wavenumber [cm^-^1]','FontSize',12);
    ylabel('Absorption','FontSize',12);
    set(gca,'XDir','reverse');
    title(texlabel('after water corr: 1654'));
end


%Zprocessed1=saisir_derivative(Zprocessed,2,9,2);
Zprocessed1=Zprocessed;
UpperWn=1600.0; 
LowerWn=1700.0;  
[y,i2]=min(abs(str2num(Zprocessed1.v)-UpperWn));
[y,i1]=min(abs(str2num(Zprocessed1.v)-LowerWn));
Zprocessed2=selectcol(Zprocessed1,[i1:i2]);


pcamodel2=pca(Zprocessed2);

% plot scores with water correction
if (PlotScores)
    figure;
    carte_couleur1(pcamodel2.score,1,2,1,4);
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    xaxis=axis;
    line([xaxis(1) xaxis(2)],[0 0],'color','k');
    line([0 0],[xaxis(3) xaxis(4)],'color','k');
    title(texlabel('with H2O corr 1600-1700'));
    
%     figure;
%     carte_couleur1(pcamodel2.score,1,2,5,5);
%     set(gcf,'Color',[1 1 1]);
%     FontSize=12;
%     xaxis=axis;
%     line([xaxis(1) xaxis(2)],[0 0],'color','k');
%     line([0 0],[xaxis(3) xaxis(4)],'color','k');
%     title(texlabel('with H2O corr 1600-1700'));
%     
    
    figure;
    carte_couleur1(pcamodel2.score,1,2,6,6);
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    xaxis=axis;
    line([xaxis(1) xaxis(2)],[0 0],'color','k');
    line([0 0],[xaxis(3) xaxis(4)],'color','k');
    title(texlabel('with H2O corr 1600-1700'));
end

%% Establish a EMSC model using a difference consituent spectrum
EMSC_extended=EMSCModel;

ZDiffConstituent=ZFLUSH;
ZDiffConstituent.d=ZFLUSH.d(10,:)-ZFLUSH.d(1,:);

AddSpec=[];
AddSpec.v=ZDiffConstituent.v;

AddSpec.i=['H2O ']
AddSpec.d(1,:)=ZDiffConstituent.d(1,:);
[EMSC_extended]=add_spec_to_EMSCmod(EMSC_extended,AddSpec,2);
[Zprocessed,ZResiduals,ZParameters]=cal_emsc(Zprocessed,EMSC_extended,ZWeights);

figure;
plot(str2num(AddSpec.v),AddSpec.d');
set(gcf,'Color',[1 1 1]);
FontSize=12;
axis tight;
xlabel('Wavenumber [cm^-^1]','FontSize',12);
ylabel('Absorption','FontSize',12);
set(gca,'XDir','reverse');
title(texlabel('Difference spectrum'));

figure;
plot(str2num(Zprocessed.v),Zprocessed.d');
set(gcf,'Color',[1 1 1]);
FontSize=12;
axis tight;
xlabel('Wavenumber [cm^-^1]','FontSize',12);
ylabel('Absorption','FontSize',12);
set(gca,'XDir','reverse');
% title(texlabel('with H2O corr'));



%Zprocessed1=saisir_derivative(Zprocessed,2,9,2);
Zprocessed1=Zprocessed;
UpperWn=1600.0; 
LowerWn=1700.0;  
[y,i2]=min(abs(str2num(Zprocessed1.v)-UpperWn));
[y,i1]=min(abs(str2num(Zprocessed1.v)-LowerWn));
Zprocessed2=selectcol(Zprocessed1,[i1:i2]);


pcamodel2=pca(Zprocessed2);

% plot scores with water correction
if (PlotScores)
    figure;
    carte_couleur1(pcamodel2.score,1,2,1,4);
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    xaxis=axis;
    line([xaxis(1) xaxis(2)],[0 0],'color','k');
    line([0 0],[xaxis(3) xaxis(4)],'color','k');
    title(texlabel('with H2O corr 1600-1700'));
    
%     figure;
%     carte_couleur1(pcamodel2.score,1,2,5,5);
%     set(gcf,'Color',[1 1 1]);
%     FontSize=12;
%     xaxis=axis;
%     line([xaxis(1) xaxis(2)],[0 0],'color','k');
%     line([0 0],[xaxis(3) xaxis(4)],'color','k');
%     title(texlabel('with H2O corr 1600-1700'));
%     
    
    figure;
    carte_couleur1(pcamodel2.score,1,2,6,6);
    set(gcf,'Color',[1 1 1]);
    FontSize=12;
    xaxis=axis;
    line([xaxis(1) xaxis(2)],[0 0],'color','k');
    line([0 0],[xaxis(3) xaxis(4)],'color','k');
    title(texlabel('with H2O corr 1600-1700'));
end





