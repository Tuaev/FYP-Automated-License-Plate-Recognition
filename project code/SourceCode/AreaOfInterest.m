function [AOI,Number,Letters,Continu,licenseBox]=AreaOfInterest(singleFrame,handles)


% Adjusting the image
Ig=rgb2gray(singleFrame);        % Conversion to grayscale
I1=imadjust(Ig);                 % Improving the image contrast
I=double(I1);                    % Converting to double percision

%----------------Selection of the region of interest-----------------
startingLine = 150;
sm=250;                       % offset(moving down)
point1=[1 startingLine];      % From Column to Row [C R]
point2=[768 startingLine+sm]; % From Colum to Row [C R]

rmin=round(point1(1,1));        % rounding to the nearest numbers
rmax=round(point2(1,1));
cmin=round(point1(1,2));
cmax=round(point2(1,2));

I2=I1(cmin:cmax,rmin:rmax); % storing region of interest in I2
%      figure,imshow(I2);


%--------Applying sobel edge detector--------
dx=[-1 0 1; -1 0 1; -1 0 1];    % Sobel mask horizontal
dy=dx';                         % Sobel mask vertical
% Applying mask to image
Ix=conv2(double(I2),dx,'same'); % Gradient of x
Iy=conv2(double(I2),dy,'same'); % Gradient of y

%--------Applying gausian filter on computed values--------
sigma=2;
g=fspecial('gaussian',max(1,fix(6*sigma)),sigma);
Ix2=conv2(Ix.^2,g,'same');
Iy2=conv2(Iy.^2,g,'same');
Ixy=conv2(Ix.*Iy,g,'same');

%--------------Harris Corner Detector------------
k=0.04;      % Harris parameter
Tr = (Ix2 + Iy2);                 % Trace
Det = (Ix2.*Iy2 - Ixy.^2);        % Determinant
Respon=Det - k*Tr.^2;             % Reponse
R=(1000/max(max(Respon)))*Respon; % Rationing weights

%--------Non-maximal suppression and threshold--------
radius=6;                        % radius of region considered in non-maximal suppression.
sze=2*radius+1;                  % The size of the mask
MX=ordfilt2(R,sze^2,ones(sze));  % dilation of gray scale

thresHold=150;                   % threshold -- 150
R11=(R==MX)&(R>thresHold);       % Singular points that are greater than the threshold

[r1,c1]=find(R11);   % The coordinates of the points in the region of interest
cordRC=[r1 c1];      % Storing coordinates


%---------------Locating License plate----------------
heightBox=get(handles.edit8,'String');
heightSize=str2double(heightBox);           % window height
widthBox=get(handles.edit5,'String');
widthSize=str2double(widthBox);         % window width
s1=15;          % Shifting up
s2=60;          % The shift to the left
numCords=size(cordRC,1);      % Amount of points(found coordinates)

% Increasing image window field by adding black space to edges (To avoid errors)
% Plotting coordinate points on blank matrix
blackImCoor=zeros(length(R11(:,1))+2*heightSize,length(R11(1,:))+2*widthSize);
blackImCoor(heightSize:length(blackImCoor(:,1))-heightSize-1,widthSize:length(blackImCoor(1,:))-widthSize-1)=R11;
% Plotting coordinate points on original image
origImCoor=zeros(length(R11(:,1))+2*heightSize,length(R11(1,:))+2*widthSize);
origImCoor=uint8(origImCoor);
origImCoor(heightSize:length(origImCoor(:,1))-heightSize-1,widthSize:length(origImCoor(1,:))-widthSize-1)=I2;

% adding new width and height to interest region coordinates
r1=r1+heightSize;
c1=c1+widthSize;
newcordRC=[r1 c1];

% Scanning through all the plotted points and getting the sum
for r=1:numCords
    scanBlack=blackImCoor(newcordRC(r,1)-s1:newcordRC(r,1)+heightSize-s1,newcordRC(r,2)-s2:newcordRC(r,2)+widthSize-s2);
    sumCoor(r)=sum(sum(scanBlack));       % The number of dots (pixels Sum in columns and rows)
end

[m,n]=max(sumCoor); % m has the max of countW and n is element that m occurs on.

try
    if m>=12
        licenseBox=origImCoor(newcordRC(n,1)-s1:newcordRC(n,1)+heightSize-s1,newcordRC(n,2)-s2:newcordRC(n,2)+widthSize-s2); % crop of the area of interest - license plate
        
        %--------------Displaying the location of frame------------
        % getting RBG values of the image
        Irgb(:,:,1)=singleFrame(:,:,1);
        Irgb(:,:,2)=singleFrame(:,:,2);
        Irgb(:,:,3)=singleFrame(:,:,3);
        
        % area of interent points
        a=point1(2);
        b=point1(1);
        % corners of the cropped image
        smG1=newcordRC(n,1)-s1-heightSize+a;
        smG2=newcordRC(n,1)+heightSize-s1-heightSize+a;
        smV1=newcordRC(n,2)-s2-widthSize+b;
        smV2=newcordRC(n,2)+widthSize-s2-widthSize+b;
        
        if smG1<=0
            smG1=1;
        end
        % Drawing the box in Red by connecting the edges.
        Irgb(smG1:smG2,smV1,1)=255;   % The left vertical line
        Irgb(smG1:smG2,smV2,1)=255;   % The right vertical line
        Irgb(smG1,smV1:smV2,1)=255;   % The upper horizontal line
        Irgb(smG2,smV1:smV2,1)=255;   % The lower horizontal line
        
        Irgb(smG1:smG2,smV1,2)=0;   % The left vertical line
        Irgb(smG1:smG2,smV2,2)=0;   % The right vertical line
        Irgb(smG1,smV1:smV2,2)=0;   % The upper horizontal line
        Irgb(smG2,smV1:smV2,2)=0;   % The lower horizontal line
        
        Irgb(smG1:smG2,smV1,3)=0;   % The left vertical line
        Irgb(smG1:smG2,smV2,3)=0;   % The right vertical line
        Irgb(smG1,smV1:smV2,3)=0;   % The upper horizontal line
        Irgb(smG2,smV1:smV2,3)=0;   % The lower horizontal line
        
        %      figure(6),imshow(Irgb)
        AOI=Irgb;          % Output image
        Continu=1;           % The detection signal
        % Display in GUI
        axes(handles.axes2);
        imshow(AOI); % outlined
        axes(handles.axes1);
        imshow(licenseBox); % cropped
        %-------------Recognition of numbers------------------
        [Number,Letters]=Segmentation(licenseBox,handles);
        
    else %figure(5),imshow(I1)
        AOI=singleFrame;
        Continu=0;
        Number=-1;
        Letters=-1;
        licenseBox = 0;
    end
catch
    warning('No license plate located');
end

end