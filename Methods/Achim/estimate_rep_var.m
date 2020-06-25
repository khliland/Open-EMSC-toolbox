function [MSE,MSEWG]=estimate_rep_var(ZData,SamplesNameStart,SamplesNameEnd,LowerWn,UpperWn);
% [MSE,MSEWG]=estimate_rep_var(ZDatasel,SamplesNameStart,SamplesNameEnd);
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
%  21.04.10                                                                            %
%                                                                                      %
%                                                                                      %
%--------------------------------------------------------------------------------------%
%                                                                                      %
%  Input:                                                                              %
%                                                                                      %
%  Output:                                                                             %
%                                                                                      %
%                                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% calcualte the means square error (within and between samples)


[y,i2]=min(abs(str2num(ZData.v)-LowerWn));
[y,i1]=min(abs(str2num(ZData.v)-UpperWn));
ZDatasel=selectcol(ZData,[i1:i2]);

AverageRep=split_average(ZDatasel,SamplesNameStart,SamplesNameEnd);
ZAverageRep=AverageRep.average;
ZMean=mean(ZAverageRep.d,1);
[N K]=size(ZAverageRep.d); % N is the number of strains
sum=0;

for i=1:N
    sum=sum+(ZAverageRep.d(i,:)-ZMean).*(ZAverageRep.d(i,:)-ZMean);
end

SSBetweenGroups=sum;
MSE.d=SSBetweenGroups/(N);
MSE.i='MSE between groups';
MSE.v=ZDatasel.v;

gSampleGroup=create_group1(ZDatasel,SamplesNameStart,SamplesNameEnd);
N=size(gSampleGroup.g.i,1); % N is the number of strains
for i=1:N
   % Find replicates for this sample
   ZSelected=select_from_identifier(ZDatasel,SamplesNameStart,gSampleGroup.g.i(i,:)); 
   [nRep,nVar]=size(ZSelected.d);
   % Compute replicate means
   Mean.d=mean(ZSelected.d,1);
   Mean.i='Mean Z corrected';Mean.v=ZSelected.v;
   % Residuals
   ZResiduals=ZSelected;
   ZResiduals.d=ZSelected.d-ones(nRep,1)*Mean.d;
   %% Compute mean and residuals around mean for this sample
   Means.d(i,:)=Mean.d;
   Means.i(i,:)=Mean.i;    
   if (i==1)
       Deviations=ZResiduals;
   else
       Deviations=appendrow(Deviations,ZResiduals); 
   end
        
end
Means.v=ZDatasel.v; %add variable names

NTot=size(Deviations.d,1); % NTot is the total number of spectra
for i=1:NTot
    sum=sum+(Deviations.d(i,:)).*(Deviations.d(i,:));
end

SSWithinGroups=sum;
MSEWG.d=SSWithinGroups/(NTot);
MSEWG.i='MSE within groups';
MSEWG.v=ZDatasel.v;

