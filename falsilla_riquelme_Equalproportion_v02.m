% Riquelme -- Program for plotting a stereonet for DSE
% Written by Adrian Riquelme, September 2016
% ariquelme@ua.es
% Department of Civil Engineering, University of Alicante, Spain

% First, we define the circle and the axis
% Code extracted from the wulff net
% Versión 02: corrijo posición de 0 y 180, añado etiquetas NS

etiquetamos=1; % variable para ver si etiqueto o no

N = 50;
cx = cos(0:pi/N:2*pi);                           % points on circle
cy = sin(0:pi/N:2*pi);
xh = [-1 1];                                     % horizontal axis
yh = [0 0];
xv = [0 0];                                      % vertical axis
yv = [-1 1];
axis([-1 1 -1 1]);
axis('square');
plot(xh,yh,'-.k',xv,yv,'-.k');                     %plot green axes
axis off;
hold on;
plot(cx,cy,'--k');                                %plot white circle

% Now, we draw the circles that refer to the dip angle
psi = [0:pi/N:2*pi];
beta=[15 30 45 60 75 90]/180*pi;
[~,n]=size(beta);
for i = 1:(n-1)                                   % plot dip circles
   % [radio]=f_radio(beta(i));
   radio = beta(i)/(pi/2); % Radio para proyección Equal-proportion
   x = radio .* sin(psi);
   y = radio .* cos(psi);
   plot(x,y,':r');
   switch etiquetamos
       case 1
           % Etiqueto el buzamiento
           text(radio,0,num2str(beta(i)*180/pi),'HorizontalAlignment','Left','Verticalalignment','bottom','FontSize',8);
   end
end
switch etiquetamos
    case 1
        % Inserto el label del buzamiento de 90
        radio = 2^(0.5)*sin(90*pi/180/2); % Radio para proyección Equal-area
        text(radio,0,num2str(90),'HorizontalAlignment','Left','Verticalalignment','bottom','FontSize',8);
end

axis('square');

% Finally, we draw the circles that refer to the dip direction
alpha0 = 0:pi/6:(2*pi-pi/12);
alpha = pi/2 - alpha0+pi;
etiqueta = 0:360/12:(330);
% Radio de la etiqueta. Si es 1 estará sobre el círculo, pon 1,1 o 1,2.
radio_etiqueta=1.15;
x = radio_etiqueta*cos(alpha);
y = radio_etiqueta*sin(alpha);
[~,n]=size(alpha);
tamanyoangulos=12;
for i=1:n
    % condiciono el etiquetado a una variable, por si no quiero etiquetarlo
    switch etiquetamos
        case 1
            % le pongo su etiqueta el ángulo respecto al norte
            amplificador=1.1;
            switch etiqueta(i)
                case 0
                    text(x(i),y(i),'0\equivS','HorizontalAlignment','center','VerticalAlignment','cap','FontSize',tamanyoangulos);
                case 180
                    text(x(i),y(i)*amplificador,'180\equivN','HorizontalAlignment','center','VerticalAlignment','cap','FontSize',tamanyoangulos);
                case 90
                    text(x(i),y(i),'90\equivW','HorizontalAlignment','Right','FontSize',tamanyoangulos);
                case 270
                    text(x(i),y(i),'270\equivE','HorizontalAlignment','Left','FontSize',tamanyoangulos);
                otherwise
                    if etiqueta(i)>0 && etiqueta(i)<180
                        text(x(i),y(i),num2str(etiqueta(i)),'HorizontalAlignment','Right','FontSize',tamanyoangulos);
                    else
                        text(x(i),y(i),num2str(etiqueta(i)),'HorizontalAlignment','Left','FontSize',tamanyoangulos);
                    end
            end
        case 0
            % no etiqueto
        otherwise
            % Algo va mao
    end
    % Etiqueto el buzamiento
    radio = 2^(0.5)*sin(15*pi/180/2);
    xaux=[radio*cos(alpha(i))  cos(alpha(i))];
    yaux=[radio*sin(alpha(i))  sin(alpha(i))];
    plot(xaux,yaux,'r:.');
    % pongo una pequeña línea para marcar dónde va ese label
    xaux=[cos(alpha(i))  1.05*cos(alpha(i))];
    yaux=[sin(alpha(i))  1.05*sin(alpha(i))];
    plot(xaux,yaux,'k-');
end

