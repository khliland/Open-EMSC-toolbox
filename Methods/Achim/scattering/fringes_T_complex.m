function  [ZT]=fringes_T_complex(ZRefIndexComplex,a);
%fringes_T_complex   [ZT]=fringes_T_complex(ZRefIndexComplex,a)
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
%  Output:      Transmission probability T                                             %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%

m=ZRefIndexComplex.d;
x=100.0*str2num(ZRefIndexComplex.v)'; % 100 is correcting for the unit cm^-1
rho=2.0*pi.*m.*x*a;

ic=complex(0.0,1);

Nominator=2*ic.*m.*exp(-2*pi*ic.*x*a);
Denominator=(1+m.*m).*sin(rho)+2*ic.*m.*cos(rho);


ZT.d=abs(Nominator./Denominator).*abs(Nominator./Denominator);
ZT.v=ZRefIndexComplex.v;














      