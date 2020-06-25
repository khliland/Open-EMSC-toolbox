function saisir=create_group2(s,startpos,endpos)
%create_group1 			- uses the identifiers to create groups
% use the identifier for creating groups.
% creates as many group means as different strings from startpos to endpos
% function saisir=create_group1(s,startpos,endpos)
% s: saisir file, startpos and enpos : position of discriminating characters 
%
if(nargin==3)
    range=startpos:endpos;
else %%(nargin =2)
    range=startpos;
end

[saisir.g.i,~,saisir.d] = unique(s.i(:,range),'rows');
saisir.g.d = histc(saisir.d,1:size(saisir.g.i,1));
saisir.g.v = 'effectif';
saisir.v = 'group';
saisir.i=s.i;
