clear -variables
close all

addpath ..
biips_clear

olddir = cd('../private');

% sample data
X=4*randn(1,30)+12+0.5*randn(1,30)-3;

% biips kde
w=ones(size(X))/length(X);
bw=bw_select(X, w);
s=kde(X, w, bw, 100);

figure; hold on
subplot(2,1,1)
plot(s.x,s.f);

% matlab kde
[f,x,u]=ksdensity(X);
subplot(2,1,2)
plot(x,f);

cd(olddir);
