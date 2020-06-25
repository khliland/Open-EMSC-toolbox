function [ZExtinction]=one_dim_cell_scattering(ZAbsorbance,radius)
%one_dim_cell_scattering   [ZExtinction]=one_dim_cell_scattering(ZRefractiveIndex)
%
%                             'Calculates the extinction for a one-dimensional cell'
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Achim Kohler                                                                        %
%                                                                                      %
%  Biospectroscopy and Data Modelling Group                                            %
%  Dept. of Mathematical Sciences and Technology                                       %
%  Norwegian University of Life Sciences (www.umb.no)                                  %
%                                                                                      %
%  Homepage: http://arken.umb.no/~achik/                                               %
%                                                                                      %
%                                                                                      %
%  First version: 21.06.11                                                             %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Input:       Absorbance spectrum                                                    %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:      extinction spectrum                                                    %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Take the parameters from saisir
nu=str2num(ZAbsorbance.v)';
absorbance=ZAbsorbance.d;
r=radius*100.0;  % 100 is correcting for the unit cm^-1 


% check inputs are the same length
if(length(nu) ~= length(absorbance));
    error('wavenumber and absorbance should be the same length');
end

% check that absorbance contains only one spectrum
[N,M]=size(absorbance);

if (absorbance>1)
     error('input contains more than one spectrum');
end

Min=min(absorbance);
Max=max(absorbance);

if (abs(Max-Min)==0)
   ZN.v=ZAbsorbance.v;
   ZN.d=1.3*ones(1,M); 
   ZN.i='Refractive index spectrum';
else
    [ZN]=kramers_kronig_transform(ZAbsorbance);
    ZN.d=ZN.d+1.3;
end

figure;
set(gcf,'Color',[1 1 1]);
plot(str2num(ZN.v),ZN.d,'r');
axis tight;
set(gca,'XDir','reverse');
xlabel('Wavenumber [cm^-^1]','FontSize',8);
ylabel('Absorption','FontSize',8);
title(texlabel('Refractive index spectrum'),'FontSize',8);



n=ZN.d;

A=4*n.*n;
B=(1-n.*n);
C=sin((n*4*pi).*(nu*r));
D=4*n.*n;

T=A./(B.*B.*C.*C+D);
A=-log(T);
ZExtinction.d=A;
ZExtinction.v=ZAbsorbance.v;







