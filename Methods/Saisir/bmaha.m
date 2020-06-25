function[discrtype]=bmaha(saisir,group)
%bmaha		- Simple discriminant analysis . Only backward
%function[discrtype]=bmaha(saisir,group)
%assess a simple linear discriminant analysis introducing rows to 1 variables
% at each step, the less discriminating variable (according to the percentage of correct
% classification) are discarded. Only backward
[nrow ncol]=size(saisir.d);
%selected=ones(1,ncol);
all=['all                                                   '];
bestchoice=1:ncol;
currentchoice=bestchoice;
classed=classify(saisir.d(:,currentchoice),saisir.d(:,currentchoice),group.d);
ncorrect=sum(classed==group.d);      
step.index(1)=0;
step.correct(1)=ncorrect
   
step.name(1,:)=all(1:size(saisir.v,2));
for discarded=1:ncol-1;
   bestcorrect=0;
   for col=1:(ncol-discarded+1)
  %   if(selected(1,col)==1)
         currentchoice=bestchoice;
         currentchoice(col)=[];
        % currentchoice
       	classed=classify(saisir.d(:,currentchoice),saisir.d(:,currentchoice),group.d);
			ncorrect=sum(classed==group.d);      
      	if(ncorrect>=bestcorrect)
         	bestcorrect=ncorrect;
         	candidate=col;
      	end;   
   	%end;      
   end;
   step.index(discarded+1)=bestchoice(candidate)
   step.correct(discarded+1)=bestcorrect
   step.name(discarded+1,:)=saisir.v(candidate,:);
   bestchoice(candidate)=[];   
end;
discrtype.step=step;
discrtype.classed.d=classed;
discrtype.classed.i=saisir.i;
discrype.classed.v='predicted group'
