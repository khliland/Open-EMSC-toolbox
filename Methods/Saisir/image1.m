function h=image1(saisir,zmin,zmax)
%image1 			- Represents a surface in false color
%function image1(saisir,(zmin),(zmax))
%returns the lowest and highest values of the matrix
%which correspond to the "extreme" false colors
if(nargin==1)
zmin=min(min(saisir.d))
zmax=max(max(saisir.d))
end
h=image((saisir.d-zmin)/(zmax-zmin)*64);
%axis equal;
axis image;
%image((saisir.d-zmin)/(zmax-zmin)*256);


	

