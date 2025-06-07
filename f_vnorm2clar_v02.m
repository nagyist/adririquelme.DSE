function [ dipdir, dip ] = f_vnorm2clar_v02( Normales )
% [ dipdir, dip ] = f_vnorm2clar( N )
% dirección de buzamiento y buzamiento en grados
% N es el vector normal del plano
% Función que convierte un vector normal de un polo a notación de Clar
% N=[nx ny nz] --> dip dir y dip en grados
% N puede ser un conjunto de vectores normales, puestos en fila. Dimensión % nx3
% V02: intento optmizar eliminando el bucle for
% Nota: no necesita la proyección, es independiente
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

% En primer lugar, hago que todas las normales vayan al hemisferio superior
I=find(Normales(:,3)<0);
Normales(I,:)=Normales(I,:)*(-1);

[n,~]=size(Normales);
dipdir=zeros(n,1);
dip=dipdir;

% Normalizo. No hace falta.
% Modulos=(Normales.*Normales);
% Modulos=sum(Modulos,2).^(0.5); % sumo la dimensión dos, que son las filas
% Normales=Normales./Modulos;
% Busco los vectores con normal vertical, plano horizontal
I=find(Normales(:,3)==1);
dipdir(I)=0;
dip(I)=0;

% Ahora vamos a por el resto
% Primero 
I=find(Normales(:,3)<1);
% Omega es el ángulo que forma el vector respecto a la horizontal, positivo
% en horario. Hay que convertirlo a alpha, que es el ángulo respecto al
% norte
omega=atan2(Normales(I,2),Normales(I,1)); % P = atan2(Y,X)
omega(omega<0)=omega(omega<0)+2*pi; % los negativos los pongo en positivo

alpha=pi/2-omega;
alpha(alpha<0)=2*pi+alpha(alpha<0);

dipdir(I)=alpha;

% A los planos verticales les pongo dip de pi/2
dip(Normales(:,3)==0)=pi/2;
% Los que no son horizontales, calculo
I=find(Normales(:,3)~=0);
dip(I)=atan((Normales(I,1).^2+Normales(I,2).^2).^(0.5)./Normales(I,3));
% Ya he terminado, lo paso a grados
dipdir=dipdir*180/pi;
dip=dip*180/pi;
end