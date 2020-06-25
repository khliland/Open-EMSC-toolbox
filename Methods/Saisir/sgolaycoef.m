function [B,G] = sgolaycoef(k,F)
%sgolaycoef         - Computes the Savitsky-Golay coefficients
%function [B,G] = sgolaycoef(k,F) 
%where the polynomial order is K and the frame size is F (an odd number)
%No direct use

W = eye(F);
s = fliplr(vander(-(F-1)/2:(F-1)/2));
S = s(:,1:k+1);   % Compute the Vandermonde matrix

[~,R] = qr(sqrt(W)*S,0);

G = S/(R)*inv(R)'; % Find the matrix of differentiators

B = G*S'*W; % Compute the projection matrix B