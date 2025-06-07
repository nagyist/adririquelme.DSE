function [RGB] = f_polosxy2cielch2rgb_mod01(polos_x,polos_y,L)
% Función que toma las coordenadas xy de los polos de los vectores normales
% en un estereograma y los convierte al mapa de color CIEHLC, que es como el CIELAB pero en cilíndricas
% Los colores los convierte a RGB, porque es lo que pudeo dibujar
% Input: 
% - polos_x y polos_y son las coordenadas de los polos, nx1 y nx1
% - L es la luminancia, lightness. Mide si la muestra es clara (100) u
% oscura (0). 
% Output:
% - RGB es otra matriz de los mismos colores, pero en RGB. De 0 a 255

% Esta función está trucada, porque L varía con C. H varía libremente entre
% 0 y 360.
Cmin=0; Cmax=1; % C es el radio, varía de 0 a 1
Lmin=L; Lmax=50; % L es lightness, va de 0 a 100
% Lmin es el valor de L en el centro (radio 0), y Lmax en el borde del
% estereograma (radio 1)


% CIEHLC va con las polares, por lo que calculo el ángulo H y el radio C
% C* (croma, saturación relativa) 
% h° (ángulo de tono, ángulo del tono en CIELAB rueda de color) en lugar de las coordenadas cartesianas a* y b*. 
% La ligereza CIELAB L* permanece sin cambios.
% La forma más sencilla de calcularlo es con cart2pol
[H,C] = cart2pol(polos_x,polos_y);
a=C.*cos(H)*100;
b=C.*sin(H)*100;
% Defino el mapa de colores LCH
Light=zeros(size(polos_x)); 
Light(:)=(C-Cmin)*(Lmax-Lmin)/(Cmax-Cmin)+Lmin; % en base 100
LAB=[Light a b];

% Las opciones del colorspace de la ayuda de MATLAB
RGB = lab2rgb(LAB); % Convertir a RGB

% Pruebo con adobe
% RGB=lab2rgb(LAB,'ColorSpace','adobe-rgb-1998');
% RGBadobe = lab2rgb(LAB,"ColorSpace","adobe-rgb-1998");
% RGB = rgb2lin(RGBadobe,"ColorSpace","adobe-rgb-1998");
end

