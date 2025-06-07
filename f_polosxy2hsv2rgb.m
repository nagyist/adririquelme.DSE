function [RGB] = f_polosxy2hsv2rgb(polos_x,polos_y, value,proyeccion)
% Función que toma las coordenadas xy de los polos de los vectores normales
% en un estereograma y los convierte al mapa de color HSV, pero los da en
% RGB que es lo que puedo representar en nubes de puntos
% Input: 
% - polos_x y polos_y son las coordenadas de los polos, nx1 y nx1
% - value: 0 para negro, 1 para blanco
% Output:
% - RGB es otra matriz de los mismos colores, pero en RGB. De 0 a 255

[ dipdir, dip ] = f_cart2clar_v02(polos_x, polos_y,proyeccion); % esto lo da en grados
dipdir=dipdir/180*pi; % la salida hay que convertirla a radianes
dip=dip/180*pi;

% Calculo el ángulo alpha
% alpha es el ángulo desde el OX antihorario hasta la proyección del polo
alfa=zeros(size(dipdir));
I=find(dipdir>=0 & dipdir<pi/2); alfa(I)=pi/2-dipdir(I)+pi;
I=find(dipdir>=pi/2 & dipdir <pi);alfa(I)=pi-(dipdir(I)-pi/2);
I=find(dipdir>=pi & dipdir<3*pi/2);alfa(I)=pi/2-(dipdir(I)-pi);
I=find(dipdir>=3*pi/2 & dipdir<2*pi);alfa(I)=7*pi/2-dipdir(I);
% Ahora represento los polos en mi falsilla con colores
HSV=zeros(length(alfa),3);
HSV(:,1)=(alfa)/(2*pi); % Hue, original
% HSV(:,1)=(alfa-pi/2)/(2*pi); % Hue, lo retraso 90d para que coincida con COLTOP3D
% Este valor está en base 1
% regularizo los valores negativos, sumando 1 a los que han
% ido al cuarto cuadrante y los pongo en positivo
I=find(HSV(:,1)<0);
HSV(I,1)=HSV(I,1)+1;
% Calculo la saturación para el dip, que es normal siempre
HSV(:,2)=dip/(pi/2); % Saturation
% por si acaso, corrijo estas columnas
HSV(HSV(:,1)>1,1)=1;
HSV(HSV(:,2)>1,2)=1;
HSV(:,3)=value; % Value
% Calculo los colores según el punto
% RGB = floor(hsv2rgb(HSV)*255);
% RGB=floor(hsv2rgb(HSV)*255); % Estos colores están en escala RGB256
RGB=hsv2rgb(HSV);
end