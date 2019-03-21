%SIGMA, RHO CONSTRUCTION
% sigmas = [];
% for i = 1:6
%   desv = rand(1, 3) * 10;
%   rhos = (rand(1, 3) * 2) - 1;
%   matriz = [desv(1)^2  rhos(1)*desv(1)*desv(2)  rhos(2)*desv(1)*desv(3);
%             rhos(1)*desv(2)*desv(1)  desv(2)^2  rhos(3)*desv(2)*desv(3);
%             rhos(2)*desv(3)*desv(1)  rhos(3)*desv(3)*desv(2)  desv(3)^2];
%   det(matriz)        
%   eig(matriz)
% end

%ALTERNATIVE SAMPLING
% value = zeros(400, 640, 3);
% for i = 1:400
%   for j = 1:640
%     pixel = [phantom(i,j,1) phantom(i,j,2) phantom(i,j,3)];
%     for h = 1:6
%       if all(pixel == COLORS(h,:))
%         value(i,j,:) = mvnrnd(COLORS(h,:)',sigmas(:,:,h));
%         break;
%       end
%     end
%   end
% end