function [ dipdir, dip ] = f_polocart2dipdirdip_v03( x,y,projection )
%% [ dipdir, dip ] = f_polocart2dipdirdip( x,y,projection )
% Función que convierte las coordenadas cartesianas de un polo de un vector
% normal de un plano a la notación de Clar (dirección de buzamiento y
% buzamiento)
% Input:
% - x: coordenada x del polo
% - y: coordenada y del polo
% - projection: sistema de proyección empleada, 'Equal-angle' o 'Equal-area'
% Output:
% - dip direction y dip en radianes
% Adrián Riquelme Guill, 4 diciembre 2014
% Modificado 17 enero 2025, adaptado a la proyección del estereograma
%    Copyright (C) {2025}  {Adrián Riquelme Guill, ariquelme@ua.es}
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License along
%   with this program; if not, write to the Free Software Foundation, Inc.,
%   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
%    Discontinuity Set Extractor, Copyright (C) 2015 Adrián Riquelme Guill
%    Discontinuity Set Extractor comes with ABSOLUTELY NO WARRANTY.
%    This is free software, and you are welcome to redistribute it
%    under certain conditions.

dipdir = zeros(size(x));

% primer cuadrante
I = find(x>=0 & y>=0);
dipdir(I)=atan(x(I)./y(I))+pi;

% segundo cuadrante
I = find(x>0 & y<0);
dipdir(I)=2*pi+atan(x(I)./y(I));

% tercer cuadrante
I = find(x<=0 & y<=0);
dipdir(I)=atan(x(I)./y(I));

% cuarto cuadrante
I = find(x<0 & y>0);
dipdir(I)=pi+atan(x(I)./y(I));

% Para el buzamiento, necesito la proyección empleada
radio=(x.^2+y.^2).^0.5;
switch projection
    case 'Equal-angle'
        dip = 2*atan(radio);
    case 'Equal-area'
        dip = 2.*asin(radio/sqrt(2));
        % dip = pi - acos(radio/sqrt(2));
    otherwise
        % Algo va mal
end

% El caso particular de polo en el centro lo corrijo a plano horizontal,
% con dipdir de 0 para que se vea
I=find(x==0 & y == 0);
dipdir(I)=0; dip(I)=0;
end




