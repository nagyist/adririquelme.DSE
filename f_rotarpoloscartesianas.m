function [pcx_r,pcy_r] = f_rotarpoloscartesianas(pcx,pcy,R,proyeccion)
% [pcx_r,pcy_r] = f_rotarpoloscartesianas(pcx,pcy,R,proyeccion)
% Función que toma coordenadas en cartesianas de polos y las rota según la
% matriz de rotación R, en el sistema de proyección indicado
% Input:
% - pcx y pcy son las coordenadas de los polos en cartesianas
% - R es la matriz de rotación a aplicar
% - proyeccion es 'Equal-angle' o 'Equal-area'
% Output:
% - pcx_r y pcy_r son las coordenadas cartesianas en el SR indicado de los polos
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

[ vectores_normales ] = f_pole2vnor_v02( [pcx, pcy],proyeccion );
% Calculo los vectores rotados
normales_rotadas=(R*vectores_normales')';
% En la rotación puedo hacer que algunos vectores apunten al
% hemisferio inferior, lo normalizo para que todos apunten
% arriba y los buzamientos sean positivos por definición
I=find(normales_rotadas(:,3)<0);
normales_rotadas(I,:)=-normales_rotadas(I,:);
% Convierto los vectores a notación de clar para tomar los
% buzamientos de cada y no y calcular la función objetivo
% La dirección de buzamiento, w, no la necesito y la dejo fuera
% del resultado. El buzamiento está en grados.
[ direcciondebuzamiento, buzamiento ] = f_vnorm2clar_v02( normales_rotadas );
[ pcx_r,pcy_r ] = f_clar2cart( direcciondebuzamiento,buzamiento,proyeccion );
end