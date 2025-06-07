function output_txt = myupdatefcn_rotate(varargin)
% output_txt = myupdatefcn_rotate(empt,event_obj,angulos,projection)
%    {Customizes text of data tips}
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
%    Discontinuity Set Extractor, Copyright (C) 2015 Adrian Riquelme Guill
%    Discontinuity Set Extractor comes with ABSOLUTELY NO WARRANTY.
%    This is free software, and you are welcome to redistribute it
%    under certain conditions.
% https://uk.mathworks.com/matlabcentral/answers/157879-how-to-pass-the-variables-to-data-cursor-s-updatefcn-datacursormode-in-matlab-guide

switch nargin
    case 2
        % Martriz de rotación unidad y proyección equiangular
        empt=varargin{1};
        event_obj=varargin{2};
        angulos=[0 0 0];
        projection='Equiangular';        
    case 3
        empt=varargin{1};
        event_obj=varargin{2};
        angulos=varargin{3};
        % Tengo matriz de rotación que me da en ángulos, pero no proyección
        projection='Equiangular';
    case 4
        empt=varargin{1};
        event_obj=varargin{2};
        angulos=varargin{3};
        projection=varargin{4};
    otherwise
        % Algo ha pasado
end

% Primero vamos a crear la matriz de rotacion, que aplicaremos la inversa
R = f_calcula_matriz_rotacion(angulos);
pos = get(event_obj,'Position');
x = pos(1);
y = pos(2);
[ vector_normal ] = f_pole2vnor_v02( [x,y],projection );
vector_normal_rotado=vector_normal*R;
[ dipdir, dip ] = f_vnorm2clar_v02( vector_normal_rotado );
output_txt = {['Dip direction: ',num2str(dipdir,3),char(176)],...
    ['Dip: ',num2str(dip,3),char(176)]};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Density: ',num2str(pos(3),4)];
end

