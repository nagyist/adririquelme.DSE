function [polos_estereo_polares, polos_estereo_cartesianas]=prepara_representa(planos_estereo)
%% Representamos los puntos obtenidos
% Hay que migrar esta función a f_calcula_coordenadas_polosvn
% Partiendo de los vectores de buzamiento, determinamos la posición del
% polo P (mediante el vector normal) y su proyección estereografica P'. Las
% matrices polos contienen la proyección del polo del vector normal P'
% input
% - planos_estereo: matriz que contiene los datos de los vectores de
% buzamiento de los planos, en forma w (dip direction) y b (dip)
% output
% - polos_estereo_polares
% - polos_estereo_cartesianas

% Función obsoleta, migrar a f_calcula_coordenadas_polosvn
    % Crear la figura de la ventana emergente
    d = dialog('Position', [300, 300, 250, 150], 'Name', 'Aviso');

    % Crear el texto del mensaje
    uicontrol('Parent', d, ...
              'Style', 'text', ...
              'Position', [20, 80, 210, 40], ...
              'String', 'Función prepararepresenta obsoleta, migrar a f_calcula_coordenadas_polosvn');

    % Crear el botón de OK
    uicontrol('Parent', d, ...
              'Position', [85, 20, 70, 25], ...
              'String', 'OK', ...
              'Callback', 'delete(gcf)');

[np,~]=size(planos_estereo);
polos_estereo_polares=zeros(np,2);
polos_estereo_cartesianas=zeros(np,2);
% partiendo de omega y beta, determinamos los parámetros en polares de los
% polos y sus coordenadas en cartesianas
% alfa será el ángulo de P' en coordenadas polares
for ii=1:np
    omega = planos_estereo(ii,1);
    if abs(planos_estereo(ii,2))>=pi/2
        beta = pi  + abs(planos_estereo(ii,2));
    else
        beta = abs(planos_estereo(ii,2));
    end
    alfa = o2a(omega);
    polos_estereo_polares(ii,1)= alfa; % angulo alfa de las polares
    polos_estereo_polares(ii,2)= tan (beta / 2); % radio de las polares
    polos_estereo_cartesianas(ii,1)=tan (beta / 2)*cos(alfa); % x en las cartesianas
    polos_estereo_cartesianas(ii,2)=tan (beta / 2)*sin(alfa); % y en las cartesianas
end

% Para depurar el código, voy a meter esta ventana y que me avise de que se
% ha usado la función, para depurar el código

    % Crear la figura de la ventana emergente
    d = dialog('Position', [300, 300, 250, 150], 'Name', 'Aviso');

    % Crear el texto del mensaje
    uicontrol('Parent', d, ...
              'Style', 'text', ...
              'Position', [20, 80, 210, 40], ...
              'String', 'Se ha utilizado prepara_representa, migra a f_calcula_coordenadas_polsovn.');

    % Crear el botón de OK
    uicontrol('Parent', d, ...
              'Position', [85, 20, 70, 25], ...
              'String', 'OK', ...
              'Callback', 'delete(gcf)');


end

