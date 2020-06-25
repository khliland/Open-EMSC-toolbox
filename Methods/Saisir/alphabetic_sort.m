function s1=alphabetic_sort(s,start_pos,end_pos)
%alphabetic_sort       - sorts the rows of s according to the alphabetic order of rows identifiers
%function s1=alphabetic_sort(s,start_pos:end_pos)
% usefull in colouring maps
%SAISIR FUNCTION
s
key=s.i(:,start_pos:end_pos);
[bid,index]=sortrows(key);
s1=selectrow(s,index);

