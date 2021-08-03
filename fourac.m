clear
clc
T0 = 30;% ambient temp
T_top = 50; %top side car temp
T_ac = 10;
x = T0 + zeros(1,25);
y = T0 + zeros(1,17);
z = T0 + zeros(1,15);
T1 = meshgrid(y,x,z);
a = 7;b = 3; % human location on xy axises

T1(1,:,1:10)=T0;T1(:,1,1:7.5)=T0;T1(:,:,1)=T0;
T1(25,:,1:10)=T0;T1(:,17,1:7.5)=T0; %% surface temp

T1(5:25,:,15)=T_top; % roof tmep

T1(a:a+2,b:b+4,2:9)=37; % A man 
T1(5:6,1:4,9:10) = T_ac;
T1(5:6,8:10,9:10) = T_ac;
T1(5:6,14:17,9:10) = T_ac;
T1(15:16,8:10,6:7) = T_ac; % The dimension of heater
T1(5,:,10:15) = T0;
T1(25,:,10:15) = T0;
T1(5:25,1,10:15) = T0;
T1(5:25,17,10:15) = T0;%glass temperature

T2 = T1;

k1 = 0.12; % air-air
k2 = 0.001; % air-wall
k3 = 1; % heater-air
k4 = 0.001; % window-air
k5 = 0.001; %skin-air
k = T1 - T0 + k1; %matrix of k
k(1,:,1:10) = k2; k(:,1,1:7.5) = k2; k(:,:,1) = k2;
k(25,:,1:10) = k2; k(:,17,1:7.5) = k2; k(5:25,:,15)= k2;
k(5,:,10:15) = k4; k(25,:,10:15) = k4;
k(5:25,1,10:15) = k4;k(5:25,17,10:15) = k4;%window
k(5:6,1:4,9:10) = k3;k(5:6,8:10,9:10) = k3;k(5:6,14:17,9:10) = k3;k(15:16,8:10,6:7) = k3; %heater
k(a:a+2,b:b+4,2:9) = k5;% man
%% calculation
T_up = 0;
T_down = 0;
for t = 1:2
 for n = 2:9
     for j = 2:16
         for i = 2:24
             T2(i,j,n) = T1(i,j,n) - k(i,j+1,n)*(T1(i,j,n)-T1(i,j+1,n))- k(i,j-1,n)*(T1(i,j,n)-T1(i,j-1,n))- k(i+1,j,n)*(T1(i,j,n)-T1(i+1,j,n))- k(i-1,j,n)*(T1(i,j,n)-T1(i-1,j,n))-k(i,j,n+1)*(T1(i,j,n)-T1(i,j,n+1))-k(i,j,n-1)*(T1(i,j,n)-T1(i,j,n-1));
             T_down = T_down + T2(i,j,n);
         end
     end
 end
 
for n = 10:13
    for j = 2:16
        for i = 6:24
             T2(i,j,n) = T1(i,j,n) - k(i,j+1,n)*(T1(i,j,n)-T1(i,j+1,n))- k(i,j-1,n)*(T1(i,j,n)-T1(i,j-1,n))- k(i+1,j,n)*(T1(i,j,n)-T1(i+1,j,n))- k(i-1,j,n)*(T1(i,j,n)-T1(i-1,j,n))-k(i,j,n+1)*(T1(i,j,n)-T1(i,j,n+1))-k(i,j,n-1)*(T1(i,j,n)-T1(i,j,n-1));
             T_up = T_up + T2(i,j,n);
        end
    end
end
T2(1,:,1:10)=T0;T2(:,1,1:7.5)=T0;T2(:,:,1)=T0;
T2(25,:,1:10)=T0;T2(:,17,1:7.5)=T0; %%surface temperature

T2(5:25,:,15)=T_top; %roof temperature

T2(a:a+2,b:b+4,2:9)=37; % A man 
T2(5:6,1:4,9:10) = T_ac;
T2(5:6,8:10,9:10) = T_ac;
T2(5:6,14:17,9:10) = T_ac; T2(15:16,8:10,6:7) = T_ac;% The dimension of heater
T2(5,:,10:15) = T0;
T2(25,:,10:15) = T0;
T2(5:25,1,10:15) = T0;
T2(5:25,17,10:15) = T0;% glass temperature
T2(1:4,:,11:15)=T0;

T1 = T2;
average(t)= mean(mean(mean(T2)));
end

%%  plot the distribution
tmin=min(min(min(T1)));
tmax=max(max(max(T1)));
H_FIG=figure('position',[200,200,800,550]);
H_AXES=axes;
hold on;
colormap(jet(1000));    
my_colormap=H_FIG.Colormap;
for i=1:10
    for j=1:17
        for n=1:25
            T=T1(n,j,i);
            color_idx=1+round((length(my_colormap(:,1))-1)*(T-tmin)/(tmax-tmin));
            plot3(n,j,i,'.','color',my_colormap(color_idx,:))
        end
    end
end
hold on
for i = 11:15
    for j = 1:17
        for n = 5:25
            T=T1(n,j,i);
            color_idx=1+round((length(my_colormap(:,1))-1)*(T-tmin)/(tmax-tmin));
            plot3(n,j,i,'.','color',my_colormap(color_idx,:))
        end
    end
end
title('Tempreature distribution in cabin');

xlabel('X/dm');
ylabel('Y/dm');
zlabel('Z/dm');
view([-1,-1,1]);
set(H_AXES,'XGrid','on','YGrid','on','ZGrid','on','FontSize',10);
H_colorbar=colorbar;
H_colorbar.Label.String = 'Temperature/degrees Celsius';
TicksLabel=cell(1,11);
for m=1:11
TicksLabel{m}=(m-1)/10*(tmax-tmin)+tmin;
end
set(H_colorbar,'Ticks',0:0.1:1,'TickLabels',TicksLabel);
hold off;
%% plot the change
% figure;
% hold on
% title('Temperature change according to time');
% xlabel('Time/s');
% ylabel('Temperature/degrees Celsius')
% legend;
% t=1:1000;
% plot(t,average);