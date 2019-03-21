% Generacion de datos
N_1=30;
N_2=70;
mu_1=[0.75 0.75]';
mu_2=[-1.5 -1.5]';
sigma_1=1;sigma_2=1;
rho=0.4;
Sigma_1=[sigma_1*sigma_1   rho*sigma_1*sigma_2;
         rho*sigma_1*sigma_2 sigma_2*sigma_2];
Sigma_2=[sigma_1*sigma_1   -rho*sigma_1*sigma_2;
         -rho*sigma_1*sigma_2 sigma_2*sigma_2];
X_1 = mvnrnd(mu_1,Sigma_1,N_1);
X_2 = mvnrnd(mu_2,Sigma_2,N_2);
figure(1);
scatter(X_1(:,1),X_1(:,2));
hold on
scatter(X_2(:,1),X_2(:,2));
% h=plot_gaussian_ellipsoid(mu_1, Sigma_1);
% h=plot_gaussian_ellipsoid(mu_2, Sigma_2);
% hold off

%Inicializacion
pi_1_inic=0.5;
pi_2_inic=0.5;
Sigma_1_inic=eye(2);
Sigma_2_inic=eye(2);
mu_1_inic=[-1 1]';
mu_2_inic=[1 -1]';
h=plot_gaussian_ellipsoid(mu_1_inic, Sigma_1_inic);
h=plot_gaussian_ellipsoid(mu_2_inic, Sigma_2_inic);
hold off

%Expectation
X=[X_1;X_2];
pi_1_old=pi_1_inic;
pi_2_old=pi_2_inic;
% pi_old=[pi_1_old pi_2_old]';
mu_1_old=mu_1_inic;
mu_2_old=mu_2_inic;
Sigma_1_old=Sigma_1_inic;
Sigma_2_old=Sigma_2_inic;
g=pi_1_old*mvnpdf(X,mu_1_old',Sigma_1_old);
g=[g pi_2_old*mvnpdf(X,mu_2_old',Sigma_2_old)];
vec_norm=sum(g,2);
g=g./[vec_norm vec_norm];


%Maximization
JUST DO IT!!!
