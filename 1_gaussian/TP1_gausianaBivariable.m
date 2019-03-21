clc;

%Intervalo
x1 = -3:.2:3; x2 = -3:.2:3;
[X1,X2] = meshgrid(x1,x2); %cross-product of sorts

%Parámetros
mu1=[-1 1]; sigma1 = [.25 .3; .3 1];
mu2=[1 1.5]; sigma2 = [.5 .4; .4 1];

%Densidad
F1 = mvnpdf([X1(:) X2(:)], mu1, sigma1); % (:) operator flatens matrices
F2 = mvnpdf([X1(:) X2(:)], mu2, sigma2);
F1 = reshape(F1, length(x1), length(x2)); % reshape builds a matrix from an array
F2 = reshape(F2, length(x1), length(x2));

%Gráfico
hold on;
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');
axis([-3 3 -3 3 0 .4]);
colormap([1 0 0;0 0 1]); % colors either red or blue
cmap = +(F1 < F2); % assigns 0/red when F2 is greater, 1/blue otherwise
surf(x1, x2, F1 + F2, cmap)