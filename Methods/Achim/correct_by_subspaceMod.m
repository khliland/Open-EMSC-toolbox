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
%  Input:   ModFlag='Mie', ...
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:  
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



[Zprocessed,ZResiduals,ZParameters]=cal_emsc(ZRaw,EMSCMod,ZWeightsSpec);

%% Calculate the scatter estimations
[N M]=size(ZResiduals.d);
ZScatter.d=zeros(N,M);
ZScatter.v=ZResiduals.v;
ZScatter.i=ZResiduals.i;
% Select the Mie scatter parameters only
ModPar=select_from_identifier(ZParameters,1,ModFlag,1);
[N NCOMP]=size(ModPar.d);

ZEMSCMod=emscmod_to_saisir(EMSCMod);
ZModSpec=select_from_identifier(ZEMSCMod,1,ModFlag,0);


for i=1:N
    for j=1:(NCOMP)
       ZScatter.d(i,:)=ZScatter.d(i,:)+ModPar.d(i,j)*ZModSpec.d(j,:);
    end
    if ((ModFlag=='Mie')|(ModFlag=='Fri')|(ModFlag=='PAR')|(ModFlag=='Res'))
        if (EMSCMod.NumBasicModelFunc==4)  % EMSC
           for j=1:3
               ZScatter.d(i,:)=ZScatter.d(i,:)+ ZParameters.d(i,j)*EMSCMod.Model(:,j)';
           end
        elseif (EMSCMod.NumBasicModelFunc==2|EMSCMod.NumBasicModelFunc==1)  % MSC
           ZScatter.d(i,:)=ZScatter.d(i,:)+ ZParameters.d(i,1)*EMSCMod.Model(:,1)';
        end
    end
end
            

      
%% Calculate the weights for the Mie functions
if (ModFlag=='Mie')
    ZModfunc=EMSCMod.Mie.Miefunction;
    pca_model=EMSCMod.Mie.PCAMod;
elseif (ModFlag=='Res')    
    ZModfunc=EMSCMod.Res.Miefunction;
    pca_model=EMSCMod.Res.PCAMod;  
elseif (ModFlag=='Rep')    
    ZModfunc=EMSCMod.Rep.Deviations;
    pca_model=EMSCMod.Rep.PCAMod;
elseif (ModFlag=='SL ')    
    ZModfunc=EMSCMod.SL.SLfunction;
    pca_model=EMSCMod.SL.PCAMod;    
elseif (ModFlag=='Fri')    
    ZModfunc=EMSCMod.Fri.Frifunction;
    pca_model=EMSCMod.Fri.PCAMod;        
end

%% Projection does not work for the centred case, since the average spec is not orthogonal to the rest ???
T=ZModfunc.d*pca_model.eigenvec.d(:,1:NCOMP);
TNorm=T'*T;
ZBeta.d=(inv(TNorm)*T')'*ModPar.d'; 
ZBeta.i=ZModfunc.i;
ZBeta.v=ZScatter.i;
ZBeta=saisir_transpose(ZBeta);   % this is B transposed, with respect to the
          
       
    



