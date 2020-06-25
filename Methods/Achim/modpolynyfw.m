function [ZProcessed,ZFit] = modpolynyfw(Z,order);
%modpolynyfw - baseline estimation and correction for Raman spectra
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Nils Kristian Afseth                                                                %
%  Center for Biospectroscopy and Data Modelling                                       %
%  Matforsk                                                                            %
%  Norwegian Food Research Institute                                                   %
%  Osloveien 1                                                                         %
%  1430 Ås                                                                             %
%  Norway                                                                              %
%                                                                                      %
%  12.02.08                                                                            %
%                                                                                      %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%
%  Tilpasser et 4.gradspolynom til et gitt spektrum, og trekker det fra det
%  opprinnelige spektret. Tilpasningen skjer ved et gitt antall iterasjoner:
%  det lages en første polynomtilpasning, og polynomet sammenlignes med det
%  opprinnelige spektret. Hvis verdien til polynomet i et gitt punkt
%  overstiger verdien i det orginale spektret, så settes verdien til polynomet
%  lik verdien til det originale spektret. Det kjøres så en ny
%  polynomtilpasning mot den foreløpig siste versjonen av "polynomspektret"
%  osv....
%  Tilsutt får man et "polynomspektrum" som nærmer seg en ren baselinje av
%  det originale spektret. Den siste polynomtilpasningen trekkes til slutt fra
%  det originale spektret. 
%
%                                                                                      %
%                                                                                      %
%   Input: ZSaisir structure with Raman spectra                                        %
%          Polynomial order                                                            %
%                                                                                      %
%   Output: ZProcessed: Baseline corrected Raman spectra                               %
%           ZFit: Estimated Baseline                                                   %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  ToDo: Write description in English                                                  %
%                                                                                      %
%                                                                                      %
%  History:  New version, Frank Westad, GE Healthcare  November 17, 2006               %
%            used by Harald                                                            %
%            Adaption to saisir (Ako), 120208                                          %
%                                                                                      %
% Status: Works                                                                        %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


X=Z.d;   % ako 120208

warning('off');
[N,M]=size(X);
xw=1:M;
Xw=zeros(N,M);
for i=1:N, Xw(i,:)=xw;end,
Yfit=zeros(N,M);
Tilpass=zeros(N,M);
P=zeros(N,order+1);
Modpoly=X;

for k=1:50
  
  for i=1:N
    [P(i,:),q]=polyfit(Xw(i,:),Modpoly(i,:),order);
  end,

  for i=1:N
    Yfit(i,:) = polyval(P(i,:),Xw(i,:)); 
  end,
  
  Diff=Yfit-Modpoly;
  Punkt=find(Diff<0);
  Modpoly(Punkt)=Yfit(Punkt);
  k=k+1;
end

  Xny=X-Yfit;
%   subplot(311)
%   plot(X','b');
%   subplot(312)
%   plot(Yfit','g');
%   subplot(313)
%   plot(Xny','r');
  
  ZProcessed=Z;   % ako 120208
  ZFit=Z;   % ako 120208
  ZProcessed.d=Xny;  % ako 120208
  ZFit.d=Yfit;   % ako 120208
  




