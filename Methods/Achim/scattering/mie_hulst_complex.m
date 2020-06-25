function  [ZQ]=mie_hulst_complex(ZRefIndexComplex,r);
%mie_hulst_complex   [ZQ]=mie_hulst_complex(ZRefIndexComplex,r)
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

nv=real(ZRefIndexComplex.d);
nvp=imag(ZRefIndexComplex.d);


x=str2num(ZRefIndexComplex.v)';
alpha=4*pi*r*(nv-1.0);
rhov=alpha.*x*100;  % 100 is correcting for the unit cm^-1

for h=1:length(nv)  
    n=nv(h);
    np=nvp(h);
    
    if (np==0)
        tanbeta=0;
        beta=0;
    else
        if (n>1)
            tanbeta=(np./(1-n));
            beta=atan(tanbeta);

        elseif (n<1)
            tanbeta=(np./(1-n));
            beta=atan(tanbeta)+pi;
        elseif (n==1)
            beta=pi/2.0; % Still correct ???? (after change from np to -np)
        end
        
    end
    
    betav(h)=beta;
    tanbetav(h)=tanbeta;
end



figure;
set(gcf,'Color',[1 1 1]);
plot(x,tanbetav,'r');
hold on;
plot(x,betav,'b');
hold on;
axis tight;
set(gca,'XDir','reverse');
xlabel('Wavenumber [cm^-^1]','FontSize',8);
ylabel('tanbeta','FontSize',8);
%title(texlabel('Mie model'),'FontSize',8);




ZQ.v=ZRefIndexComplex.v;

for h=1:length(nv)  
    n=nv(h);
    rho=rhov(h);
    beta=betav(h);
    tanbeta=tanbetav(h);
    
    if (n==0)
        n=n+0.000000001;
    end

        Q = 2.0 -  (4./rho).*exp(-rho.*tanbeta).*cos(beta).*sin(rho-beta) ...
               - (2.0./rho).*(2.0./rho).*exp(-rho.*tanbeta).*cos(beta).*cos(beta).*cos(rho-2*beta)...
               + (2.0./rho).*(2.0./rho).*cos(beta).*cos(beta).*cos(2*beta);

    ZQ.d(h)=Q;
end

ZQ.i='Mie extinction';












      