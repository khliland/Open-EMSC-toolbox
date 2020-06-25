function  [ZR]=fringes_R_complex(ZRefIndexComplex,a);
%fringes_R_complex   [ZR]=fringes_R_complex(ZRefIndexComplex,a)
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
%  First version: 15.08.12                                                             %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Input:       complex refractive index                                               %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:      Reflection probability R                                               %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%

m=ZRefIndexComplex.d;
x=100.0*str2num(ZRefIndexComplex.v)'; % 100 is correcting for the unit cm^-1
rho=2.0*pi.*m.*x*a;

ic=complex(0.0,1);

Nominator=(1-m.*m).*sin(rho);
Denominator=(1+m.*m).*sin(rho)+2*ic.*m.*cos(rho);


ZR.d=abs(Nominator./Denominator).*abs(Nominator./Denominator);
ZR.v=ZRefIndexComplex.v;














      