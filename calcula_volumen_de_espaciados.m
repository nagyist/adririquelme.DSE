% Script para calcular bloques
% Meto la matriz de datos con el dip dir y el espaciado
orientaciones=[188.974767412427	49.1640123667251
273.01870605308	48.6994048910664
261.388329113572	76.8910095691889
292.75290627462	77.2906188777661];
espaciados = [0.35 0.37 0.5 0.44];

% Preparo el código para guardar el fichero de salida
[f,message] = fopen('reporte_volumen.txt', 'wt'); % creo la funcíon que abre el archivo para escribir
% Por si acaso, le digo que me muestre el error si lo hay
if f < 0
   error('Failed to open myfile because: %s', message);
end
% Inicio el vuelco del resultado
fprintf(f, 'Cálculo de volumen de bloque medio según la fórmula de Pälmstrom, %s. \n',datetime("today"));
fprintf(f, 'V_b   = S_1 x S_2 x S_3 x sin(g_12) x sin(g_13) x sin(g_23)\n');
fprintf(f, 'V_raw = S_1 x S_2 x S_3 (Se asume que los planos son ortogonales, dando el máximo volumen)\n');
% fprintf(f, 'Comb\tJ1\t\tJ2\t\tJ3\t\tS1\t\t\tS2\t\t\tS3\t\t\tsing12\t\tsing13\t\tsing23\t\tV\t\t\tV_raw \n');
% opción comprimida
fprintf(f, 'Comb\tJ1\tJ2\tJ3\tS1\tS2\tS3\tg12\tg13\tg23\tV\tV_raw \n');
% calculo el número de familias
[n,~]=size(orientaciones);
combinaciones=nchoosek(1:1:n,3);
[ncombinaciones,~]=size(combinaciones);
resultado=zeros(ncombinaciones,12);
for i=1:ncombinaciones
    indices=combinaciones(i,:);
    % calculo los senos entre familias
    [ x1,y1 ] = f_clar2cart( orientaciones(indices(1),1),orientaciones(indices(1),2) );
    [ x2,y2 ] = f_clar2cart( orientaciones(indices(2),1),orientaciones(indices(2),2) );
    [ x3,y3 ] = f_clar2cart( orientaciones(indices(3),1),orientaciones(indices(3),2) );
    [N1]=f_pole2vnor ( x1, y1);
    [N2]=f_pole2vnor ( x2, y2);
    [N3]=f_pole2vnor ( x3, y3);
    gamma12=acos(abs(dot(N1,N2)));
    gamma13=acos(abs(dot(N1,N3)));
    gamma23=acos(abs(dot(N2,N3)));
    senos=sin(gamma12)*sin(gamma13)*sin(gamma23);
    S1=espaciados(indices(1));
    S2=espaciados(indices(2));
    S3=espaciados(indices(3));
    V=S1*S2*S3*senos;
    resultado(i,1)=i;
    resultado(i,2)=combinaciones(i,1);
    resultado(i,3)=combinaciones(i,2);
    resultado(i,4)=combinaciones(i,3);
    resultado(i,5)=S1;
    resultado(i,6)=S2;
    resultado(i,7)=S3;
    resultado(i,8)=rad2deg(gamma12);
    resultado(i,9)=rad2deg(gamma13);
    resultado(i,10)=rad2deg(gamma23);
    resultado(i,11)=V;
    resultado(i,12)=S1*S2*S3;
    % Grabo una línea del resultado
    % fprintf(f, '%1.0f\t\t%1.0f\t\t%1.0f\t\t%1.0f\t\t%1.4f\t\t%5.4f\t\t%5.4f\t\t%5.4f\t\t%5.4f\t\t%5.4f\t\t%5.4f\t\t%5.4f \n', resultado(i,:)');
    % opción comprimida
    fprintf(f, '%1.0f\t%1.0f\t%1.0f\t%1.0f\t%1.4f\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%5.4f\t%5.4f \n', resultado(i,:)');


end

