%PREÁMBULO+++++++++++++++++++
% En el ejercicio se plantea lo siguiente:
% Tengo un imagen dividida en 6 regiones. Voy a imaginar que en cada region
% ocurre un proceso distinto que genera por cada pixel un evento distinto.
% La información que nos interesa de dichos eventos va a ser un vector de
% 3 dimensiones, que lo vamos a pensar como un color.
% El proceso de cada región va a tener una distribución gaussiana trivariada
% cuyos parámetros vamos a elegir según con lo que requiere el enunciado
% experimentar. Para cada set de parámetros vamos a generar una muestra por
% cada pixel, y vamos a intentar clasificar de manera naive (ya que contamos
% con la información de las distribuciones).
% La idea va a ser sacar conclusiones con los resultados de la clasificaciones
% utilizando las densidades producto de los diversos sets de parámetros.

% En principio, ¿no es raro que lo que estemos variando son las densidades
% reales? Lo que tendría más sentido variar es nuestra manera de
% clasificar... Tipo, no sé que tanto sentido tenga preguntarse qué
% distribución tendría que tener nuestros fenómenos para conseguir buenos
% resultados en la clasificación.
% En general, mientras menos varianza mejor, pues las nubes de puntos
% de las distintas clases estarán separadas. Por decir algo, preferiríamos
% modelos con los parámetros del B más que los del A, pues tenemos más
% información sobre cada feature; y más los del C que los del B pues la
% info de cada clase tendría mayor chance de ser más compacta (salchicha
% vs esfera so to say).

% - ¿Densidades marginales de vector aleatorio con distribucion gaussiana
% multivariada, donde las componentes no son independientes?
% https://stats.stackexchange.com/questions/51171/obtaining-marginal-distributions-from-the-bivariate-normal


clc; clear;
COLORS = int16([123 239 134; 126 123 239;  80 147  53;
                201 199  60; 188 152  81; 239 124  67]);

%CLASIFICACIÓN (con verdad terrestre) +++++++++++++++++ 
% Para obtener las verdaderas clases tomé los 6 colores principales de la
% imagen phantom para obtener 6 clases. Cada pixel es asignado a su clase
% según qué color tenga más cerca.
fprintf('Extrayendo las verdaderas clases de cada pixel...\n\n');
v_clases = zeros(400, 640, 'uint8');
phantom = imread('phantom.png');
for i = 1:400
  for j = 1:640
    pixel = int16(reshape((phantom(i,j,:)), [1 3]));
    min_d = sum(abs(pixel - COLORS(1,:)));
    min_c = 1;
    for h = 2:6
      distance = sum(abs(pixel - COLORS(h,:)));
      if distance < min_d
        min_d = distance;
        min_c = h;
      end
    end
    v_clases(i,j) = min_c;
  end
end
            
for t = 1:3
  if t == 1
    fprintf('CASO MATRICES ISÓTROPICAS E IGUALES ENTRE SI\n');
  elseif t == 2
    fprintf('CASO MATRICES DIAGONALES\n');
  elseif t == 3
    fprintf('CASO MATRICES ARBITRARIAS\n');
  end
  
  %GENERACIÓN++++++++++++++++++
  %Parámetros
  fprintf('Asignando los parámetros a las densidades de clase...\n');
  mus = double(COLORS);
  sigmas = zeros(3, 3, 6);
  if t == 1 %Equal isotropic
    var = rand(1) * 80 + 200;
    temp = eye(3) * var;
    for i = 1:6
      sigmas(:,:,i) = temp;
    end
    %Sample Example
    %126.4184    0.          0.
    %  0.      126.4184      0.
    %  0.        0.        126.4184

  elseif t == 2 %Unequal diagonal
    for i = 1:6
      vars = rand(1,3) * 80 + 80;
      temp = [vars(1) 0 0 ; 0 vars(2) 0; 0 0 vars(3)];
      sigmas(:,:,i) = temp;
    end
    %Sample Example
    %137.7529     0.         0.
    %  0.       115.7590     0.
    %  0.         0.        90.8845

  elseif t == 3 %Any
    for i = 1:6
      temp = rand(3)/2 + 0.5; %matriz aleatoria
      temp = (temp * temp') + 3 * eye(3);  %definida positiva
      temp = temp * 30; %aumento la proba de que haya variación y correlación
       % multiplicar por escalar escala el det. La suma no sé en realidad,
      sigmas(:,:,i) = temp;
    end
    %Sample Example
    %162.2787    54.1064    62.3708
    % 54.1064   131.1191    48.5776
    % 62.3708    48.5776   149.6149
  end
      
  %Muestreo
  fprintf('Muestreando...\n');
  values = zeros(400, 640, 3);
  for h = 1:6
    v = find(v_clases == h);
    for i = 1:length(v)
      k = v(i);
      muestra = mvnrnd(mus(h,:),sigmas(:,:,h));
      values(k) = muestra(1); % Asigno de esta forma porque me falta matlab
      values(k+256000) = muestra(2);
      values(k+512000) = muestra(3);
    end
  end

  %CLASIFICACIÓN+++++++++++++
  %Clasificación
  %Como el priori es equiprobable para cada clase, lo ignoro en las funciones
  %discriminantes y computo solo el likelihood.
  fprintf('Clasificando...\n');
  clases = zeros(400, 640, 'uint8');
  for i = 1:400
    for j = 1:640
      pixel = reshape(values(i,j,:), [1 3]);
      max_c = 1;
      max_l = mvnpdf(pixel, mus(1,:), sigmas(:,:,1));
      for h = 2:6
        likelihood = mvnpdf(pixel, mus(h,:), sigmas(:,:,h));
        if likelihood > max_l
          max_l = likelihood;
          max_c = h;
        end
      end
      clases(i,j) = max_c;
    end
  end


  %ANÁLISIS+++++++++++++++++
  %Gráficos
  figure(t);
  imshow(clases, [1 1 1; 1 0 0 ; 0 1 0 ; 0 0 1 ; 1 1 0 ; 1 0 1 ; 0 1 1]);

  %Matriz de confusión
  fprintf('Calculando la matriz de confusión...\n');
  confusion = zeros(6,6);
  for i = 1:400
    for j = 1:640
      confusion(v_clases(i,j),clases(i,j)) = confusion(v_clases(i,j),clases(i,j)) + 1;
    end
  end
  disp(confusion);
  
  fprintf('\n');
end

%LIMPIEZA+++++++++++++++++
clear COLORS; clear h;
clear t;
clear i; clear j;
clear v; clear k;
clear var; clear vars;
clear likelihood; clear max_l; clear max_c;
clear distance; clear min_c; clear min_d;
clear pixel; clear muestra; clear temp;

fprintf('\nFin.\n');