function [polos_cartesianas_proyectadas]=f_calcula_coordenadas_polosvn(planos_Clar,projection)
%% Función que calcula las coordenadas xy de los polos de los vn en estereograma, empleando proyección de hemisferio inferior Equal-angle o Equal-area
% Se asume que el estereomgrama tiene radio R=1
% La proyección Equal-angle no distorsiona formas, la Equal-area no
% distorsiona superficies, por lo que es mejor para contours
% Vectores de buzamiento (dipdir,dip) --> Xp, Yp proyectadas (polo del vn)
% input
% - planos_Clar: matriz que contiene los datos de los vectores de
% buzamiento de los planos, en forma w (dip direction) y b (dip)
% - projection: la proyección 'Equal-angle' o 'Equal-area'
% output
% - polos_cartesianas_proyectadas: [Xp, Yp]
[np,~]=size(planos_Clar);
polos_clar_proyectadas=zeros(np,2);
polos_cartesianas_proyectadas=zeros(np,2);
% partiendo de omega y beta, determinamos los parámetros en polares de los
% polos y sus coordenadas en cartesianas
% alfa será el ángulo de P' en coordenadas polares
for ii=1:np
    omega = planos_Clar(ii,1);
    if abs(planos_Clar(ii,2))>=pi/2
        beta = pi  + abs(planos_Clar(ii,2));
    else
        beta = abs(planos_Clar(ii,2));
    end
    alfa = o2a(omega);
    polos_clar_proyectadas(ii,1)= alfa; % angulo alfa de las polares
    % Calculo el radio del punto
    switch projection
        case 'Equal-angle'
            radio= tan (beta / 2); % radio de las polares
        case 'Equal-area'
            radio= 2^(0.5)*cos (pi/2-beta / 2); % radio de las polares
        otherwise
            % Algo ha fallado
    end
    polos_clar_proyectadas(ii,2)=radio;
    % Tengo el radio y el ángulo, calculo la coordenada
    polos_cartesianas_proyectadas(ii,1)=radio*cos(alfa); % x en las cartesianas
    polos_cartesianas_proyectadas(ii,2)=radio*sin(alfa); % y en las cartesianas
end


end

