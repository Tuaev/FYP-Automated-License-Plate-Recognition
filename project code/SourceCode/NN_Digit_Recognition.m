 function [outImg,N]=NN_Digit_Recognition(inImg,bbox,handles)
% Auxiliary function that draws a specified bounding box in the image
outImg=inImg;
% Frame coordinates from bounding box
x1=bbox(:,1);       % Column
y1=bbox(:,2);       % Row
x2=x1+bbox(:,3);    % Width
y2=y1+bbox(:,4);    % Height


%------------Framing every number for display(unnecessary------------
outImg(y1:y2,x1:x2,2)=1;
outImg(y1+1:y2-1,x1+1:x2-1,2)=inImg(y1+1:y2-1,x1+1:x2-1,2);    % To frame
% Sending image to GUI
axes(handles.axes4);
imshow(outImg);


%----------------Recognition of numbers--------------------
%----------Scaling the image size------------
try
    if y2>=15
        
        segImg=inImg(y1:y2-1,x1:x2);   % cropping image from license plate
        % read a sample image
        segImgA = segImg;
        [row,col] = size(segImgA);
        scale = [24/row 14/col];        % size to scale from
        
        %# Initializations:
        oldSize = size(segImgA);                   %# Get the size of your image
        newSize = max(floor(scale.*oldSize(1:2)),1);  %# Compute the new image size
        
        %# Compute an upsampled set of indices:
        rowIndex = min(round(((1:newSize(1))-0.5)./scale(1)+0.5),oldSize(1));
        colIndex = min(round(((1:newSize(2))-0.5)./scale(2)+0.5),oldSize(2));
        
        %# Index old image to get new image:
        
        outputImage = segImgA(rowIndex,colIndex,:);
        
        % Sending single digits to GUI
        axes(handles.axes5);
        imshow(outputImage),pause(0.1);
        
        %      figure(2), imshow(outputImage),pause
        
        % The same thing as above except its a Built in Matlab function for speed.
        %     imSt = imresize(Nom, [24 14]);
        
        %       figure(101),imshow(outputImage),pause % single digits.
        
        imD=(im2double(outputImage)); % converting image to double
        
        %-------------------Neural Network----------------------
        vh=336;                % number of inputs
        n=50;                  % The number of hidden neurons
        v=10;                  % The number of output neurons
        
        
        w1=dlmread('NN_Weights/w1.txt'); % trained hidden layer weights
        w2=dlmread('NN_Weights/w2.txt'); % trained output layer weights
        
        %----------------Feed forward-------------------------
        xi(1:vh)=imD;
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
            % The total net inputs of the hidden layer
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
            % Classification using threshold
            if ovih(i)<0.1
                outR(i)=0;
            elseif ovih(i)>0.30
                outR(i)=1;
            else outR(i)=ovih(i);
            end
        end
        if outR==[1 0 0 0 0 0 0 0 0 0]
            N=0;
        elseif outR==[0 1 0 0 0 0 0 0 0 0]
            N=1;
        elseif outR==[0 0 1 0 0 0 0 0 0 0]
            N=2;
        elseif outR==[0 0 0 1 0 0 0 0 0 0]
            N=3;
        elseif outR==[0 0 0 0 1 0 0 0 0 0]
            N=4;
        elseif outR==[0 0 0 0 0 1 0 0 0 0]
            N=5;
        elseif outR==[0 0 0 0 0 0 1 0 0 0]
            N=6;
        elseif outR==[0 0 0 0 0 0 0 1 0 0]
            N=7;
        elseif outR==[0 0 0 0 0 0 0 0 1 0]
            N=8;
        elseif outR==[0 0 0 0 0 0 0 0 0 1]
            N=9;
        else N=99;   % not recognized
            
        end
    end
catch
    
    warning('Character in the image is miss matched');
    N=99;
    BlackBox = questdlg('Unrecognised number', ...
        'Error', ...
        'Ok','Ok');
end
end
