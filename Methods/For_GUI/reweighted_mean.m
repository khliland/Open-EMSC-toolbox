function [EMSCModel,A] = reweighted_mean(ZSaisir,EMSCModel,ZWeights,tol,doplot)

C = [    0         0    1.0000
    0    0.5000         0
    1.0000         0         0
    0    0.7500    0.7500
    0.7500         0    0.7500
    0.7500    0.7500         0
    0.2500    0.2500    0.2500];

if nargin < 3
    ZWeights.d = ones(1,size(ZSaisir.d,2));
end
if nargin < 4
    tol = 1;
end
if nargin < 5
    doplot = 1;
end

Ref = 0;
for i=1:size(EMSCModel.ModelSpecNames,1)
    if strfind(EMSCModel.ModelSpecNames(i,:),'Reference')
        Ref = i;
    end
end
Reference = EMSCModel.Model(:,Ref);
Old_Reference = zeros(size(Reference));

if doplot == 1
    figure
    plot_spectra(ZSaisir,[],2);
    hold on
    p = size(ZSaisir.d,2);
    xlabs = zeros(p,1);
    for i=1:p
        xlabs(i,1) = str2double(ZSaisir.v(i,:));
    end
    plot(xlabs,Reference,'-', 'LineWidth',2,'Color',[0 0 0])
    p1 = plot(xlabs,Reference,'--', 'LineWidth',2,'Color',[1 1 0]);
end

i = 0;
while sum((Reference-Old_Reference).^2) > tol && i < 100
    [~,ZResiduals]=cal_emsc(ZSaisir,EMSCModel,ZWeights);
    B = sum(ZResiduals.d.^2,2);
    A = sum(B)./B;
    A = A./sum(A);
    Old_Reference = Reference;
    Reference = ZSaisir.d'*A;
    EMSCModel.Model(:,Ref) = Reference;
    i = i+1;
end
if doplot == 1
    plot(xlabs,Reference, '-k', 'LineWidth',2)
    p2 = plot(xlabs,Reference, '--', 'LineWidth',2, 'Color', [0 1 1]);
    legend([p1 p2],'Mean','Weighted mean')
end
disp(['Difference: ' num2str(sum((Reference-Old_Reference).^2)) ' after ' num2str(i) ' iterations'])