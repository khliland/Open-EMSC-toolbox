function [Zprocessed,ZScatter,ZResiduals,ZParameters,ZBeta]=correct_by_subspaceMod(ZRaw,EMSCMod,ZWeightsSpec,ModFlag);
%correct_by_subspaceMod
%[Zprocessed,ZScatter,ZResiduals,ZParameters,ZBeta]=correct_by_subspaceMod(ZRaw,EMSCMod,ZWeightsSpec);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Achim Kohler                                                                        %
%  Center for Biospectroscopy and Data Modelling                                       %
%  Matforsk                                                                            %
%  Norwegian Food Research Institute                                                   %
%  Osloveien 1                                                                         %
%  1430 Ås                                                                             %
%  Norway                                                                              %
%                                                                                      %
%  21.01.08                                                                            %
%                                                                                      %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%                                                                                      %
%  Description                                                                         %
%                                                                                      %
%                                                                                      %
%  Input:   ModFlag='Mie','Dis'
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:  
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



[Zprocessed,ZResiduals,ZParameters]=cal_emsc(ZRaw,EMSCMod,ZWeightsSpec);

%% Calculate the Mie extinctions
[N M]=size(ZResiduals.d);
ZScatter.d=zeros(N,M);
ZScatter.v=ZResiduals.v;
ZScatter.i=ZResiduals.i;
% Select the Mie scatter parameters only
ModPar=select_from_identifier(ZParameters,1,ModFlag,1);
[N NCOMP]=size(ModPar.d);

for i=1:N
    if (EMSCMod.NumBasicModelFunc==4)  % EMSC
       for j=1:(NCOMP)
          ZScatter.d(i,:)=ZScatter.d(i,:)+ModPar.d(i,j)*EMSCMod.Model(:,4+j)';
       end
       ZScatter.d(i,:)=ZScatter.d(i,:)+ ZParameters.d(i,1)*EMSCMod.Model(:,1)';
    elseif (EMSCMod.NumBasicModelFunc==2)  % MSC
       for j=1:(NCOMP)
          ZScatter.d(i,:)=ZScatter.d(i,:)+ModPar.d(i,j)*EMSCMod.Model(:,2+j)';
       end
       ZScatter.d(i,:)=ZScatter.d(i,:)+ ZParameters.d(i,1)*EMSCMod.Model(:,1)';
    end
end
            

      
%% Calculate the weights for the Mie functions
if (ModFlag=='Mie')
    ZModfunc=EMSCMod.Mie.Miefunction;
    pca_model=EMSCMod.Mie.PCAMod;
elseif (ModFlag=='Dis')
    ZModfunc=EMSCMod.Dis.Miefunction;
    pca_model=EMSCMod.Dis.PCAMod;
end
TNorm=pca_model.score.d(:,1:NCOMP)'*pca_model.score.d(:,1:NCOMP);
ZBeta.d=(inv(TNorm)*pca_model.score.d(:,1:NCOMP)')'*ModPar.d'; 
ZBeta.i=ZModfunc.i;
ZBeta.v=ZScatter.i;
ZBeta=saisir_transpose(ZBeta);   % this is B transposed, with respect to the
          
       
    



