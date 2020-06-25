function  [mie]=mie_geometrical_walstra(Variables,m0,alpha);
%mie_geometrical_hulst       - calculate the approximative Mie exticntion
%
%% Input argument:
%% variables:               - wavenumbers 
%% m0           :           - refractive index
%% alpha        :           - 



nubar=str2num(Variables);

rho=alpha*nubar*100; % 100 is correcting for the unit cm^-1

r=alpha/(4*pi*(m0-1));

x=2*pi*r.*nubar*100;

z=((m0*m0-1)*(((6.*x)/pi).^(2/3))+1).^(1/2);

mie=2-(16.0*m0*m0./((m0+1)*(m0+1)*rho)).*sin(rho)+...
    4*((1-m0.*cos(rho))./(rho.*rho))...
    +7.53*((z-m0)./(z+m0)).*(x.^(-0.772));

      
