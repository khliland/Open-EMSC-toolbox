function [EMSCFriMod]=make_fringes_emsc_mod(ZRef,options);
% make_fringes_emsc_mod
%[EMSCFriMod]=make_fringes_emsc_mod(ZRef,,options);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Achim Kohler, Nofima Mat, Center for Biospectroscopy and Data Modelling             %
%  Osloveien 1                                                                         %
%  1430 Ås                                                                             %
%  Norway                                                                              %
%                                                                                      %
%  and                                                                                 %
%                                                                                      %
%  Paul Bassan, University of Manchester, UK                                           %
%                                                                                      %
%  17.03.10                                                                            %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%                                                                                      %
%  Description                                                                         %
%                                                                                      %
%                                                                                      %

% Inputs:
%   - WN - Wavenumber vector (COLUMN)
%   - ZRef - A reference spectrum (ROW vector)
%   - options - options for the correction

% Outputs
%   - ZCorr - Corrected spectra (ROWS)
%   - fringe - Fringing spectra removed (ROWS)
%   - residuals - Residuals (ROWS)

% Written by:-
%   - Paul Bassan, University of Manchester, UK
%   - Achim Kohler, Nofima Mat. Norway

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


%% Define the parameters
f_lower = options.lowerfreq;        % Lower frequency
f_upper = options.upperfreq;        % Upper frequency

n_freqs = options.numfreqs;         % Spacings for the frequencies
n_phases = options.numphases;       % Spacings for the phases

NCOMP = options.NCOMP;              % Number of principal components used
BaseModFlag=options.BaseModFlag;    % 1 MSC 2 Physical EMSC


%% Build sin matrix
phases = linspace(0, 2*pi , n_phases);              % Range of phases to cover, 0 to 2*pi covers whole range
freqs = linspace(f_lower , f_upper , n_freqs);      % Range of frequencies to cover
WN=str2num(ZRef.v);
ZSinwaves.d = zeros( length(phases)*length(freqs) , length(WN) );      % Allocate space, zeros matrix
k = 0;
for i = 1 : length(phases)
    p = phases(i);                                  % p = phase within this loop
    for j = 1 : length(freqs)
        k = k + 1;
        f = freqs(j);                               % f = frequency within this loop
        P(k)=p;
        F(k)=f;
        ZSinwaves.d(k,:) = sin( f*2*pi*WN - p );
    end
end
NamesP=num2str(P');
NamesF=num2str(F');
NamesPP = addcode(NamesP,'P');
NamesFF = addcode(NamesF,'F');
ZSinwaves.i=[NamesPP,NamesFF];
ZSinwaves.v=ZRef.v;


%% decompose the set of Mie functions
if (PCA_Centered)
   pca_model=pca(ZSinwaves);
else
   pca_model=pca_non_centered(ZSinwaves);
end
  

%% Construct the Fringes model with ref spec
[EMSCFriMod]=make_emsc_modfunc(ZRef,BaseModFlag);

for i=1:NCOMP
    AddSpec=[];
    AddSpec.v=pca_model.eigenvec.i;
    AddSpec.d(1,:)=pca_model.eigenvec.d(:,i)';
    AddSpec.i=['Fri ',pca_model.eigenvec.v(i,:)]
    [EMSCFriMod]=add_spec_to_EMSCmod(EMSCFriMod,AddSpec,2);
end

if (PCA_Centered) % Add the mean spectrum
    AddSpec=[];
    AddSpec.v=pca_model.eigenvec.i;
    AddSpec.d(1,:)=pca_model.average.d;
    AddSpec.i='Fri PCA mean';
    [EMSCFriMod]=add_spec_to_EMSCmod(EMSCFriMod,AddSpec,2);
end

% Keep the Mie model data
EMSCFriMod.Fri.PCAMod=pca_model;
EMSCFriMod.Fri.PCANCOMPused=NCOMP;
EMSCFriMod.Fri.Frifunction=ZSinwaves;
EMSCFriMod.Fri.PCA_Centered=PCA_Centered;


figure;
FontSize=8;
set(gcf,'Color',[1 1 1]);
plot(str2num(AddSpec.v),EMSCFriMod.Model','k');
axis tight;
xlabel('Wavenumber [cm^-^1]','FontSize',8);
ylabel('Absorption','FontSize',8);
title(texlabel('PCA model'),'FontSize',8);
set(gca,'XDir','reverse');
       
        
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
plot(iExpVar(1:15),ExpVarCum(1:15),'k');
axis tight;
xlabel('#components','FontSize',8);
ylabel('Explained variance','FontSize',8);
title(texlabel('Explained variance for Mie model'),'FontSize',8);
set(gcf,'Color',[1 1 1]);

