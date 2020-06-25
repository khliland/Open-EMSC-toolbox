function kcarte(s3,col1,col2)
%kcarte            - representation  of a cube of data
%function kcarte(s3,col1,col2)
%s3 is a saisir cube format with s3.d having 3 dimensions. 
%s3.i contains the row identifiers
%s3.v the column identifiers
%s3.z the z identifiers ("depth" of the data cube).
%The function  represents the column col1 and col2 for each of the
%"slice" in z .
%Each subplot is untitled using the corresponding identifer in z.  
%Warning ! not very smart for more than 8 slices in z.
%Does not accept more than 16 slices.  

[n,p,z]=size(s3.d);
figure;
hold off;
%      1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]
smart=[1,2,2,2,3,3,3,3 3 4  4  4  4  4  4  4 ];
if(z>16)
    error('Unable to represent more than 16 biplots on a single screen');
end

for k=1:z
    subplot(smart(z),smart(z),k);
    x2.d=s3.d(:,:,k);
    x2.i=s3.i;
    x2.v=s3.v;
    carte(x2,col1,col2);
    title(s3.z(k,:));
end
%set(gcf,'NextPlot','add');
%newplot;
