%PREÁMBULO+++++++++++++++++++
% PREGUNTAS:
% 1 ¿Cómo calculo los a priori?
% 2 ¿Cómo que 'elegir regiones de prueba y calcular la matriz de confusión'.
% Si no tengo la verdad terrestre (salvo por los cuadritos de testeo que el
% usuario ingresó, pero ese es el punto anterior)

%Algoritmo
%1.For each class, get two representatives areas and use them to
% generate two models (AKA estimate the density on both areas, assuming
% they're gaussian).
%2.For each class, take the first model and any of the other classes', and
% make a classification attempt on the second representative area. Do the
% same but backwards, then note which performs better.
%3.Taking the models which had the best performance, clasify the whole
%image. Then, print graphs and the confusion matrix.

clc;


%CONSTRUCCIÓN DE MODELOS+++++++++++
representantes = cell(1,8);
mus_est = cell(1,8);
sigmas_est = cell(1,8);
for k = 1:8
  %Elección de representantes
  img = imread('circular.jpg');
  if k == 1 || k == 2
    clase = ' GRIS CLARO';
  elseif k == 3 || k == 4
    clase = ' GRIS OSCURO';
  elseif k == 5 || k == 6
    clase = ' NEGRO';
  elseif k == 7 || k == 8
    clase = ' ROJO';
  end
  if mod(k,2) == 1
    orden = ' primer';
  else
    orden = ' segundo';
  end
  str = strcat('Elegir el', orden, ' representante para la clase', clase, ':');
  annotation('textbox', [.12 .65 .3 .3], 'String', str, 'FitBoxToText', 'on');
  representantes{k} = imcrop(img);
  clf; close;
  
  %Estimación de parámetros
  sum = zeros(1,3);
  [x,y,z] = size(representantes{k});
  for i = 1:x %filas
    for j = 1:y %columnas
      pixel = reshape(double(representantes{k}(i,j,:)), [1,3]);
      sum = sum + pixel;
    end
  end
  mu_est = sum/(x*y);
  
  sum = zeros(3,3);
  for i = 1:x
    for j = 1:y
      pixel = reshape(double(representantes{k}(i,j,:)), [1,3]);
      sum = sum + (pixel - mu_est)' * (pixel - mu_est);
    end
  end
  sigma_est = sum/(x*y);
  
  mus_est{k} = mu_est;
  sigmas_est{k} = sigma_est;
end


%SELECTION+++++++++++++++++++++
% En la anterior sección se obtuvieron dos modelos para cada clase. En esta
% sección el objetivo será obtener para cada una el de mejor performance.
% cada clase el de mejor performance (k-fold cross validation con k=2, donde
% cada fold es un representante distinto de los que tomamos previamente)
% Para cada modelo vamos elegir modelos arbitrarios para las demás clases
% (que se mantendrán invariantes para que la comparación entre los dos
% representantes tenga sentido), y vamos a utilizar todo para clasificar
% la imagen. La métrica de performance es la cantidad de clasificaciones
% correctas.
% Para testear no se usa toda la imagen, sino la región del modelo 'hermano'
% del que estamos midiendo. O sea que estamos tratando de maximizar el
% recall de la clase medida (ya que siempre clasificamos cosas que deberían
% ir a la clase que estamos midiendo). Pero... Por que estamos lidiando
% con densidades no me suena que está necesariamente mal... Tipo, el
% peligro de mucha recall es que quizás estamos mandando todo a una clase.
% Pero en este caso las densidades están normalizadas. ¿O no importa?
% Una nota al margen: el apriori tampoco es relevante en esta sección, ya
% que afecta de la misma manera a todos los modelos.
fprintf('Seleccionando...\n');

%Testing
correct_classifications = zeros(1, 8);
classification_percentage = zeros(1, 8);
for k = 1:4
  for r = 0:1
    model_tested = k*2-1+r;
    test_area = representantes{k*2-r};
    other_models = [1 3 5 7];
    other_models(k) = []; % we eliminate the model of the tested class
    
    [x,y,z] = size(test_area);
    for i = 1:x %filas
      for j = 1:y %columnas
        pixel = reshape(double(test_area(i,j,:)), [1,3]);
        p_right = mvnpdf(pixel, mus_est{model_tested}, sigmas_est{model_tested});
        correct = true;
        for q = other_models
          if mvnpdf(pixel, mus_est{q}, sigmas_est{q}) > p_right
            correct = false;
          end
        end
        if correct
          correct_classifications(model_tested) = 1 + correct_classifications(model_tested);
        end
      end
    end
    classification_percentage(model_tested) = 100*(correct_classifications(model_tested)/(x*y));
  end
end

%Selección
elegidos = zeros(1, 4);
for k = 1:4
  if k == 1
    fprintf('GRIS CLARO: ');
  elseif k == 2
    fprintf('GRIS OSCURO: ');
  elseif k == 3
    fprintf('NEGRO: ');
  elseif k == 4
    fprintf('ROJO: ');
  end
  fprintf('Representante 1 -> %%');
  fprintf('%f', classification_percentage(k*2-1));
  fprintf('   Representante 2 -> %%');
  fprintf('%f', classification_percentage(k*2));
  fprintf('\n');
  if classification_percentage(k*2-1) > classification_percentage(k*2)
    elegidos(k) = k*2-1;
  else
    elegidos(k) = k*2;
  end
end
fprintf('\n');


%CLASIFICACIÓN+++++++++++++++++++
fprintf('Clasificando...\n');
[x,y,z] = size(img);
clases = zeros(x, y, 'uint8');
for i = 1:x
  for j = 1:y
    pixel = reshape(double(img(i,j,:)), [1 3]);
    max_c = 1;
    max_l = mvnpdf(pixel, mus_est{elegidos(1)}, sigmas_est{elegidos(1)});
    for h = 2:4
      likelihood = mvnpdf(pixel, mus_est{elegidos(h)}, sigmas_est{elegidos(h)});
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
figure(1);
imshow('circular.jpg');
figure(2);
imshow(clases, [1 1 1; 1 0 0 ; 0 1 0 ; 0 0 1 ; 1 1 0]);

%Limpieza
clear orden, clear clase, clear str;
clear correct; clear correct_classifications;
clear i; clear j; clear k; clear h; clear q; clear r;
clear model_tested; clear other_models;
clear mu_est, clear sigma_est;
clear pixel; clear test_area;
clear p_right;
clear sum;
clear x; clear y; clear z;

fprintf('Fin.\n');
