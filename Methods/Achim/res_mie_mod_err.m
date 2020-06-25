function [MSE,ExVar]=res_mie_mod_err(pca_model,ZRefIndex,NComp,NTestFunc,AlphaMin,AlphaMax);
%res_mie_mod_err      [MSE,ExVar]=res_mie_mod_err(pca_model,NComp,NTestFunc)
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                      %
%  Achim Kohler                                                                        %
%                                                                                      %
%  08.11.11                                                                            %
%                                                                                      %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%  function                                                                            %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Input:                                                                              %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%                                                                                      %
%  Output:                                                                             %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



gammaTestValues=rand(NTestFunc,1)*0.9;
alphaTestValues=AlphaMin+rand(NTestFunc,1)*(AlphaMax-AlphaMin);

%% Loop for test functions
for i=1:NTestFunc
    
    gamma=gammaTestValues(i);
    alpha=alphaTestValues(i);
    
    ZQ=Res_Mie_Spec_scaled(ZRefIndex,alpha,gamma);
    
    
    % Create names for model functions
    alphaValue=[num2str(alpha*1000000),'                '];
    GammaValue=[num2str(gamma),'                '];
    tempname=['alpha=',alphaValue(1:15),' gamma=',GammaValue(1:15)];
    
    ZTestFunctions.i(i,:)=tempname;
    ZTestFunctions.d(i,:)=ZQ.d;
    
    
end
ZTestFunctions.v=ZRefIndex.v;

[N,K]=size(ZTestFunctions.d);
Centred=ZTestFunctions.d-ones(N,1)*pca_model.average.d;

MSE0=sum(sum(Centred.*Centred))/(N*K);

for AComp=1:NComp  % component loop
    
    
    P=pca_model.eigenvec.d(:,1:AComp);
    T=Centred*P;
    
    FEstimated=T*P';
    
    Residuals=Centred-FEstimated;
    
    MSE(AComp)=sum(sum(Residuals.*Residuals));
    MSE(AComp)=MSE(AComp)/(N*(K-AComp));
    
    
end

figure;
set(gcf,'Color',[1 1 1]);
plot(MSE)
FontSize=12;
xlabel(texlabel('# components'),'FontSize',12);
ylabel(texlabel('MSE'),'FontSize',12);

ExVar=((MSE0-MSE)/MSE0)*100;

figure;
set(gcf,'Color',[1 1 1]);
plot(ExVar)
FontSize=12;
xlabel(texlabel('# components'),'FontSize',12);
ylabel(texlabel('Explained variance (%)'),'FontSize',12);



