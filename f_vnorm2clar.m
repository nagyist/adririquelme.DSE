function [ dipdir, dip ] = f_vnorm2clar( Normales )
% [ dipdir, dip ] = f_vnorm2clar( N ) en grados
% N es el vector normal del plano
% Función que convierte un vector normal de un polo a notación de Clar
% N=[nx ny nz] --> dip dir y dip en grados
% N puede ser un conjunto de vectores normales, puestos en fila
%    Copyright (C) {2024}  {Adrián Riquelme Guill, adririquelme@gmail.com}
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
%    with this program; if not, write to the Free Software Foundation, Inc.,
%    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
%    Discontinuity Set Extractor, Copyright (C) 2015 Adrián Riquelme Guill
%    Discontinuity Set Extractor comes with ABSOLUTELY NO WARRANTY.
%    This is free software, and you are welcome to redistribute it
%    under certain conditions.

[n,~]=size(Normales);
dipdir=zeros(n,1);
dip=dipdir;
for i=1:n
    modulo = (Normales(i,:)*Normales(i,:)')^(0.5);
    N=Normales(i,:)/modulo;
    % Calculo la dirección de buzamiento
    % Si es un vector vertical, el plano es horizontal y le doy un valor
    % de dipdir de cero
    if N(3)==1
        dipdir(i)=0;
    else
        dipdir(i) = atan2(N(1),N(2))*180/pi;
        if dipdir(i)<0
            dipdir(i) = dipdir(i)+360;
        end
    end
    % Si el plano es vertical, le doy directamente el buzamiento de 90
    if N(3)==0
        dip(i)=90;
    else
        dip(i) = atan((N(1)^2+N(2)^2)^(0.5)/N(3)) .* 180/pi;
    end
end
end