function [ N ] = f_pole2vnor( varargin )
% [ N ] = f_pole2vnor( poles_cart )
% Function that converts stereographic coordinates of a plane pole into the
% normal vector coordinates of the plane.
% [N]=f_pole2vnor( poles_cart)
% [N]=f_pole2vnor ( px, py)
% Input:
% - poles_cart: matrix [n,2] with the cart coordinates of the poles
% - px: cartesian coordinates of the pole in stereographic projection
% - py
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

% Este código no usa la proyección, cuidado. Pongo un aviso
    % Crear la figura de la ventana emergente
    d = dialog('Position', [300, 300, 250, 150], 'Name', 'Aviso');

    % Crear el texto del mensaje
    uicontrol('Parent', d, ...
              'Style', 'text', ...
              'Position', [20, 80, 210, 40], ...
              'String', 'Función obsoleta, cambia pole2vnor a pole2vnor_v02 que usa la proyección.');

    % Crear el botón de OK
    uicontrol('Parent', d, ...
              'Position', [85, 20, 70, 25], ...
              'String', 'OK', ...
              'Callback', 'delete(gcf)');

%% desarrollo del programa
% Inicio las variables
switch nargin
    case 1
        % Me pasas las coordenadas de los polos como un vector
        P=varargin{1};
        px=P(:,1);
        py=P(:,2);
    case 2
        % Me pasas las coordenadas de los polos una a una, en px y py
        px=varargin{1};
        py=varargin{2};
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
rho = (px.^2+py.^2).^(0.5);
% verifico si el radio es mayor a 1 y lo dejo en 1
rho(rho>1)=1;
phi = atan(rho);
beta = 2*phi;

alpha = pi/2 - beta;
nxy=cos(alpha);
N(:,1)=nxy.*cos(avn);
N(:,2)=nxy.*sin(avn);
N(:,3)=nxy.*tan(alpha);

% Para los planos horizontales, donde x=y=0, vector vertical
I=find(px==0 & py==0);
N(I,1)=0; N(I,2)=0; N(I,3)=1;


end

