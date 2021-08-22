clear, clc, close all
WATERPCM1 = readtable("Data Olah Kape - 03 04 - Water - 2020 12 12.xlsx","Sheet","Sheet1");
PCM1 = readtable("Data Olah Kape - 01 02 - PCM 1 - 2020 12 12.xlsx","Sheet","Sheet1");
tPCM1 = readtable("TimePCM1.csv");
WATERPCM1 = standardizeMissing(WATERPCM1, -127 );
PCM1 = standardizeMissing(PCM1, -127 );
WATERPCM1 = fillmissing(WATERPCM1,"nearest");
PCM1 = fillmissing(PCM1,"nearest");
%plot(WATERPCM1.Variables)
%plot(PCM1.Variables)
writetable(PCM1,'PCM1.xlsx','Sheet',1);
writetable(WATERPCM1,'WATERPCM1.xlsx','Sheet',2);
NewOrder = [1 4 7 10 13 16 19 22 25 2 5 8 11 14 17 20 23 26 3 6 9 12 15 18 21 24 27 28 29 30 31 32];
PCM1 = PCM1(:,NewOrder);
WATERPCM1 = WATERPCM1(:,NewOrder);
PCM1 = table2array(PCM1);
WATERPCM1 = table2array(WATERPCM1);
x = 0:25:50;   % first dimension independent variable
y = 0:19:38;   % second dimension independent variable
z = 0:10:20;   % third dimension independent variable
[X, Y, Z] = meshgrid(x, y, z);  % form the 3D grid
% form the user data matrix
% the data could be imported from .txt or .xls file

h = figure("Units","normalized","OuterPosition",[0 0 1 1]);
for a = 1:90:90000
%for a = 18316

A(:,:,1) = [PCM1(a,1:3);PCM1(a,4:6);PCM1(a,7:9);];
A(:,:,2) = [PCM1(a,10:12);PCM1(a,13:15);PCM1(a,16:18);];
A(:,:,3) = [PCM1(a,19:21);PCM1(a,22:24);PCM1(a,25:27);];

    
B(:,:,1) = [WATERPCM1(a,1:3);WATERPCM1(a,4:6);WATERPCM1(a,7:9);];
B(:,:,2) = [WATERPCM1(a,10:12);WATERPCM1(a,13:15);WATERPCM1(a,16:18);];
B(:,:,3) = [WATERPCM1(a,19:21);WATERPCM1(a,22:24);WATERPCM1(a,25:27);];


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
    title(['PCM1 = \it{f} \rm(X, Y, Z, T,TANGGAL ',datestr(datenum(datevec(table2array((tPCM1(a,1))))),"dd/mm/yyyy"),' JAM ',datestr(datenum(datevec(table2array((tPCM1(a,2))))),"hh:MM:ss"),')'])
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
    title(['WATER= \it{f} \rm(X, Y, Z, T,TANGGAL ',datestr(datenum(datevec(table2array((tPCM1(a,1))))),"dd/mm/yyyy"),' JAM ',datestr(datenum(datevec(table2array((tPCM1(a,2))))),"hh:MM:ss"),')'])
    axis([0 50 0 38 0 20])
    caxis([mincolor1 maxcolor1])
    alpha(0.75)
    colorbar
    make_animation( h,a,'PCM1_Vs_Water_animation.gif' )
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