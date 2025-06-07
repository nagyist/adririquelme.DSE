function [polos_pples, polos_pples_cart, density, X, Y]=f_densidad_y_polospples_v01(polos_estereo_cartesianas,nsec, angulovpples, maxpples,normaliza,proyeccion_estereograma,bandwidth,mindensity)
% [polos_pples, polos_pples_cart, density, X, Y]=f_densidad_y_polospples_v01(polos_estereo_cartesianas,nsec, angulovpples, maxpples,normaliza,proyeccion_estereograma,bandwidth,mindensity)
%% Función que calcula la densidad de polos (contour plot) con kde2d y  busca los planos principales
% Se determinan los polos del vector normal al plano.
% La v02 armoniza los valores de densidad multiplicando por un factor que
% depende del radio del polo al estereograma. De esta forma, densidades en
% los extremos del estereograma tendrán el mismo valor.
% Las coordenadas de los polos ya vienen con la proyección, no se toca nada
% Input:
% - polos_estereo_cartesianas: matriz nx2
% - nsec: número de secciones, que da la resolución de los bins
% - angulovpples: en grados, máximo ángulo entre vectores principales
% - maxpples: número máximo de planos principales que buscamos
% - normaliza: 1 o 0, normaliza la densidad a máximo 1
% - proyeccion: 'Equal-angle' o 'Equal-area'
% - bandwitdh: el ancho del kernell. Si 0 se toma el óptimo
% - mindensity: valor mínimo de densidad, en tanto por uno, para aceptar o no la densidad
% Output:
% - polos_pples(alfa(rd), beta(rd), fdensidad). Coordenadas polares
% - polos_pples_cart(x,y) de P'. Coordenadas cartesianas
% - density: valores de la función de densidad
% - X: coordenadas x de los bins de la función de densidad
% - Y: coordenadas y de los bins de la función de densidad
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

% Crear la función de densidad mediante los kernels
densidadminima = mindensity; %establezco la densidad mínima en tanto por uno
% [~,density,X,Y]=kde2d(polos_estereo_cartesianas,nsec);
% Trabajo en un estereograma de radio unidad, luego los límites son +-1
MIN_XY=[-1,-1];
MAX_XY=[1,1];
switch bandwidth
    case 0
        % Tengo el óptimo, uso el kde2d
        [bandwidth,density,X,Y]=kde2d(polos_estereo_cartesianas,nsec,MIN_XY,MAX_XY);
    otherwise
        % Tengo un bandwidth específico, uso el mvksdensity
        % Número de elementos del grid
        % num_elements = 2^nsec;
        % Crear el grid
        [X, Y] = meshgrid(linspace(-1, 1, nsec), linspace(-1, 1, nsec));
        grid_points = [X(:), Y(:)];
        % Calcular la densidad
        density = mvksdensity(polos_estereo_cartesianas, grid_points, 'Bandwidth', bandwidth, 'BoundaryCorrection', 'reflection');
        % Reshape la densidad para que coincida con el grid
        density = reshape(density, nsec, nsec);
end

% Normalizo si procede la densidad
switch normaliza
    case 1
        density=density/(max(max(density)));
    otherwise
        % Algo ha fallado
end
% Esta función busca los máximos relatios en los vértices
[polos_pples, polos_pples_cart ] = f_busca_max_relativo_densidad(X, Y, density, densidadminima, angulovpples, maxpples, proyeccion_estereograma) ;
end
