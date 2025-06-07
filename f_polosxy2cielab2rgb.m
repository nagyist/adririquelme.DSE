function [RGB] = f_polosxy2cielab2rgb(polos_x,polos_y,L)
% Función que toma las coordenadas xy de los polos de los vectores normales
% en un estereograma y los convierte al mapa de color HSV, pero los da en
% RGB que es lo que puedo representar en nubes de puntos
% Input: 
% - polos_x y polos_y son las coordenadas de los polos, nx1 y nx1
% - L es la luminancia, lightness. Mide si la muestra es clara (100) u
% oscura (0). 
% Output:
% - HSV son los colores en este mapa de colores, matriz nx3
% - RGB es otra matriz de los mismos colores, pero en RGB. De 0 a 255

% Los valores de X e Y en el CIELAB van de -100 a 100, por lo que lo
% convierto linealmente, fácilmente Matías
% Además, no necesita la proyección ;D
X=polos_x*100;
Y=polos_y*100;
Light=zeros(size(X)); Light(:)=L;
LAB=[Light X Y];
% [RGB]=lab2rgb(LAB,'ColorSpace','adobe-rgb-1998','OutputType','uint8');
% RGB=floor(lab2rgb(LAB,'ColorSpace','adobe-rgb-1998')*255);
% RGB=floor(lab2rgb(LAB,'ColorSpace','linear-rgb')*255);
RGB = lab2rgb(LAB); % Convertir a RGB
end