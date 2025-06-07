function [polos_pples, polos_pples_cart, density, X, Y]=f_prepara_planos_kde_v02(polos_cartesianas_proyectadas,nsec, angulovpples, maxpples,normaliza,proyeccion_estereograma)
% [polos_pples, polos_pples_cart, density, X, Y]=f_prepara_planos_kde_v02(polos_cartesianas_proyectadas,nsec, angulovpples, maxpples,normaliza,proyeccion_estereograma)
%% Función que calcula la densidad de polos (contour plot) con kde2d y  busca los planos principales
% Se determinan los polos del vector normal al plano.
% La v02 armoniza los valores de densidad multiplicando por un factor que
% depende del radio del polo al estereograma. De esta forma, densidades en
% los extremos del estereograma tendrán el mismo valor.
% Las coordenadas de los polos ya vienen con la proyección, no se toca nada
% Input:
% - polos_cartesianas_proyectadas: matriz nx2
% - nsec: número de secciones, que da la resolución de los bins
% - angulovpples: en grados, máximo ángulo entre vectores principales
% - maxpples: número máximo de planos principales que buscamos
% - normaliza: 1 o 0, normaliza la densidad a máximo 1
% - proyeccion: 'Equal-angle' o 'Equal-area'
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
densidadminima = 0.0001; %establezco la densidad mínima en tanto por uno
[~,density,X,Y]=kde2d(polos_cartesianas_proyectadas,nsec);

% Normalizo si procede la densidad
switch normaliza
    case 1
        density=density/(max(max(density)));
    otherwise
        % Algo ha fallado
end

% Esta función busca los máximos relatios en los vértices. Se puede
% mejorar.
[ dmax, Xmax, Ymax ] = maxsearch2d( X,Y,density,densidadminima) ; 
[~, ns]=size(dmax);

% ns es el número de máximos que he encontrado, por lo que no puedo encontrar
% más planos principales que ns

% convertimos la tolerancia. Es el valor con el que se compara el
% paralelismo de los vectores normales

proyeccion = cos(angulovpples/180*pi);

% Con los planos, vamos a registrarlos en la salida
para=0;
ii=1; % ii es el n de plano principal que estoy considerando
kk=1; % kk es el orden de plano principal que he encontrado
polos_pples=zeros(1,3); % Inicio la matriz con los resultados
polos_pples_cart=zeros(1,2); % Inicio la matriz de polos pples proyectados
vnormal_pples=zeros(1,4); % Inicio la matriz auxiliar de vectores normales
while para==0
    % con las coordenadas en cartesianas, determinamos el plano en notación
    % vector de buzamiento
    % alfa es el ángulo medido desde el OX (polares) de las coordenadas del
    % polo principal
    % beta es el ángulo que forma el vector normal (polo) con el plano
    % horizontal
    x=Xmax(ii); y=Ymax(ii);
    % Cambio el código antiguo por cart2clarv02, considera la proyección
    % La orientación que obtengo está en radianes
    [ dipdir, dip ] = f_cart2clar_v02( x,y,proyeccion_estereograma );

    % Guardo el principal en grados
    polos_pples(kk,1)=dipdir;
    polos_pples(kk,2)=dip;
    polos_pples(kk,3)=dmax(ii); % Ponemos el num de puntos que tiene asociado
    vnormal_pples(kk,1)=sin(dipdir/180*pi)*sin(dip/180*pi);  %el vector es unitario
    vnormal_pples(kk,2)=cos(dipdir/180*pi)*sin(dip/180*pi);
    vnormal_pples(kk,3)=cos(dip/180*pi);
    vnormal_pples(kk,4)=dmax(ii); %al vector normal le ponemos el num de puntos que tiene asociado
    polos_pples_cart(kk,1)=x;
    polos_pples_cart(kk,2)=y;
    polos_pples_cart(kk,3)=dmax(ii);
    if ii==1
        ii=ii+1; %como no he terminado, considero buscar en otro plano mas
        kk=kk+1; %este se incrementa si se acepta el plano!!!!!!
    else
        test = 1;
        % vamos a probar si el plano ii no es paralelo al resto encontrados
        ux1=vnormal_pples(kk,1);
        uy1=vnormal_pples(kk,2);
        uz1=vnormal_pples(kk,3);
        % vamos a comparar el plano ii con todos los anteriores, los kk
        for jj=1:(kk-1)
            ux2=vnormal_pples(jj,1);
            uy2=vnormal_pples(jj,2);
            uz2=vnormal_pples(jj,3);
            proyeccion2 = abs(ux1*ux2+uy1*uy2+uz1*uz2);
            if proyeccion2 > proyeccion
                % es paralelo, luego no se considera
                test = 0; 
            end
        end
        % si test=1 el plano ii no es paralelo a todos los anteriores 
        % si test=0, ha encontrado al menos uno paralelo, luego eliminamos el
        % plano
        if test==0
            % no pasa el test y borramos ese plano
            vnormal_pples(kk,:)=[];
            polos_pples(kk,:)=[];
            polos_pples_cart(kk,:)=[];
            ii=ii+1; % se considera el siguiente plano
        else
            % como el plano es bueno, lo dejamos
            ii=ii+1; % se considera el siguiente plano
            kk=kk+1; % se acepta el plano
        end

    end
    if kk>nsec || kk>maxpples || ii>ns %hemos encontrado todos los planos que buscamos o hemos buscado por todos los max que tenemos
        para=1;
    end
end
end
