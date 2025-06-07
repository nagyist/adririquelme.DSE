function [ dipdir, dip ] = f_cart2clar_v02( varargin )
% [ dipdir, dip ] = f_cart2clar_v02( x,y,proyeccion )
% Función que convierte las coordenadas cartesianas en notación de Clar
% Inputs: x e y, coordenadas del polo del estereograma (R=1), escalar o % vector
% - proyeccion: 'Equal-angle' o 'Equal-area', si se omite es 'Equal-angle'
% Output: dipdir y dip del plano, en grados
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

switch nargin
    case 2
        x=varargin{1};
        y=varargin{2};
        proyeccion='Equal-angle';
    case 3
        x=varargin{1};
        y=varargin{2};
        proyeccion=varargin{3};
    otherwise
        % Algo ha fallado
end

% Inicio alpha y beta
radio=sqrt(x.^2+y.^2);
radio(radio>=1)=1;
% alpha=zeros(size(x));
% dip = zeros(size(alpha));

alpha=atan2(y,x);
% normalizo alpha para que esté entre 0 y 2pi
I=find(alpha<0);
alpha(I)=alpha(I)+2*pi;
% alpha(alpha<0)=alpha+2*pi;

% Calculo el buzamiento, que depende de la proyección
switch proyeccion
    case 'Equal-angle'
        dip = 2*atan(radio)*180/pi;
    case 'Equal-area'
        dip = 2*asin(radio./sqrt(2))*180/pi;
    case 'Equal-proportion'
        dip = radio.*pi/2;
    otherwise
        % Algo ha fallado
end

% Calculo las direcciones de buzamiento según alpha, que es el ángulo que
% forma el polo del vn en el estreograma con OX antihorario
% la dipdir se encuentra formando +pi
dipdir=mod(3*pi/2-alpha,2*pi)*180/pi;

% normalizo el plano horizontal
I=find(x==0 & y==0);
dipdir(I)=0;
dip(I)=0;

end



