n=10000;
D=rand(n,2)-0.5;
figure(1),plot(D(:,1),D(:,2),'.');
p=zeros(1,n);
dist=sqrt(D(:,1).^2+D(:,2).^2);
for i=1:n
    k_n=length(find(dist(1:i)<=(sqrt(1/(pi*sqrt(i))))));
    p(i)= (k_n/i)/(1/sqrt(i));
end
figure(2), plot(p);


