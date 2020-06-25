function [ZSaisir]=LoadFromUnscrambler_v96(DirNameData,Filename);
%SaveForUnscrambler 		- loads a unscrambler matlab and puts it to a
% saisir structure
% usage: [ZSaisir]=LoadFromUnscrambler(DirNameData,Filename); 
% ZSaisir is saisir structure 
% DirNameData contains / at the end
% Filename is the file name of the unscr. matlab file
% 

NameSaisir=strcat(DirNameData,Filename);
% load the matlab file saved by Unscrambler and put it to the saisir
% structure
load(NameSaisir);
ZSaisir=[];
ZSaisir.i=num2str(ObjLabels); %num2str(SamplesName);
[N M]=size(Matrix); %size(DataMatrix);
%for i=1:M
%  Test(i)=str2num(VariableName(i,:));
%end
Test=VarLabels; %VariableName;
Test(Test==0)=' ';

ZSaisir.v=Test;

%ZSaisir.v=VariableName;
ZSaisir.d=Matrix; %DataMatrix;

