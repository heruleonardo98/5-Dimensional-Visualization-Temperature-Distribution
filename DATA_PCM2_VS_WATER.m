clear, clc, close all
PCM2 = readtable("Data Olah Kape - 01 02 - PCM 2 - 2020 11 18.xlsx","Sheet","TemperaturePCM2");
WATERPCM2 = readtable("Data Olah Kape - 03 04 - Water - 2020 11 18.xlsx","Sheet","TemperatureWater");
tPCM2 = readtable("DateAndTimePCM2VsWater.csv");
WATERPCM2 = standardizeMissing(WATERPCM2, -127 );
PCM2 = standardizeMissing(PCM2, -127 );
WATERPCM2 = fillmissing(WATERPCM2,"nearest");
PCM2 = fillmissing(PCM2,"nearest");
%plot(WATERPCM1.Variables)
%plot(PCM1.Variables)
writetable(PCM2,'PCM2.xlsx','Sheet',1);
writetable(WATERPCM2,'WATERPCM1.xlsx','Sheet',2);
NewOrder = [1 4 7 10 13 16 19 22 25 2 5 8 11 14 17 20 23 26 3 6 9 12 15 18 21 24 27 28 29 30 31 32];
PCM2 = PCM2(:,NewOrder);
WATERPCM2 = WATERPCM2(:,NewOrder);
PCM2 = table2array(PCM2);
WATERPCM2 = table2array(WATERPCM2);
x = 0:25:50;   % first dimension independent variable
y = 0:19:38;   % second dimension independent variable
z = 0:10:20;   % third dimension independent variable
[X, Y, Z] = meshgrid(x, y, z);  % form the 3D grid
% form the user data matrix
% the data could be imported from .txt or .xls file

h = figure("Units","normalized","OuterPosition",[0 0 1 1]);
%for a = 1:90:92782
%for a = 1:90:20000
for a = 1000

A(:,:,1) = [PCM2(a,1:3);PCM2(a,4:6);PCM2(a,7:9);];
A(:,:,2) = [PCM2(a,10:12);PCM2(a,13:15);PCM2(a,16:18);];
A(:,:,3) = [PCM2(a,19:21);PCM2(a,22:24);PCM2(a,25:27);];

    
B(:,:,1) = [WATERPCM2(a,1:3);WATERPCM2(a,4:6);WATERPCM2(a,7:9);];
B(:,:,2) = [WATERPCM2(a,10:12);WATERPCM2(a,13:15);WATERPCM2(a,16:18);];
B(:,:,3) = [WATERPCM2(a,19:21);WATERPCM2(a,22:24);WATERPCM2(a,25:27);];


% prepare the colorbar limits
mincolor = min(A(:));        % find the minimum of the data function
maxcolor = max(A(:));     % find the maximum of the data function
mincolor1 = min(B(:));        % find the minimum of the data function
maxcolor1 = max(B(:));     % find the maximum of the data function

colormap jet


    % plot the data
    subplot(1,2,1)
    slice(X, Y, Z, A , 0:50, 0:38, 0:20,'nearest')
    shading interp
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    title(['PCM = \it{f} \rm(X, Y, Z, T,TANGGAL ',datestr(datenum(datevec(table2array((tPCM2(a,1))))),"dd/mm/yyyy"),' JAM ',datestr(datenum(datevec(table2array((tPCM2(a,2))))),"hh:MM:ss"),')'])
    axis([0 50 0 38 0 20])
    caxis([mincolor maxcolor])
    alpha(0.75)
    colorbar




    % write the equation that describes the fifth dimension
    C = B(:);
    
    % plot the data
    subplot(1,2,2)
    slice(X, Y, Z, B , 0:50, 0:38, 0:20,'nearest')
    shading interp
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    title(['WATER= \it{f} \rm(X, Y, Z, T,TANGGAL ',datestr(datenum(datevec(table2array((tPCM2(a,1))))),"dd/mm/yyyy"),' JAM ',datestr(datenum(datevec(table2array((tPCM2(a,2))))),"hh:MM:ss"),')'])
    axis([0 50 0 38 0 20])
    caxis([mincolor1 maxcolor1])
    alpha(0.75)
    colorbar
    make_animation( h,a,'PCM2_Vs_Water_animation.gif' )
    %pause(0.2) %you can enter the time in pause to change the loop
end

function make_animation( h,index,filename )
drawnow
frame = getframe(h);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
if index == 1
    imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
else
    imwrite(imind,cm,filename,'gif','WriteMode','append');
end
end