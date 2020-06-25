function [ZSaisirReduced]=select_specRegions(ZSaisir,Upper,Lower);
%select_specRegions
%[ZSaisirReduced]=select_specRegions(ZSaisir,Upper,Lower);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Achim Kohler                                                                        %
%  Center for Biospectroscopy and Data Modelling                                       %
%  Nofima Mat                                                                          %
%  Norwegian Food Research Institute                                                   %
%  Osloveien 1                                                                         %
%  1430 Ås                                                                             %
%  Norway                                                                              %
%                                                                                      %
%  18.03.10                                                                            %
%                                                                                      %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%                                                                                      %
%  Description: Selects spectral regions in saisir structure                           %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:  
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


N1=size(Upper,2);
N2=size(Lower,2);
if (N1==N2)
    NRegions=N1;
else
    error('Upper and Lower must have the same size')
end


for i=1:NRegions
    WN1=Lower(i);
    WN2=Upper(i);
    [y,i1]=min(abs(str2num(ZSaisir.v)-WN1));
    [y,i2]=min(abs(str2num(ZSaisir.v)-WN2));
    Aux=selectcol(ZSaisir,[i1:i2]);
    if (i==1)
        ZSaisirReduced=Aux;
    else
        ZSaisirReduced=appendcol(ZSaisirReduced,Aux);
    end
end


