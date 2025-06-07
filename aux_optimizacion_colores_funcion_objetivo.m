function F = aux_optimizacion_colores_funcion_objetivo(angulos,vectores_normales,subsample,funcionobjetivo)
% Función objetivo para optimizar la representación de los colores de las normales. Quiero optimizar la rotación del SR, que se da en dos ángulos, tal que la distancia de los polos al contorno del estereograma sea mínimo
% Esta función trabaja con dos o tres gados de libertad, para definir la matriz de rotación R, que se hace en otro sitio
% Input:
% angulos: vector los ángulos que definen la rotación, que pueden ser dos o tres, en grados
% vectores: vectores normales en sus tres componentes, que son las que rotaré y emplearé para calcular los residuos de la función objetivo
% subsample: porcentaje en tanto por uno del muestreo que haré en cada iteración
% funcionobjetivo: selecciona cuál es la función objetivo
% - potencial,  identidad
% - potencial, cuadrática
% - potencial, cúbica
% - rational, racional con asíntota vertical en 90º

% Lo primero que hago es convertir los ángulos a radianes, porque vienen en grados
angulos=angulos*pi/180;
gradosdelibertad=length(angulos); % la dimensión del vector ángulos nos da los grados de libertad, que son 2 o 3

switch gradosdelibertad
    case 2
        % Defino la matriz de rotación
        % Los valores de alpha y beta se los pasará la optimización
        alpha=angulos(1); 
        beta=angulos(2);
        u=[+cos(alpha) -sin(alpha) 0];
        v=[cos(beta)*sin(alpha) cos(beta)*cos(alpha) -sin(beta)];
        w=[sin(beta)*sin(alpha) sin(beta)*cos(alpha) +cos(beta)];
        R(:,1)=u; R(:,2)=v;R(:,3)=w;
    case 3
        % Tres gados de libertad
        R=eul2rotm(angulos);
    otherwise
        % ha habido un problema
end
switch subsample
    case 1
        % Me dicen que calcule con el 100% de los datos, así que no hago nada
        densidad=zeros(length(vectores_normales),1);
        densidad(:)=1;
        densidad_total=1;
    case 0
        % Tengo las normales con densidad
        densidad=vectores_normales(:,4);
        % densidad(:)=1;
        densidad_total=sum(densidad);
        vectores_normales=vectores_normales(:,1:3);
    otherwise
        % Ahora sí que tengo que meter subsample
        % Tengo una población de vectores normales, a la que le aplico un
        % sumbsample
        [n,~]=size(vectores_normales);
        n_subsample=floor(n*subsample);
        % Genero n_subsample indices para extraer los polos
        r=randi([1,n],n_subsample,1);
        % Por si acaso, elimino los duplicados
        r=unique(r);
        % Ahora tomo los vectores normales tras el muestreo
        vectores_normales=vectores_normales(r,:);
        % Finalmente, genero la densidad
        densidad=zeros(length(vectores_normales));
        densidad(:)=1;
        densidad_total=1;
end
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
[ ~, buzamiento ] = f_vnorm2clar( normales_rotadas ); % Me da el buzamiento en grados

% Calculo la función objetivo seleccionada
% Va a calcular con el buzamiento en grados, luego la OF está en grados
n=length(buzamiento);
% Tengo varias funciones objetivo candidatas, que probaré en el artículo
switch funcionobjetivo
    case 'potential_linear'
        % F=sum(buzamiento.*densidad)/sum(densidad); % La suma de buzamientos, simple
        % F=sum(buzamiento)/(n); % La suma de buzamientos, simple
        K=1;
        % F=sum((buzamiento.^K).*densidad/sum(densidad))^(1/K);
        F=sum((buzamiento.^K).*densidad/sum(densidad));
    case 'potential_quadratic'
        K=2;
        % F= (buzamiento'*buzamiento/n)^(0.5); % Sería como el residuo de cuadrados, en buzamiento
        % F= sum(((buzamiento'*buzamiento).^(0.5))/n.*densidad)/densidad_total; % Sería como el residuo de cuadrados, en buzamiento
        % F=sum((buzamiento.^K).*densidad/sum(densidad))^(1/K);
        F=sum((buzamiento.^K).*densidad/sum(densidad));
    case 'potential_cubic'
        % F= sum(buzamiento.*buzamiento.*buzamiento/n)^(1/3); % Lo mismo pero al cubo, para penalizar más
        K=3;
        % F=sum((buzamiento.^K).*densidad/sum(densidad))^(1/K);
        F=sum((buzamiento.^K).*densidad/sum(densidad));
    case 'rational_vertical_asymptote'
        % F= sum((90.-buzamiento).^(-2)-(2/pi)^2); % En esta buscamos una penalización muy muy fuerte, cuando se acerca al borde. En b=0 el valor es 0.
        % K=1;
        % Cuidado, buzamientos están en grados, pon la F en grados
        % F = sum( ( (2/pi).^K - (pi/2.-buzamiento).^(-K) ) .* densidad ) / sum (densidad);
        % F = sum( ( (1/90).^K - (90.-buzamiento).^(-K) ) .* densidad ) / sum (densidad);
        F = sum( (  (91.-buzamiento).^(-1) - (1/91).^1) .* densidad ) / sum (densidad);
    case 'steps'
        % Función escalonada
        F=0; K=0; % inicio estas auxiliares
        alfa1=60/180*pi; K1=10; % rangos de ángulos y pesos
        alfa2=75/180*pi; K2=1000;
        % Los polos por debajo de 60 no dan valor
        % Los polos entre 60 y 75 dan un peso de K1
        % I=find(and(buzamiento>alfa1,buzamiento<alfa2)); F=F+length(I); K=K+length(I)*K1;
        % Los polos entre 75 y 90 dan un peso de K2
        % J=find(buzamiento>=alfa2); F=(F+length(I)*K2); K=K+length(I)*K2;
        % F=F/(length(buzamiento)*K2); 
        % I=find(and(buzamiento>alfa1,buzamiento<alfa2)); J=find(buzamiento>=alfa2);
        F=sum(densidad(and(buzamiento>alfa1,buzamiento<alfa2))*K1)+sum(densidad(buzamiento>=alfa2)*K2);
        F=F/(sum(densidad)*length(buzamiento)*K2);
        % Es un % de los polos que están en el borde...
    otherwise
        error('Algo ha fallado en la función de optimización');
end
% Ha terminado de calcular, me devuelve F correspondiente a esos ángulos
end

% Notas: en las funciones hacía la raíz k-ésima, pero no hay mejora porque
% no cumple su función de acelerar en bordes la OF