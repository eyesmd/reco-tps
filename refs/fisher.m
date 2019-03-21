% Clase omega_1
N_1=30;
mu_1=[0;0];
sigma1_1=1;
sigma2_1=1;
rho_1=0.5;
Sigma_1=[sigma1_1^2 rho_1*sigma1_1*sigma2_1;
    rho_1*sigma1_1*sigma2_1 sigma2_1^2];

% Clase omega_2
N_2=45;
mu_2=[2;2];
sigma1_2=0.5;
sigma2_2=0.5;
rho_2=0.5;
Sigma_2=[sigma1_2^2 rho_2*sigma1_2*sigma2_2;
    rho_2*sigma1_2*sigma2_2 sigma2_2^2];

X_1 = mvnrnd(mu_1,Sigma_1, N_1);
X_2 = mvnrnd(mu_2,Sigma_2, N_2);
plot(X_1(:,1),X_1(:,2),'.r');
hold on
plot(X_2(:,1),X_2(:,2),'.b');
%hold off

m_1=mean(X_1);
m_2=mean(X_2);
plot(m_1(:,1),m_1(:,2),'or');
plot(m_2(:,1),m_2(:,2),'ob');
S_1= cov(X_1);
S_2= cov(X_2);
S_W= S_1+S_2;
w=inv(S_W)*(m_1 - m_2)';
plotv(w);
hold off

figure(2);
w=w/norm(w);
proy_1=w'*X_1';
proy_2=w'*X_2';

plot(proy_1,zeros(1,N_1),'xr')
hold on
plot(proy_2,zeros(1,N_2),'+b')
hold off
