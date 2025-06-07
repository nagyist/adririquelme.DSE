function [ N ] = f_pole2vnor_v02( varargin )
% [ N ] = f_pole2vnor_v02( poles_cart,projection )
% Function that converts stereographic coordinates of a plane pole into the
% normal vector coordinates of the plane.
% [N]=f_pole2vnor( poles_cart, projection)
% Input:
% - poles_cart: matrix [n,2] with the cart coordinates of the poles
% - projection: 'Equal-angle' or 'Equal-area'. If not provided, % 'Equal-angle'
% Output:
% N = [nx, ny, nz]
% - nx: components of the normal vector of the plane
% - ny
% - nz
%
%    Copyright (C) {2015}  {Adrián Riquelme Guill, adririquelme@gmail.com}
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


%% desarrollo del programa
% Inicio las variables
switch nargin
    case 1
        % Me pasas las coordenadas de los polos como un vector
        P=varargin{1};
        px=P(:,1);
        py=P(:,2);
        projection='Equal-angle';
    case 2
        % Me pasas las coordenadas de los polos una a una, en px y py
        P=varargin{1};
        px=P(:,1);
        py=P(:,2);
        projection=varargin{2};
end
avn=zeros(size(px)); %angulo vector normal

% Primero tengo que ver si el polo está dentro del círculo. Podría ser que
% al ser un punto de contorno, por error de precisión se quedara fuera del
% estereograma. Esto lo detecto porque el radio sería mayor a 1.

I=find(px>0 & py>0);
%a(I)=atan(py./px);
avn(I)=atan(py(I)./px(I))+pi;
I=find(px<0 & py>=0);
%a(I)=pi-atan(-py./px);
avn(I)=2*pi-atan(-py(I)./px(I));
I=find(px<0 & py<=0);
avn(I)=atan(py(I)./px(I));
I=find(px>=0 & py<0);
avn(I)=pi-atan(-py(I)./px(I));

% Calculo el radio según las coordenadas del polo, que depende de la
% proyección empleada
rho = (px.^2+py.^2).^(0.5);
% verifico si el radio es mayor a 1 y lo dejo en 1
rho(rho>1)=1;
switch projection
    case 'Equal-angle'
        beta=2*atan(rho);
    case 'Equal-area'
        beta=2*asin(rho/(2^0.5));
    case 'Equal-proportion'
        beta = rho.*pi/2;
    otherwise
end
% Beta es el ángulo del vector buzamiento respecto al plano horizontal
% Alpha es su complementario. Es el que forma el vn con el OX
alpha = pi/2 - beta;
nxy=cos(alpha); % Proyecto el vn al plano horizontal
N(:,1)=nxy.*cos(avn); % Descompongo nxy en los ejes OX y OY
N(:,2)=nxy.*sin(avn);
% N(:,3)=nxy.*tan(alpha); % También podría ser sin(alpha) directamente
N(:,3)=sin(alpha);

% Para los planos horizontales, donde x=y=0, vector vertical
I=find(px==0 & py==0);
N(I,1)=0; N(I,2)=0; N(I,3)=1;


end

