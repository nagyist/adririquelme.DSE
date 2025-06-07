function [polos_pples, polos_pples_cart ] = f_busca_max_relativo_densidad(x_grid, y_grid, density, densidadminima, angle_limit, N, proyeccion)
% [polos_pples, polos_pples_cart ] = f_busca_max_relativo_densidad(x_grid, y_grid, density, densidadminima, angle_limit, N, proyeccion)
% Inputs:
% - x_grid, y_grid: arreglos de las coordenadas de los puntos, de dimensión nxn
% - density: arreglo con los valores de densidad, tb nxn
% - densidadminima: % de la máxima densidad para aceptar un máximo local, antes era tolerancia
% - angle_limit = 20; % Límite de ángulo en grados para la selección de máximos relativos
% - N = 10; % Número de puntos de mayor densidad
% - proyeccion: 'Equal-angle' o 'Equal-area', para convertir el polo en normal
% Output:
% - polos_pples(alfa, beta, fdensidad). Coordenadas polares en grados
% - polos_pples_cart(x,y) de P'. Coordenadas cartesianas
% La densidad mínima está en tanto por uno, por lo que calculo
% el valor mínimo para ser considerado
densidadminima=densidadminima*max(max(density));
grid_points = [x_grid(:), y_grid(:)];
relative_maxima = [];
[resolucion,~]=size(x_grid);
for i = 1:resolucion
    for j = 1:resolucion
        if i == 1 || i == resolucion || j == 1 || j == resolucion
            current_point = [x_grid(i, j), y_grid(i, j)];
            [indices, ~] = knnsearch(grid_points, current_point, 'K', 9);
            neighbors = density(indices(2:end));
            if density(i, j) > densidadminima && all(density(i, j) >= neighbors)
                relative_maxima = [relative_maxima; x_grid(i, j), y_grid(i, j), density(i, j)];
            end
        else
            neighbors = [density(i-1, j-1), density(i-1, j), density(i-1, j+1), ...
                density(i, j-1), density(i, j+1), ...
                density(i+1, j-1), density(i+1, j), density(i+1, j+1)];
            if density(i, j) > densidadminima && all(density(i, j) > neighbors)
                relative_maxima = [relative_maxima; x_grid(i, j), y_grid(i, j), density(i, j)];
            end
        end
    end
end
% Ordenar los máximos relativos por densidad de mayor a menor
relative_maxima = sortrows(relative_maxima, -3);
% Aplicamos el test de la proyección entre normales
cos_angle_limit = cos(deg2rad(angle_limit));
top_N_density = [];
top_N_positions = [];
top_N_normals = [];
for i = 1:size(relative_maxima, 1)
    if length(top_N_density) >= N
        break;
    end
    % [ N ] = f_pole2vnor_v02( poles_cart,projection )
    % normal = relative_maxima(i, 1:3);
    normal = f_pole2vnor_v02 (relative_maxima(i, 1:3),proyeccion);
    if isempty(top_N_normals)
        if normal(3)<0 % Si el vector normal está en el hemisferio inferior, lo invierto para que apunte al hemisferio superior
            normal=-normal;
        end
        top_N_density = [top_N_density; relative_maxima(i, 3)];
        top_N_positions = [top_N_positions; normal];
        top_N_normals = [top_N_normals; normal];
    else
        valid = true;
        for j = 1:size(top_N_normals, 1)
            projection = abs(dot(normal, top_N_normals(j, :)) / (norm(normal) * norm(top_N_normals(j, :))));
            if projection > cos_angle_limit
                valid = false;
                break;
            end
        end
        if valid
            top_N_density = [top_N_density; relative_maxima(i, 3)];
            if normal(3)<0 % Si el vector normal está en el hemisferio inferior, lo invierto para que apunte al hemisferio superior
                normal=-normal;
            end
            top_N_positions = [top_N_positions; normal];
            top_N_normals = [top_N_normals; normal];
        end
    end
end

dmax=top_N_density;
[ dipdir, dip ] = f_vnorm2clar_v02( top_N_normals );
[ Xmax, Ymax ] = f_clar2cart( dipdir, dip, proyeccion );
polos_pples=[ dipdir, dip, dmax] ; % en radianes
polos_pples_cart=[ Xmax, Ymax,dmax ];

end