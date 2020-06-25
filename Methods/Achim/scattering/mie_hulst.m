

function  [mie]=mie_hulst(Variables,alpha);

x=str2num(Variables);

rho=alpha*x*100;  % 100 is correcting for the unit cm^-1

mie=(2-(4./rho).*sin(rho)+(4./(rho.*rho)).*(1-cos(rho)));
%    mie=log(2-(4./rho).*sin(rho)+(4./(rho.*rho)).*(1-cos(rho)));
      