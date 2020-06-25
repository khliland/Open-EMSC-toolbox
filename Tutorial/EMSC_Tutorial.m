%% EMSC tutorial script
%
% A versatile Matlab-based script covering all the aspects of
% EMSC preprocessing as described in this tutorial can be
% downloaded at the web site www.specmod.org.
%
% Contents:
% (0) Preparations
% (1) MSC
% (2) Basic EMSC model
% (3) Higher order polynomial
% (4) Reference spectrum (baseline)
% (5) Constituent spectra
% (6) Replicate correction





%% (0) Preparations
addpath(genpath('\\ad.local\dfs\AAS-Users\kristian.liland\Documents\MATLAB\Achim'))
close all; clear; clc

% Load Raman data
Raman = LoadFromUnscrambler_v96('./','org200709.MAT');
[n,p] = size(Raman.d);
v = zeros(p,1); % Remove cm-1 from ordinates and reformat
for i=1:p
    s = regexp(Raman.v(i,:), 'cm-1', 'split');
    v(i) = str2num(s{1});
end
Raman.v = num2str(v);
for i=1:21
    Raman.i(i,:) = [' ' Raman.i(i,1:end-1)];
end
Raman   = selectcol(Raman,621:3121); % Remove ends of spectra

% Plot spectra to confirm successful conversion to Saisir
figure
h = plot_spectra(Raman,[],2);
title('Raw Raman spectra')

% Load FT-IR data
DirNameSaisir = '.\Data\';
ZFTIR   = LoadFromUnscrambler(DirNameSaisir,'Foulum_complete_rawspec_corr_310804');
ZTemp   = LoadFromUnscrambler(DirNameSaisir,'Temp');
ZTempR  = LoadFromUnscrambler(DirNameSaisir,'TempR');
ZAnimal = LoadFromUnscrambler(DirNameSaisir,'Animal');
ZFTIR.i = [num2str(ZTempR.d) num2str(ZAnimal.d)];

ZFLUSH = LoadFromUnscrambler(DirNameSaisir,'flushing170304');
UpperWnEMSC = 1000.0;
LowerWnEMSC = 4000.0;
[y,i2] = min(abs(str2num(ZFLUSH.v)-UpperWnEMSC));
[y,i1] = min(abs(str2num(ZFLUSH.v)-LowerWnEMSC));
ZFLUSH = selectcol(ZFLUSH,[i1:i2]);

% Plot spectra to confirm successful conversion to Saisir
figure
h = plot_spectra(ZFTIR,[],1);
title('Raw FT-IR spectra')

% Find size of screen for plotting
screen = get( 0, 'ScreenSize' );
sizeY = min(1000, screen(4)-200);
sizeX = sizeY*0.7;
posY  = 50;
posX  = (screen(3)-sizeX)*0.5;






%% (1) MSC
[EMSC] = make_emsc_modfunc(Raman,3);
[ZCorrected,ZResiduals,ZParameters] = cal_emsc(Raman, EMSC);

figure
set(gcf, 'Position', [posX posY sizeX sizeY])
subplot(311)
h = plot_spectra(Raman,[],2);
title('Raw Raman spectra')
subplot(312)
h = plot_spectra(ZCorrected,[],2);
title('MSC corrected Raman spectra')
subplot(313)
h = plot_spectra(ZResiduals,[],2);
title('MSC residuals')





%% (2) Basic EMSC model
[EMSC] = make_emsc_modfunc(Raman,1);
[ZCorrected,ZResiduals,ZParameters] = cal_emsc(Raman, EMSC);

figure
set(gcf, 'Position', [posX posY sizeX sizeY])
subplot(311)
h = plot_spectra(Raman,[],2);
title('Raw Raman spectra')
subplot(312)
h = plot_spectra(ZCorrected,[],2);
title('Basic EMSC corrected Raman spectra')
subplot(313)
h = plot_spectra(ZResiduals,[],2);
title('Basic EMSC residuals')





%% (3) 4th order polynomial effect EMSC model
[EMSC] = make_emsc_modfunc(Raman,5);
[ZCorrected,ZResiduals,ZParameters] = cal_emsc(Raman, EMSC);

figure
set(gcf, 'Position', [posX posY sizeX sizeY])
subplot(311)
h = plot_spectra(Raman,[],2);
title('Raw Raman spectra')
subplot(312)
h = plot_spectra(ZCorrected,[],2);
title('4th order EMSC corrected Raman spectra')
subplot(313)
h = plot_spectra(ZResiduals,[],2);
title('4th order EMSC residuals')





%% (4) Reference spectrum (baseline)
[EMSC] = make_emsc_modfunc(Raman,1);
EMSC.Model(:,4) = Raman.d(30,:)'; % Changes the reference
[ZCorrected,ZResiduals,ZParameters] = cal_emsc(Raman, EMSC);

figure
set(gcf, 'Position', [posX posY sizeX sizeY])
subplot(311)
h = plot_spectra(Raman,[],2);
title('Raw Raman spectra')
subplot(312)
h = plot_spectra(ZCorrected,[],2);
title('Reference spectrum + Basic EMSC corrected Raman spectra')
subplot(313)
h = plot_spectra(ZResiduals,[],2);
title('Reference spectrum + Basic EMSC residuals')





%% (5) Constituent spectra
% Define Weights for EMSC
M=size(ZFTIR.d,2);
ZWeights.d=ones(1,M);
ZWeights.i='SpecWeights';
ZWeights.v=ZFTIR.v;
[~,i2]=min(abs(str2num(ZWeights.v)-2200));
[~,i1]=min(abs(str2num(ZWeights.v)-2450));
ZWeights.d(1,i1:i2)=0.00000001;

% Basic EMSC corrections
[EMSCModel]=make_emsc_modfunc(ZFTIR);
[Zprocessed,ZResiduals,ZParameters]=cal_emsc(ZFTIR,EMSCModel,ZWeights);  
[EMSCModelZFLUSH]=make_emsc_modfunc(ZFLUSH);
[ZFLUSH,ZResiduals,ZParameters]=cal_emsc(ZFTIR,EMSCModelZFLUSH,ZWeights); 

figure
h = plot_spectra(Zprocessed,[],1);
title('EMSC without H2O corr')

%  Index the water variation
[~,i3450]=min(abs(str2num(Zprocessed.v)-3450.0));
Abs3450=Zprocessed.d(:,i3450);
index(Abs3450<0.23)=0;
index(Abs3450>0.23)=1;
IndexExp=num2str(index');
Zprocessed.i=[Zprocessed.i IndexExp];

UpperWn=1600.0; 
LowerWn=1700.0;  
[~,i2]=min(abs(str2num(Zprocessed.v)-UpperWn));
[~,i1]=min(abs(str2num(Zprocessed.v)-LowerWn));
Zprocessed2=selectcol(Zprocessed,[i1:i2]);
  
% Plot scores without water correction
pcamodel=pca(Zprocessed2);
figure
carte_couleur1(pcamodel.score,1,2,6,6);
xaxis=axis;
line([xaxis(1) xaxis(2)],[0 0],'color','k');
line([0 0],[xaxis(3) xaxis(4)],'color','k');
title(texlabel('without water correction 1600-1700'));
    
% Calculate the water/water vapor variation matrix
[n m]=size(ZFLUSH.d);
for i=2:n
    Diff.d(i-1,:)=ZFLUSH.d(i,:)-ZFLUSH.d(1,:);
    SampleN(i-1)=i;
end
Diff.v=ZFLUSH.v;
Diff.i=num2str(SampleN);
pca_model_diff=pca_non_centered(Diff);

% Extend model with two loading vectors from PCA on water/vapor variation
EMSC_extended=EMSCModel;
for i=1:2
    AddSpec=[];
    AddSpec.v=pca_model_diff.eigenvec.i;
    
    AddSpec.i=['H2O ',pca_model_diff.eigenvec.v(i,:)];
    AddSpec.d(1,:)=pca_model_diff.eigenvec.d(:,i)';
    [EMSC_extended]=add_spec_to_EMSCmod(EMSC_extended,AddSpec,2);
end
[Zprocessed,ZResiduals,ZParameters]=cal_emsc(Zprocessed,EMSC_extended,ZWeights);

% Further adding of a difference spectrum
EMSC_extended=EMSCModel;
ZDiffConstituent=ZFLUSH;
ZDiffConstituent.d=ZFLUSH.d(10,:)-ZFLUSH.d(1,:);

AddSpec=[];
AddSpec.v=ZDiffConstituent.v;
AddSpec.i=['H2O ']
AddSpec.d(1,:)=ZDiffConstituent.d(1,:);

[EMSC_extended]=add_spec_to_EMSCmod(EMSC_extended,AddSpec,2);
[Zprocessed,ZResiduals,ZParameters]=cal_emsc(Zprocessed,EMSC_extended,ZWeights);

figure
h = plot_spectra(AddSpec,[],1);
title('Difference spectrum')

figure
h = plot_spectra(Zprocessed,[],1);
title('EMSC with water correction')

Zprocessed1=Zprocessed;
UpperWn=1600.0; 
LowerWn=1700.0;  
[y,i2]=min(abs(str2num(Zprocessed1.v)-UpperWn));
[y,i1]=min(abs(str2num(Zprocessed1.v)-LowerWn));
Zprocessed2=selectcol(Zprocessed1,[i1:i2]);
pcamodel2=pca(Zprocessed2);

% plot scores with water correction
figure;
carte_couleur1(pcamodel2.score,1,2,6,6);
set(gcf,'Color',[1 1 1]);
FontSize=12;
xaxis=axis;
line([xaxis(1) xaxis(2)],[0 0],'color','k');
line([0 0],[xaxis(3) xaxis(4)],'color','k');
title(texlabel('with H2O corr 1600-1700'));





%% (6) Replicate correction
[EMSC] = make_emsc_modfunc(Raman,1);
EMSCWeights.d = ones(n,1);
[ZCorrectedF,ZResidualsF,ZParametersF] = emsc_rep_correction(Raman,EMSC,4,4,EMSCWeights,1);
 
figure
set(gcf, 'Position', [posX posY sizeX sizeY])
subplot(311)
h = plot_spectra(Raman,[],2);
title('Raw Raman spectra')
subplot(312)
h = plot_spectra(ZCorrectedF,[],2);
title('Replicate correction + Basic EMSC corrected Raman spectra')
subplot(313)
h = plot_spectra(ZResidualsF,[],2);
title('Replicate correction + Basic EMSC residuals')





%% Tutorial Figure 1
[EMSC] = make_emsc_modfunc(Raman,1);
[ZCorrected,ZResiduals,ZParameters] = cal_emsc(Raman, EMSC);

figure
subplot(231)
h = plot_spectra(Raman,[],2);
% title('Raw Raman spectra')
subplot(232)
h = plot_spectra(ZCorrected,[],2);
% title('Basic EMSC corrected Raman spectra')
R = Raman; R.d = R.d - ones(126,1)*mean(R.d);
subplot(234)
h = plot_spectra(R,[],2);
Z = ZCorrected; Z.d = Z.d - ones(126,1)*mean(Z.d);
subplot(235)
h = plot_spectra(Z,[],2);

EMSC.Model(:,4) = Raman.d(30,:)'; % Changes the reference
[ZCorrected,ZResiduals,ZParameters] = cal_emsc(Raman, EMSC);

subplot(233)
h = plot_spectra(ZCorrected,[],2);
% title('Reference spectrum + Basic EMSC corrected Raman spectra')
Z = ZCorrected; Z.d = Z.d - ones(126,1)*mean(Z.d);
subplot(236)
h = plot_spectra(Z,[],2);


%% Tutorial Figure 2
[EMSC] = make_emsc_modfunc(Raman,7);
[ZCorrected,ZResiduals,ZParameters] = cal_emsc(Raman, EMSC);

figure
subplot(121)
h = plot_spectra(ZCorrected,[],2);
% title('Raw Raman spectra')
R = ZCorrected; R.d = R.d - ones(126,1)*mean(R.d);
subplot(122)
h = plot_spectra(R,[],2);
% title('4th order EMSC corrected Raman spectra')
