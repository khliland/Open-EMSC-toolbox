function [zmin, zmax]=surface1(saisir)
%surface1			- Represent a surface in three dimensions
%function [zmin, zmax]=surface1(saisir)
zmin=min(min(saisir.d))
zmax=max(max(saisir.d))
surf((saisir.d-zmin)/(zmax-zmin)*64);
mesh(saisir.d);
surf(saisir.d);
shading flat
	

