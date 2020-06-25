function  [ZQ]=mie_hulst_real(ZRefIndex,r);
%mie_hulst_real   [ZQ]=mie_hulst_real(ZRefIndexComplex,r)
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
%  First version: 09.08.12                                                             %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Input:       complex refractive index                                               %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:      extinction spectrum for a sphere                                       %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%

x=str2num(ZRefIndex.v)';
alpha=4*pi*r*(ZRefIndex.d-1.0);

rho=alpha.*x*100;  % 100 is correcting for the unit cm^-1

ZQ.v=ZRefIndex.v;
ZQ.d=(2-(4./rho).*sin(rho)+(4./(rho.*rho)).*(1-cos(rho)));













      