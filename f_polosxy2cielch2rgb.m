function [RGB] = f_polosxy2cielch2rgb(polos_x,polos_y,L)
% Función que toma las coordenadas xy de los polos de los vectores normales
% en un estereograma y los convierte al mapa de color CIEHLC, que es como el CIELAB pero en cilíndricas
% Los colores los convierte a RGB, porque es lo que pudeo dibujar
% Input: 
% - polos_x y polos_y son las coordenadas de los polos, nx1 y nx1
% - L es la luminancia, lightness. Mide si la muestra es clara (100) u
% oscura (0). 
% Output:
% - RGB es otra matriz de los mismos colores, pero en RGB. De 0 a 255

% CIEHLC va con las polares, por lo que calculo el ángulo H y el radio C
% C* (croma, saturación relativa) 
% h° (ángulo de tono, ángulo del tono en CIELAB rueda de color) en lugar de las coordenadas cartesianas a* y b*. 
% La ligereza CIELAB L* permanece sin cambios.
% Se pasa de cartesianas a polares, sin tocar la estereográfica
% La forma más sencilla de calcularlo es con cart2pol, f de matlab
[H,C] = cart2pol(polos_x,polos_y);
a=C.*cos(H)*100;
b=C.*sin(H)*100;
% Defino el mapa de colores LCH
Light=zeros(size(polos_x)); Light(:)=L; % en base 100
LAB=[Light a b];

% Las opciones del colorspace de la ayuda de MATLAB
RGB = lab2rgb(LAB); % Convertir a RGB

% Pruebo con adobe
% RGB=lab2rgb(LAB,'ColorSpace','adobe-rgb-1998');
% RGBadobe = lab2rgb(LAB,"ColorSpace","adobe-rgb-1998");
% RGB = rgb2lin(RGBadobe,"ColorSpace","adobe-rgb-1998");
end

