function [ omega ] = a2o( alpha )
% Función que convierte el ángulo alfa de los polos
% Alpha es el ángulo que forma con el OX en antihorario
% Omega es el ángulo que forma respecto al OY en horario
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
%  
omega=zeros(size(alpha));
I=find(alpha>=0 & alpha<=pi/2); omega(I)=pi/2-alpha(I);
I=find(alpha>pi/2 & alpha <pi);omega(I)=2*pi-(alpha(I)-pi/2);
I=find(alpha>=pi & alpha<3*pi/2);omega(I)=2*pi-(alpha(I)-pi/2);
I=find(alpha>=3*pi/2 & alpha<2*pi);omega(I)=pi/2+(2*pi-alpha(I));
end

