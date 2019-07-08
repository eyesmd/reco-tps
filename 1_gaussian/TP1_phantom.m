
%PREAMBULO+++++++++++++++++++
% Tengo un imagen dividida en 6 regiones. Voy a imaginar que en cada region
% ocurre un proceso que genera una color por cada pixel.

clc; clear;
phantom = double(imread('phantom.png'));



% PARSEO DE VERDAD TERRESTRE +++++++++++++++++ 

printf('Extrayendo las verdaderas clases de cada pixel...\n\n');

global COLORS = double([123 239 134; 126 123 239;  80 147  53;
                201 199  60; 188 152  81; 239 124  67]);

function ret = squared_distances_to(matrix, point)
  r_difference = abs(matrix(:,:,1) .- point(1)); % broadcast
  g_difference = abs(matrix(:,:,2) .- point(2)); % broadcast
  b_difference = abs(matrix(:,:,3) .- point(3)); % broadcast
  ret = r_difference .^2 + g_difference .^2 + b_difference .^2;
endfunction

%function ret = minimum(a, b)
  %ret = merge(a < b, a, b);                              (merge)
  %cond = a < b; ret = cond .* a + not(cond) .* b         (mask)
  %cond = a < b; a(!cond) = 0; b(cond) = 0; ret = a + b   (indexing)
%endfunction

classes = zeros(400, 640, 'uint8');
min_squared_distances = inf(400, 640);
for c = 1:6
  squared_distances = squared_distances_to(phantom, COLORS(c,:));
  is_minimum = squared_distances < min_squared_distances;
  classes(is_minimum) = c;
  min_squared_distances = min(min_squared_distances, squared_distances);
end

clear c, squared_distances is_minimum min_squared_distances;



% GENERACIÓN DE PARÁMETROS ++++++++++++++++++

printf('Asignando los parámetros a las densidades de clase...\n');

function sigmas = iso_generate_sigmas()
  global COLORS;
  sigmas = zeros(3, 3, 6);
  var = rand(1) * 80 + 200;
  temp = eye(3) * var;
  for i = 1:6
    sigmas(:,:,i) = temp;
  end
endfunction

function sigmas = diag_generate_sigmas()
  sigmas = zeros(3, 3, 6);
  for i = 1:6
    vars = rand(1,3) * 80 + 80;
    temp = [vars(1) 0 0 ; 0 vars(2) 0; 0 0 vars(3)];
    sigmas(:,:,i) = temp;
  end
endfunction

function sigmas = arb_generate_sigmas()
  for i = 1:6
    sigmas = zeros(3, 3, 6);
    temp = rand(3)/2 + 0.5; % matriz aleatoria
    temp = (temp * temp') + 3 * eye(3);  % definida positiva
    temp = temp * 30; % aumento la proba de que haya variación y correlacion
    sigmas(:,:,i) = temp;
  end
endfunction

mus = COLORS;
iso_sigmas = iso_generate_sigmas();
diag_sigmas = diag_generate_sigmas();
arb_sigmas = arb_generate_sigmas();



% MUESTREO ++++++++++++++++++

printf('Muestreando...\n');

function ret = sample(classes, mus, sigmas)
  ret = zeros(400, 640, 3);
  for c = 1:6
    indexes = find(classes == c);
    samples = mvnrnd(mus(c,:), sigmas(:,:,c), length(indexes));
    ret(indexes) = samples(:,1);             % red
    ret(indexes + 400*640) = samples(:,2);   % green
    ret(indexes + 400*640*2) = samples(:,3); % blue
  end
endfunction

iso_samples = sample(classes, mus, iso_sigmas);
diag_samples = sample(classes, mus, diag_sigmas);
arb_samples = sample(classes, mus, arb_sigmas);



% CLASIFICACIÓN ++++++++++++++++++

printf('Clasificando...\n');

function ret = classify(linear_samples, mus, sigmas)
  ret = zeros(400, 640, 'uint8');
  max_likelihoods = zeros(400, 640);
  for c = 1:6
    likelihoods = reshape(mvnpdf(linear_samples, mus(c,:), sigmas(:,:,c)), [400 640]);
    is_maximum = likelihoods > max_likelihoods
    ret(is_maximum) = c;
    max_likelihoods = max(likelihoods, max_likelihoods);
  end
endfunction

linear_samples = reshape(samples, [400*640 3]);
iso_classifications = classify(linear_samples, mus, iso_sigmas);
diag_classifications = classify(linear_samples, mus, diag_sigmas);
arb_classifications = classify(linear_samples, mus, arb_sigmas);


% ANÁLISIS ++++++++++++++++++++++

printf('Preparando funciones de análisis...\n');

function picture(matrix)
  if length(size(matrix)) == 3
    image(uint8(matrix))
  else
    imshow(matrix, [1 1 1; 1 0 0 ; 0 1 0 ; 0 0 1 ; 1 1 0 ; 1 0 1 ; 0 1 1]);
  end
endfunction

function ret = confusion(real, estimations)
  ret = zeros(6,6,'uint32');
  for i = 1:400
    for j = 1:640
      ret(real(i,j), estimations(i,j)) += 1;
    end
  end
endfunction

printf('¡Todo listo!\n');