function R = f_calcula_matriz_rotacion(angulos)
% R = f_calcula_matriz_rotacion(angulos)
% Angulos son dos o tres (Euler)
gradosdelibertad=length(angulos);
switch gradosdelibertad
    case 3 % Tengo 3 grados de libertad
        % Ya tengo directamente la matriz de rotación
        R=eul2rotm(angulos/180*pi); % Como vienen en grados, paso a radianes
    case 2 % Tengo 2 grados de libertad
        % Tengo los dos ángulos de giro. Primero defino la matriz de rotación
        % Los valores de alpha y beta se los pasará la optimización
        alpha=angulos(1)/180*pi; % Como vienen en grados, paso a radianes
        beta=angulos(2)/180*pi;
        u=[+cos(alpha) -sin(alpha) 0];
        v=[cos(beta)*sin(alpha) cos(beta)*cos(alpha) -sin(beta)];
        w=[sin(beta)*sin(alpha) sin(beta)*cos(alpha) +cos(beta)];
        R(:,1)=u; R(:,2)=v;R(:,3)=w;
    otherwise
        % Algo falla
end

end