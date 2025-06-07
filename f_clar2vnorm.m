function [N] = f_clar2vnorm(dipdir, dip)
% Función que devuelve el vector normal de la notación de Clar
%   Adrián Riquelme, ariquelme@ua.es, marzo 2025
[planos_Clar]=[dipdir dip];
projection='Equal-angle'; % Pongo esta pero da igual la que meta
[polos_cartesianas_proyectadas]=f_calcula_coordenadas_polosvn(planos_Clar,projection);
[N]=f_pole2vnor( polos_cartesianas_proyectadas, projection);
end