function [pcatype] = change_sign(pcatype1,ncomp)
%change_sign 				- changes the sign of a component and of associated eigenvector
% function [pcatype] = change_sign(pcatype,ncomp)
pcatype=pcatype1;
pcatype.score.d(:,ncomp)=pcatype.score.d(:,ncomp)*(-1);
pcatype.eigenvec.d(:,ncomp)=pcatype.eigenvec.d(:,ncomp)*(-1);
