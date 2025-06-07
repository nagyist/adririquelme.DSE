function [ x,y ] = f_clar2cart( varargin )
% [ x,y ] = f_clar2cart( dipdir, dip, projection )
% Función que convierte un polo en notación de Clar a sus coordenadas
% cartesianas para representar en estereográficas
% los ángulos se meten en grados, pero se calculan en radianes
% Inputs:
% - theta y beta: dirección de buzamiento y buzamiento, en grados
% - projection: Equal-angle o Equal-area. Si no se indica, se toma Equal-angle
%    Copyright (C) {2025}  {Adrián Riquelme Guill, ariquelme@ua.com}
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
        dipdir=varargin{1}*pi/180;
        dip=varargin{2}*pi/180;
        projection='Equal-angle';
        % Me pongo un aviso de que tengo esta f colgada sin actualizar la
        % proyección
        d = dialog('Position', [300, 300, 250, 150], 'Name', 'Aviso');

        % Crear el texto del mensaje
        uicontrol('Parent', d, ...
            'Style', 'text', ...
            'Position', [20, 80, 210, 40], ...
            'String', 'Tienes clar2cart sin proyección, cuidado.');

        % Crear el botón de OK
        uicontrol('Parent', d, ...
            'Position', [85, 20, 70, 25], ...
            'String', 'OK', ...
            'Callback', 'delete(gcf)');
    case 3
        dipdir=varargin{1}*pi/180;
        dip=varargin{2}*pi/180;
        projection=varargin{3};
    otherwise
        % Algo ha fallado
end

% Calculo el radio del punto
switch projection
    case 'Equal-angle'
        radio= tan (dip / 2); % radio de las polares
    case 'Equal-area'
        radio= sqrt(2).*cos (pi/2-dip / 2); % radio de las polares
    case 'Equal-proportion'
        radio=dip./(pi/2);
    otherwise
        % Algo ha fallado
end
% Tengo el radio y el ángulo, calculo la coordenada
alfa = o2a(dipdir); % Convierto la dirección de buzamiento al ángulo desde el OX positivo antihorario
x=radio.*cos(alfa); % x en las cartesianas
y=radio.*sin(alfa); % y en las cartesianas
end

