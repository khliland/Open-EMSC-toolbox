function[discrtype]=maha(saisir,group,maxvar)
%maha 	- simple discriminant analysis forward introducing variables no validation samples 
%function[discrtype]=maha(saisir,group,maxvar)
%assess a simple quadratic discriminant analysis introducing up to maxvar variable
% at each step, the more discriminating variable (according to the percentage of correct
% classification) is introduced. Only forward
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
end;
discrtype.step=step;
discrtype.classed.d=classed;
discrtype.classed.i=saisir.i;
discrtype.classed.v='predicted group'
