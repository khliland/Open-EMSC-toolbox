function [baseline,wgts] = als_baseline(Y,lambda,p)

%[baseline,wgts] = als_baseline(y,lambda,p)
%assymetric least squares estimation of baseline
%y must be column vector, or matrix with nchannels*nspectra matrix, baseline and wgts same size as y
%lambda and p are scalars
%
%Ref: Paul Eilers & Hans F. M. Boelens (2005), "Baseline Correction with
%Assymetric Least squares smoothing)"


% Fit baseline
[n,p1] = size(Y);
baseline = zeros(n,p1);
wgts = zeros(n,p1);
D = diff(speye(p1), 2);
DD = 10^lambda * (D'*D);
for i=1:n
    w = ones(p1,1);
    y = Y(i,:)';
    for it = 1:20
        W = spdiags(w, 0, p1, p1);
        C = chol(W + DD);
        z = C \ (C' \ (w .* y));
        w_old = w;
        w = p * (y > z) + (1 - p) * (y < z);
        sw = sum(w_old ~= w);
        if sw == 0, break, end
    end
    baseline(i,:) = z;
    wgts(i,:) = w;
end