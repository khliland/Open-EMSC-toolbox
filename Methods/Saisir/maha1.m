function[discrtype]=maha1(saisir,group,maxvar,test,testgroup)
%maha1 			- forward discriminant analysis DIRECTLY ON DATA with validation samples
% function[discrtype1]=maha1(calibration,calibration_group,maxvar,test,test_group)
% assess a simple linear discriminant analysis introducing up to maxvar variable
% at each step, the more discriminating variable (according to the percentage of correct
% classification of the calibration set) is introduced. Only forward
% TO BE TESTED ON 10/3/2000
% see also maha
[nrow ncol]=size(saisir.d);
selected=zeros(1,ncol);
bestchoice=[];
for introduced=1:maxvar
   bestcorrect=0;
   for col=1:ncol
      if(selected(1,col)==0)
         currentchoice=[bestchoice;col];
         classed=classify(saisir.d(:,currentchoice),saisir.d(:,currentchoice),group.d);
         ncorrect=sum(classed==group.d);      
      	if(ncorrect>bestcorrect)
         	bestcorrect=ncorrect;
         	candidate=col;
      	end;   
   	end;      
   end;
   step.index(introduced)=candidate
   step.correct(introduced)=bestcorrect
   step.name(introduced,:)=saisir.v(candidate,:);
   selected(1,candidate)=1;
	bestchoice=[bestchoice;candidate];   
	testclassed=classify(test.d(:,bestchoice),saisir.d(:,bestchoice),group.d);   
	step.ntestcorrect(introduced)=sum(testclassed==testgroup.d);   
end;
discrtype.step=step;
discrtype.classed.d=classed;
discrtype.classed.i=saisir.i;
discrype.classed.v='predicted group (calibration)'
discrtype.testclassed.d=testclassed;
discrtype.testclassed.i=testgroup.i;
discrype.classed.v='predicted group (validation)'


