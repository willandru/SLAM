
% Remove old analysis files

if exist('Statistics.png', 'file') == 2
    delete('Statistics.png')
end

if exist('PlotSLAMvsGT.png', 'file') == 2
    delete('PlotSLAMvsGT.png')
end

% Globals


if exist('Statistics.png', 'file') == 2
    delete('Statistics.png')
end


imagen1 = imread('Real_cartographer.pgm');
imagen2 = imread('Real_hector.pgm');
A=imagen2(950:1047, 1000:1114);
map1 = imagen1; %size: 98x155
map2 = A;  %size: 98x155


%map1=image1;
%map2=image2;

sumOfDistances = 0;

rowsSampler     = 1000;
colsSampler     = 1000;
pixToCentimeter = 5.29;

% Make the ground truth suitable
%GT_Matrix = imread('Ground_Truth.png');
GT_Matrix = map1;
GT_Matrix = imbinarize(GT_Matrix);
[GTrowSize, GTcolSize, GTdepth] = size(GT_Matrix);
GTBlackPoints = blkPoints(GT_Matrix, rowsSampler, colsSampler);

% Make the SLAM map suitable
%SLAM_Map_Matrix = imread('SLAM_Gen_Map.png');
SLAM_Map_Matrix = map2;
SLAM_Map_Matrix = imbinarize(SLAM_Map_Matrix);
[SLrowSize, SLcolSize, SLdepth] = size(SLAM_Map_Matrix);
SLAMBlackPoints = blkPoints(SLAM_Map_Matrix, rowsSampler, colsSampler);

% Scale the SLAM coordinates to match the ground truth sizing
Scale_row = GTrowSize/SLrowSize;
Scale_col = GTcolSize/SLcolSize;
SLAMBlackPoints(:,1) = SLAMBlackPoints(:,1)*Scale_row;
SLAMBlackPoints(:,2) = SLAMBlackPoints(:,2)*Scale_col;

% Use the knnsearch function
[knearNeigh, distances] = knnsearch(GTBlackPoints, SLAMBlackPoints);

distances_cm = distances(:,1)/pixToCentimeter;

% Sum all the distances to get an idea of how different they are
[slamRowSize, slamColSize] = size(distances_cm);

% Plot GT and SLAM together
p = figure('visible','off');
scatter(SLAMBlackPoints(:,1)/(pixToCentimeter*100), SLAMBlackPoints(:,2)/(pixToCentimeter*100), '.')
hold on
scatter(GTBlackPoints(:,1)/(pixToCentimeter*100), GTBlackPoints(:,2)/(pixToCentimeter*100), '.')
xlabel('meters')
ylabel('meters')
Legend = legend("SLAM", "Ground Truth");
Legend.Location = 'northeast';
Legend.Color = 'none';
Legend.EdgeColor = 'none';
camroll(-90)
axis equal
saveas(p,'PlotSLAMvsGT','png')


% Plot a figure with all the relevant statistics
f=figure('visible','off');
subplot(2,2,1)
histogram(distances_cm)
ylabel('Frequency') 
xlabel('Distance (cm)') 
title("Histogram for distances")
subplot(1,2,2)
boxplot(distances_cm)
ylabel('Distance (cm)')
title("Boxplot for distances")
subplot(2,2,3)
text(0,0.96,"\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_"  ); axis off
text(0,0.95,"\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_"  ); axis off
text(0,0.8 ,"Mean: "                            ); axis off
text(0.4,0.8, string(mean(distances_cm(:,1)))   ); axis off
text(0,0.7 ,"Mode: "                            ); axis off
text(0.4,0.7, string(mode(distances_cm(:,1)))   ); axis off
text(0,0.6 ,"Median: "                          ); axis off
text(0.4,0.6, string(median(distances_cm(:,1))) ); axis off
text(0,0.5 ,"Samples: "                         ); axis off
text(0.4,0.5, string(slamRowSize)               ); axis off
text(0,0.4 ,"Stdev: "                           ); axis off
text(0.4,0.4, string(std(distances_cm(:,1)))    ); axis off
text(0,0.3 ,"Min: "                             ); axis off
text(0.4,0.3, string(min(distances_cm(:,1)))    ); axis off
text(0,0.2 ,"Max: "                             ); axis off
text(0.4,0.2, string(max(distances_cm(:,1)))    ); axis off
text(0,0.1 ,"Mode: "                            ); axis off
text(0.4,0.1, string(mode(distances_cm(:,1)))   ); axis off
text(0,0.06,"\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_"  ); axis off
text(0,0.05,"\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_"  ); axis off
title("Descriptive statistics")
saveas(f,'Statistics','png')

fprintf("Completed! \n")

% Generates matrix with x and y coordinates of each black point in the image
%     It allows a maximum of rowRes x colRes points

function blkMatrix = blkPoints(image, rowRes, colRes)
    % Pre-allocate a matrix to hold the black points
    blkMatrix = zeros(rowRes * colRes, 2);
    [rowSize, colSize] = size(image);

    rowStep = max(floor(rowSize / rowRes), 1); % Calculate the step size for rows
    colStep = max(floor(colSize / colRes), 1); % Calculate the step size for columns

    % Initialize counters
    pointCount = 1;

    % Loop through the image with the determined step size
    for r = 1:rowStep:rowSize
        for c = 1:colStep:colSize
            if image(r, c) == 0 % If the pixel is black, add it to the matrix
                blkMatrix(pointCount, :) = [r, c];
                pointCount = pointCount + 1;
            end
        end
    end

    % Trim the blkMatrix to the actual number of points found
    blkMatrix = blkMatrix(1:pointCount-1, :);
end

