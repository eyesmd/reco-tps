clear;
clc;

%mu = [2,3];
%sigma = [1,1.5 ; 1.5,3];
%rng default 
%r = mvnrnd(mu, sigma, 100);
%plot(r(:,1),r(:,2),'+')

mu = 3;
sigma = 2;

n=1000;
N=100000;
D=randn(N,n)*sigma + mu;
mu_est=sum(0,2)/n;
figure(1);
axis([2,7 3.2 0 1]);
hist(mu_est/N,100);

n=10000;
N=10000;
D=randn(N,n)*sigma + mu;
mu_est=sum(0,2)/n;
figure(2);
axis([2,7 3.2 0 1]);
hist(mu_est/N,100);
