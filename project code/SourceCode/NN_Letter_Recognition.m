function [outImg,N,L]=NN_Letter_Recognition(inImg,bbox)
% Auxiliary function that draws a specified bounding box in the image
outImg=inImg;
x1=bbox(:,1);     % Coordinates frame
y1=bbox(:,2);
x2=x1+bbox(:,3);
y2=y1+bbox(:,4);

%----------------Picture frame---------------------
outImg(y1:y2,x1:x2,2)=1;
outImg(y1+1:y2-1,x1+1:x2-1,2)=inImg(y1+1:y2-1,x1+1:x2-1,2);    % frame
%figure,imshow(outImg),title('Final result'),pause


%----------------Recognition of letters--------------------
%----------Scaling the image size------------
%y1
%y2
%x1
%x2
%sizeinImg=size(inImg)
Nom=inImg(y1:y2-1,x1:x2,2);   % The images in the frame
sizeNom=size(Nom);
%figure,imshow(Nom),pause

% read a sample image
inputImage = Nom;
[r,c] = size(inputImage);
scale = [24/r 14/c];        % you could scale each dimension differently

%# Initializations:
oldSize = size(inputImage);                   %# Get the size of your image
newSize = max(floor(scale.*oldSize(1:2)),1);  %# Compute the new image size

%# Compute an upsampled set of indices:

rowIndex = min(round(((1:newSize(1))-0.5)./scale(1)+0.5),oldSize(1));
colIndex = min(round(((1:newSize(2))-0.5)./scale(2)+0.5),oldSize(2));

%# Index old image to get new image:

outputImage = inputImage(rowIndex,colIndex,:);
%  figure,imshow(outputImage),pause

imStd=(im2double(outputImage));

%-------------------Networking----------------------
vh=336;                % number of inputs
n=50;                  % The number of hidden neurons
v=12;                  % The number of output neurons
h=0.5;                 % The rate of learning

% Reading matrix of weighting coefficients of the files
w1=dlmread('NN_Weights/w3.txt');
w2=dlmread('NN_Weights/w4.txt');

%----------------Forward run-------------------------
xi(1:vh)=imStd;
%------------The output value of the hidden layer----
net=zeros(1,n);
o=zeros(1,n);
for i=1:n
    xw=0;
    for j=1:vh
        % Connection weights
        % multiplying every column of x(image I) by every
        % row+1 of the w1 matrix to create a hidden layer connection weight
        xw=xw+(xi(j)*w1(j+1,i));
    end
    % Pre-activation
    % The total net inputs of the output layer
    net(i)=(1*w1(1,i))+xw;
    % Logistic activation function: squahes the neurons
    % pre-activation between 0 and 1
    % Creating the sum output weight of the hidden layer by getting the
    % exponential of net. The activation function compressing
    % values in the range 0-1
    o(i)=1/(1+exp(-net(i)));
end

%------------The output value of the output layer---
netvih=zeros(1,v);
ovih=zeros(1,v);
for i=1:v
    ow=0;
    for j=1:n
        % Connection weights
        % multiplying every column of o(Hidden layers) by every
        % row+1 of the w2 matrix to create an output layer connection weight
        ow=ow+(o(j)*w2(j+1,i));
    end
    % Pre-activation
    % The total net inputs of the output layer
    netvih(i)=(1*w2(1,i))+ow;
    % Logistic activation function: squahes the neurons
    % pre-activation between 0 and 1
    % Creating the sum output weight of the output layer by getting the
    % exponential of netvih. The activation function compressing
    % values in the range 0-1
    ovih(i)=1/(1+exp(-netvih(i)));
    if ovih(i)<0.1
        outR(i)=0;
    elseif ovih(i)>0.70
        outR(i)=1;
    else outR(i)=ovih(i);
    end
end

if outR==[1 0 0 0 0 0 0 0 0 0 0 0]
    N=1;
    L='A';
elseif outR==[0 1 0 0 0 0 0 0 0 0 0 0]
    N=2;
    L='D';
elseif outR==[0 0 1 0 0 0 0 0 0 0 0 0]
    N=3;
    L='C';
elseif outR==[0 0 0 1 0 0 0 0 0 0 0 0]
    N=4;
    L='E';
elseif outR==[0 0 0 0 1 0 0 0 0 0 0 0]
    N=5;
    L='';
elseif outR==[0 0 0 0 0 1 0 0 0 0 0 0]
    N=6;
    L='K';
elseif outR==[0 0 0 0 0 0 1 0 0 0 0 0]
    N=7;
    L='M';
elseif outR==[0 0 0 0 0 0 0 1 0 0 0 0]
    N=8;
    L='O';
elseif outR==[0 0 0 0 0 0 0 0 1 0 0 0]
    N=9;
    L='P';
elseif outR==[0 0 0 0 0 0 0 0 0 1 0 0]
    N=10;
    L='T';
elseif outR==[0 0 0 0 0 0 0 0 0 0 1 0]
    N=11;
    L='W';
elseif outR==[0 0 0 0 0 0 0 0 0 0 0 1]
    N=12;
    L='Y'; % Y and W
else N=99;   % not recognized
    L='';
end

N;
end
