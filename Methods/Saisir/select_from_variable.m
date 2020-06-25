function [saisir1] = select_from_variable(saisir,startpos,str)
%select_from_variable 		- use identifier of columns for selecting variables
%function [saisir1] = select_from_variable(saisir,startpos,str)
%Creates the data collection "saisir1" which is the subset of "saisir"
%the name of variables of which contain the string str, in starting position startpos 
bid=saisir_transpose(saisir);
bid=select_from_identifier(bid,startpos,str);
saisir1=saisir_transpose(bid);