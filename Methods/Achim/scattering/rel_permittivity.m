function [rPerm]=rel_permittivity(Wavenumbers,nu0,gamma,lambda,epsilonr_medium);
%rel_permittivity
%[rPerm]=rel_permittivity(Wavenumvers,nu0,gamma,lambda,epsilonr_medium);
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
%  First version: 12.08.12                                                             %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Input:                                                                              %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:      complex relative permittivity                                          %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nu1=str2num(Wavenumbers);
nu1nu1=nu1.*nu1;
nu0nu0=nu0*nu0;

b=complex(0,1);

rPerm.d(1,:)=epsilonr_medium+(lambda./(nu0nu0-nu1nu1-b*gamma.*nu1));
rPerm.v=Wavenumbers;
rPerm.i='Relative permittivity';


