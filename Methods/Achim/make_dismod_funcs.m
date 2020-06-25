function [functions]=make_dismod_funcs(ZAbs)

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
%  15.03.09                                                                            %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%                                                                                      %
%  Description                                                                         %
%                                                                                      %
%                                                                                      %
%  Input:   (Paul,to be revised)
%
%             a,b, etc input should be described here                                  %
%                                                                                      %
%                                                                                      %
%  Output:  
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% % clear all; close all; clc;
% % tic
% % load RefIndex_4res.mat;                         % Loads the refractive index spectrum
% % RefIndexWN=RefIndX_4res;                        % Wavenumbers
% % RefIndexIN=RefIndY_4res;                        % Intensity values

RefIndexWN=str2num(ZAbs.v);
RefIndexABS=ZAbs.d';

% Calculate the refractive index by Kramers-Kronig relation
RefIndexN=kkre(RefIndexWN,RefIndexABS);
RefIndexIN=RefIndexN/abs(min(RefIndexN));      %minRI=abs(min(RefIndexIN))

% Define the parameter space
Acoeff=linspace(1.1,1.3,10);
b_spacings=10;
RSize=linspace(2e-6,20e-6,10);  %2.5e-6; %


RowSizeOfMatrix=length(Acoeff)*b_spacings*length(RSize);
functions.d=zeros(RowSizeOfMatrix,length(RefIndexWN));

min_start=3;
hh=0;
for RR=1:length(RSize)  % Start of Mie loop

    for aa=1:length(Acoeff);   a=Acoeff(aa);
                     
        Bcoeff=linspace(0.0,a-1.01,b_spacings);     % Dynamic creation of b coefficient
        
        for bb=1:length(Bcoeff);    b=Bcoeff(bb);

            hh=hh+1;
            n=(a+b*RefIndexIN);
            p=((4*pi*RSize(RR))*(n-1)).*RefIndexWN*100;                       
            functions.d(hh,:)=2-(4./p).*sin(p)+(4./(p.^2)).*(1-cos(p));
            tempname=['a=', num2str(a) ,' b=',num2str(b) '                     '];
            functions.i(hh,:)=tempname(1:5);
            
            if  min(n)<=min_start;
                min_start=min(n);
            end
        end
    end
   
end                     % End of Mie loop

functions.v=num2str(RefIndexWN);

figure;
plot(str2num(functions.v),functions.d)
%axis tight;
set(gca,'XDir','reverse')
xlabel('Wavenumber/cm^{-1}')
ylabel('Q (Scatter Efficiency)')

end


% % starting_pca=toc
% % PCAMod=pca(functions);
% % finished_pca=toc
% % if  RowSizeOfMatrix<=15;
% %     pc_max=RowSizeOfMatrix;
% % else
% %     pc_max=40;
% % end
% % Percent_explained=(PCAMod.score.v(1:pc_max-1,:))
% % 
% % min_start
